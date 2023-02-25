## UserRealm

```java
package com.magicforest.common.support.shiro;

import com.magicforest.common.constant.MenuEnum;
import com.magicforest.common.support.redis.RedisCacheService;
import com.magicforest.common.utils.*;
import com.magicforest.core.sys.entity.SysMenuEntity;
import com.magicforest.core.sys.entity.UserInfo;
import com.magicforest.core.sys.service.ISysMenuService;
import com.magicforest.core.sys.entity.SysUserEntity;
import com.magicforest.core.sys.service.ISysUserService;
import org.apache.commons.lang.StringUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * 用户认证realm
 */
public class UserRealm extends AuthorizingRealm {
    private static Logger logger = LoggerFactory.getLogger(UserRealm.class);

    private ISysUserService sysUserService;
    private ISysMenuService sysMenuService;
    private JwtUtils jwtUtils;
    private JwtConfig jwtConfig;
    private RedisCacheService redisCacheService;


    public UserRealm() {
        jwtUtils = (JwtUtils) SpringContextUtils.getBean("jwtUtils");
        jwtConfig = (JwtConfig) SpringContextUtils.getBean("jwtConfig");
        sysUserService = (ISysUserService) SpringContextUtils.getBean("sysUserService");
        sysMenuService = (ISysMenuService) SpringContextUtils.getBean("sysMenuService");
        sysMenuService = (ISysMenuService) SpringContextUtils.getBean("sysMenuService");
        redisCacheService = (RedisCacheService) SpringContextUtils.getBean("redisCacheService");
    }

    /**
     * 设置对应的token类型
     * 必须重写此方法，不然Shiro会报错
     *
     * @param token 令牌
     * @return boolean
     */
    @Override
    public boolean supports(AuthenticationToken token) {
        return token instanceof JwtToken;
    }

    /**
     * 权限验证
     *
     * @param principals
     * @return
     */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        Long userId = ShiroUtils.getUserId();
        Set<String> roles = sysUserService.listUserRoles(userId);
        Set<String> perms = sysUserService.listUserPerms(userId);
        SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
        info.setRoles(roles);
        info.setStringPermissions(perms);
        return info;
    }

    /**
     * 登录验证
     *
     * @param authenticationToken
     * @return
     * @throws AuthenticationException
     */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken authenticationToken) throws AuthenticationException {
        String token = (String) authenticationToken.getCredentials();
      	//验证token格式
        if (!jwtUtils.parseToken(token)) {
            throw new AuthenticationException("Token认证失败");
        }
      	//认证token
        if (!jwtUtils.verify(token)) {
            //删除缓存用户信息
            redisCacheService.del(MD5Utils.encrypt(token));
            throw new AuthenticationException("Token已失效");
        }
        String userId = jwtUtils.getUserId(token);
        if (StringUtils.isEmpty(userId)) {
            throw new AuthenticationException("用户ID为空，token被篡改");
        }
        // 查询数据库此用户
        UserInfo userInfo = null;
        Object userInfoObj = redisCacheService.get(MD5Utils.encrypt(token));
      	//此处缓存防止总是查数据库
        if (userInfoObj != null) {
            String userInfoJson = (String) userInfoObj;
            userInfo = JsonUtil.toBean(userInfoJson, UserInfo.class);
        } else {
            userInfo = sysUserService.getUserInfoById(Long.parseLong(userId));
            if (userInfo == null) {
                throw new UnknownAccountException("无对应用户不存在");
            }
            // 账号锁定
            if (userInfo.getStatus() == 0) {
                throw new LockedAccountException("账号已被锁定，请联系管理员");
            }
            List<SysMenuEntity> sysMenuList = sysUserService.selectUserPermissionByUserId(userInfo.getUserId());
            //如果是超级管理员，赋予所有权限
            if ("admin".equals(userInfo.getUsername()) || "devUser".equals(userInfo.getUsername())) {
                sysMenuList = sysMenuService.list();
            }
            //用户按钮权限
            List<String> userBtnList = new ArrayList<>();
            //用户菜单权限
            List<String> userMenuList = new ArrayList<>();
            for (SysMenuEntity sysMenu : sysMenuList) {
                if (sysMenu.getType() == MenuEnum.BUTTON.getCode()) {
                    userBtnList.add(sysMenu.getPerms());
                } else if (sysMenu.getType() == MenuEnum.MENU.getCode()) {
                    userMenuList.add(sysMenu.getUrl());
                }
            }
            String userBtnPermissions = StringUtils.join(userBtnList.toArray(), "|");
            String userMenuPermissions = StringUtils.join(userMenuList.toArray(), "|");
            userInfo.setUserBtnPermissions(userBtnPermissions);
            userInfo.setUserMenuPermissions(userMenuPermissions);
            //失效时间按全局（单位：s）
          	//此处缓存登陆后用户信息 用加密后的token对应
            redisCacheService.set(MD5Utils.encrypt(token), JsonUtil.convertObjectToJSON(userInfo), jwtConfig.getTokenExpireTime() * 60);
        }

        SimpleAuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(userInfo, token, getName());
        return authenticationInfo;
    }


}
```

## ShiroUtils工具类

```java
package com.magicforest.common.utils;

import com.magicforest.core.sys.entity.UserInfo;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;


/**
 * Shiro工具类
 *
 * @author Boshen
 */
public class ShiroUtils {

    /**
     * 获取session
     *
     * @return
     */
    public static Session getSession() {
        return SecurityUtils.getSubject().getSession();
    }

    /**
     * 获取当前用户
     *
     * @return
     */
    public static Subject getSubject() {
        return SecurityUtils.getSubject();
    }

    /**
     * 获取当前用户信息
     *
     * @return
     */
    public static UserInfo getUserInfo() {
        return (UserInfo) SecurityUtils.getSubject().getPrincipal();
    }

    /**
     * 获取当前登录用户id
     *
     * @return
     */
    public static Long getUserId() {
        return getUserInfo().getUserId();
    }

    /**
     * 设置session域参数
     *
     * @param key
     * @param value
     */
    public static void setSessionAttribute(Object key, Object value) {
        getSession().setAttribute(key, value);
    }

    /**
     * 获取session域参数
     *
     * @param key
     * @return
     */
    public static Object getSessionAttribute(Object key) {
        return getSession().getAttribute(key);
    }

    /**
     * 是否登录
     *
     * @return
     */
    public static boolean isLogin() {
        return SecurityUtils.getSubject().getPrincipal() != null;
    }

    /**
     * 登出
     */
    public static void logout() {
        SecurityUtils.getSubject().logout();
    }

    /**
     * 获取验证码
     *
     * @param key
     * @return
     */
    public static String getKaptcha(String key) {
        String kaptcha = getSessionAttribute(key).toString();
        getSession().removeAttribute(key);
        return kaptcha;
    }

}
```

## JwtFilter

```java
package com.magicforest.common.support.shiro;

import com.alibaba.fastjson.JSON;
import com.magicforest.common.constant.RestApiConstant;
import com.magicforest.common.basecrud.entity.ApiResult;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.util.TextUtils;
import org.apache.shiro.web.filter.authc.BasicHttpAuthenticationFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.cors.CorsUtils;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @Description Token验证和刷新
 */
@Slf4j
public class JwtFilter extends BasicHttpAuthenticationFilter {
    private static Logger logger = LoggerFactory.getLogger(JwtFilter.class);

    /**
     * 监测authorization是否为空
     *
     * @param request
     * @param response
     * @return
     */
    @Override
    protected boolean isLoginAttempt(ServletRequest request, ServletResponse response) {
        HttpServletRequest servletRequest = (HttpServletRequest) request;
        String athorization = servletRequest.getHeader(RestApiConstant.AUTH_TOKEN);
        return !TextUtils.isEmpty(athorization);
    }

    /**
     * 是否允许访问
     *
     * @param request
     * @param response
     * @param mappedValue
     * @return
     */
    @Override
    protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) {
        if (isLoginAttempt(request, response)) {
            try {
                executeLogin(request, response);
                return true;
            } catch (Exception e) {
                logger.info("---登录验证---", e.getMessage());
                response401(response);
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * 对跨域提供支持
     */
    @Override
    protected boolean preHandle(ServletRequest request, ServletResponse response) throws Exception {
        HttpServletRequest servletRequest = (HttpServletRequest) request;
        HttpServletResponse servletResponse = (HttpServletResponse) response;
        servletResponse.setCharacterEncoding("UTF-8");
        servletResponse.setContentType("application/json; charset=utf-8");
        servletResponse.setHeader("Access-Control-Allow-Origin", servletRequest.getHeader("Origin"));
        servletResponse.setHeader("Access-Control-Allow-Credentials", "true");
        //servletResponse.setHeader("Access-Control-Allow-Origin", corsAllowUrl);
        servletResponse.setHeader("Access-Control-Allow-Headers", "x-requested-with, Content-Type, Authorization, credential, X-XSRF-TOKEN");
        servletResponse.setHeader("Access-Control-Expose-Headers", "x-requested-with, Content-Type, Authorization, credential, X-XSRF-TOKEN");
        String method = servletRequest.getMethod();
        logger.info("---Request->" + method + "-" + servletRequest.getRequestURI());
        if (CorsUtils.isCorsRequest(servletRequest) && method.equals("OPTIONS")) {
            return true;
        }
        return super.preHandle(request, response);
    }

    /**
     * 登录验证
     *
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @Override
    protected boolean executeLogin(ServletRequest request, ServletResponse response) throws Exception {
        // 首先获取authorization
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;
        String token = httpServletRequest.getHeader(RestApiConstant.AUTH_TOKEN);

        if (token == null) {
            return false;
        }
        JwtToken jwtToken = new JwtToken(token);
        // 提交给realm进行登入，如果错误他会抛出异常并被捕获
        getSubject(request, response).login(jwtToken);
        // 如果没有抛出异常则代表登入成功，返回true
        return true;

    }

    /**
     * 重写 onAccessDenied 方法，避免父类中调用再次executeLogin
     *
     * @param request
     * @param response
     * @param mappedValue
     * @return
     * @throws Exception
     */
    @Override
    protected boolean onAccessDenied(ServletRequest request, ServletResponse response, Object mappedValue) throws Exception {
        sendChallenge(request, response);
        return false;
    }

    /**
     * 返回非法请求信息
     *
     * @param resp
     */
    private void response401(ServletResponse resp) {
        HttpServletResponse httpServletResponse = (HttpServletResponse) resp;
        httpServletResponse.setStatus(HttpStatus.UNAUTHORIZED.value());
        httpServletResponse.setCharacterEncoding("UTF-8");
        httpServletResponse.setContentType("application/json; charset=utf-8");
        PrintWriter out = null;
        try {
            out = httpServletResponse.getWriter();
            out.print(JSON.toJSONString(ApiResult.failure("身份认证失败，用户没有访问权限")));
            out.flush();
        } catch (IOException e) {
            log.error("response401 返回Response信息出现IOException异常:" + e.getMessage());
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }

}
```

## LoginController

```java
package com.magicforest.app.sys.web.sys;

import com.magicforest.common.annotation.SysLog;
import com.magicforest.common.constant.RedisConstant;
import com.magicforest.common.basecrud.entity.ApiResult;
import com.magicforest.common.support.properties.GlobalProperties;
import com.magicforest.common.support.redis.RedisCacheService;
import com.magicforest.common.utils.*;
import com.magicforest.core.sys.entity.SysUserEntity;
import com.magicforest.core.sys.entity.UserInfo;
import com.magicforest.core.sys.service.ISysUserService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.apache.shiro.authc.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;
import java.util.Map;

/**
 * 用户controller
 */
@Slf4j
@RestController
public class LoginController {

    @Autowired
    private ISysUserService ISysUserService;

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private RedisCacheService redisCacheService;

    /**
     * 手机发送验证码
     */
    @SysLog("发送验证码")
    @RequestMapping(value = "/login/send", method = RequestMethod.POST)
    public ApiResult send(@RequestBody SysUserEntity userEntity) {

        if (StringUtils.isBlank(userEntity.getUsername())) {
            return ApiResult.failure("用户名(手机号)不能为空");
        }

        // 查询用户
        SysUserEntity sysUserEntity = ISysUserService.getByUserName(userEntity.getUsername());
        if (sysUserEntity == null) {
            return ApiResult.failure("未找到该用户");
        }

        Map<String, Object> result = SmsUtil.sendSms(userEntity.getUsername());

        if (result.isEmpty()) {
            return ApiResult.failure("验证码发送失败");
        }

        if (false == redisCacheService.set(RedisConstant.KEY_VERIFY_CODE_PREFIX + userEntity.getUsername(), result.get("code"), 900)) {
            return ApiResult.successMsg("缓存存储失败");
        }


        return ApiResult.successMsg("验证码发送成功");
    }


    /**
     * 登录
     */
    @SysLog("登录")
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public ApiResult login(@RequestBody SysUserEntity userEntity) {
        //账号或者手机号
        String username = userEntity.getUsername();
        String password = userEntity.getPassword();
        String code = userEntity.getVerifyCode();
        try {
            // code不为空就是验证码登录
            if (!StringUtils.isBlank(code)) {
                String kaptcha = (String) redisCacheService.get(RedisConstant.KEY_VERIFY_CODE_PREFIX + username);
                log.info(username + "登录正确验证码:" + kaptcha);
                if (!code.equalsIgnoreCase(kaptcha)) {
                    return ApiResult.failure("验证码错误");
                }
            } else {// 用户名验证
                if (StringUtils.isBlank(username)) {
                    return ApiResult.failure("用户名不能为空");
                }
                // 密码验证
                if (StringUtils.isBlank(password)) {
                    return ApiResult.failure("密码不能为空");
                }

            }

            // 查询用户
            SysUserEntity sysUserEntity = ISysUserService.getByUserName(username);
            if (sysUserEntity == null) {
                return ApiResult.failure("未找到该用户");
            }

            if (StringUtils.isBlank(code)) {
                username = sysUserEntity.getUsername();
                password = MD5Utils.encrypt(username, password);
                // 密码错误
                if (!password.equals(sysUserEntity.getPassword())) {
                    throw new IncorrectCredentialsException("密码不正确");
                }
            }
            // 账号锁定
            if (sysUserEntity.getStatus() == 0) {
                throw new LockedAccountException("账号已被锁定，请联系管理员");
            }
            // 生成token
            Date currDate = new Date();
            String randomKey = TokenUtils.generateValue();
            String token = jwtUtils.generateToken(sysUserEntity.getUsername(),
                    String.valueOf(sysUserEntity.getUserId()), randomKey, currDate.getTime());
            if (StringUtils.isBlank(token)) {
                return ApiResult.failure();
            }
            return ApiResult.success(token);
        } catch (UnknownAccountException | IncorrectCredentialsException | LockedAccountException e) {
            log.info(e.getMessage());
            return ApiResult.failure("账号或密码错误");
        } catch (AuthenticationException e) {
            log.info(e.getMessage());
            return ApiResult.failure("账号未授权");
        }
    }

    /**
     * 退出
     */
    @SysLog("退出系统")
    @RequestMapping("/logout")
    public ApiResult logout() {
        try {
            UserInfo userInfo = ShiroUtils.getUserInfo();
            if (userInfo != null) {
                String tokenKey = JwtUtils.getUserTokenKey(ShiroUtils.getUserInfo().getUsername());
                redisCacheService.del(tokenKey);
                ShiroUtils.logout();
            }
            return ApiResult.success();
        } catch (Exception e) {
            e.printStackTrace();
            return ApiResult.failure("退出异常！");
        }
    }

}

```

