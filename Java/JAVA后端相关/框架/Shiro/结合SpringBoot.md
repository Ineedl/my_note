## maven依赖

```xml
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-spring</artifactId>
    <version>1.6.0</version>
</dependency>
```

## 实例

`Shiro配置类`

```dart
package org.fh.config;
import org.apache.shiro.cache.ehcache.EhCacheManager;
import org.apache.shiro.spring.LifecycleBeanPostProcessor;
import org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor;
import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.web.mgt.DefaultWebSecurityManager;
import org.fh.realm.MyShiroRealm;
import org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import net.sf.ehcache.CacheManager;
import java.util.LinkedHashMap;
import java.util.Map;
/**
 * 说明：Shiro 配置
 * 作者：FH Admin
 * from：fhadmin.cn
 */
@Configuration
@EnableTransactionManagement
public class ShiroConfiguration {
  /**
   * ShiroFilterFactoryBean 处理拦截资源文件问题
   * 注意：单独一个ShiroFilterFactoryBean配置是或报错的，因为在
   * 初始化ShiroFilterFactoryBean的时候需要注入：SecurityManager
   * 
   * Filter Chain定义说明 
   * 1、一个URL可以配置多个Filter，使用逗号分隔
   * 2、当设置多个过滤器时，全部验证通过，才视为通过
   * 3、部分过滤器可指定参数，如perms，roles
   */
  
  @Bean(name = "shiroFilter")
  public ShiroFilterFactoryBean shiroFilterFactoryBean(DefaultWebSecurityManager securityManager) {
    ShiroFilterFactoryBean factoryBean = new MyShiroFilterFactoryBean();
    factoryBean.setSecurityManager(securityManager);
    factoryBean.setLoginUrl("/");         // 如果不设置默认会自动寻找Web工程根目录下的"/login.jsp"页面
    factoryBean.setSuccessUrl("/main/index");   // 登录成功后要跳转的连接
    factoryBean.setUnauthorizedUrl("/");
    loadShiroFilterChain(factoryBean);
    return factoryBean;
  }
  
  /**
   * 加载ShiroFilter权限控制规则
   */
  private void loadShiroFilterChain(ShiroFilterFactoryBean factoryBean) {
    /* 下面这些规则配置最好配置到配置文件中 */
    Map<String, String> filterChainMap = new LinkedHashMap<String, String>();
    
    /*
     authc：该过滤器下的页面必须验证后才能访问，它是Shiro内置的一个拦截器 org.apache.shiro.web.filter.authc.FormAuthenticationFilter
     anon：它对应的过滤器里面是空的,什么都没做,可以理解为不拦截
     
     
     authc:所有url都必须认证通过才可以访问; 
     anon:所有url都都可以匿名访问
     
     当然，后面也可以是用户自定义的一个筛选器
     
        Map<String, Filter> filtersMap = shiroFilter.getFilters();
        filtersMap.put("token", new JwtFilter());
        shiroFilter.setFilters(filtersMap);
     
     		filterChainMap.put("/login", "token");
     		
    */
    filterChainMap.put("/404/**", "anon");
    filterChainMap.put("/assets/**", "anon");
    filterChainMap.put("/admin/check", "anon");
    filterChainMap.put("/admin/islogin", "anon");
    filterChainMap.put("/admin/register", "anon");
    filterChainMap.put("/textextraction/add", "anon");
    filterChainMap.put("/**", "authc");
    factoryBean.setFilterChainDefinitionMap(filterChainMap);
  }
  
  @Bean
    public EhCacheManager ehCacheManager(CacheManager cacheManager) {
        EhCacheManager em = new EhCacheManager();
        em.setCacheManager(cacheManager);
        return em;
    }
  @Bean(name = "myShiroRealm")
  public MyShiroRealm myShiroRealm(EhCacheManager ehCacheManager) {
    MyShiroRealm realm = new MyShiroRealm();
    realm.setCacheManager(ehCacheManager);
    return realm;
  }
  @Bean(name = "lifecycleBeanPostProcessor")
  public LifecycleBeanPostProcessor lifecycleBeanPostProcessor() {
    return new LifecycleBeanPostProcessor();
  }
  @Bean
  public DefaultAdvisorAutoProxyCreator defaultAdvisorAutoProxyCreator() {
    DefaultAdvisorAutoProxyCreator creator = new DefaultAdvisorAutoProxyCreator();
    creator.setProxyTargetClass(true);
    return creator;
  }
  @Bean(name = "securityManager")
  public DefaultWebSecurityManager defaultWebSecurityManager(MyShiroRealm realm,  EhCacheManager ehCacheManager) {
    DefaultWebSecurityManager securityManager = new DefaultWebSecurityManager();
    securityManager.setRealm(realm);  // 设置realm
    securityManager.setCacheManager(ehCacheManager);
    return securityManager;
  }
  @Bean
  public AuthorizationAttributeSourceAdvisor authorizationAttributeSourceAdvisor(
      DefaultWebSecurityManager securityManager) {
    AuthorizationAttributeSourceAdvisor advisor = new AuthorizationAttributeSourceAdvisor();
    advisor.setSecurityManager(securityManager);
    return advisor;
  }
  /*
  
  1.LifecycleBeanPostProcessor，这是个DestructionAwareBeanPostProcessor的子类，负责org.apache.shiro.util.Initializable类型bean的生命周期的，初始化和销毁。主要是AuthorizingRealm类的子类，以及EhCacheManager类。
  
  
  2.HashedCredentialsMatcher，这个类是为了对密码进行编码的，防止密码在数据库里明码保存，当然在登陆认证的生活，这个类也负责对form里输入的密码进行编码。
  
  
  3.ShiroRealm，这是个自定义的认证类，继承自AuthorizingRealm，负责用户的认证和权限的处理，可以参考JdbcRealm的实现，当然自定义Realm可以有多个。
  
  
  4.EhCacheManager，缓存管理，用户登陆成功后，把用户信息和权限信息缓存起来，然后每次用户请求时，放入用户的session中，如果不设置这个bean，每个请求都会查询一次数据库。
  
  
  5.SecurityManager，权限管理，这个类组合了登陆，登出，权限，session的处理，是个比较重要的类。
  
  
  6.ShiroFilterFactoryBean，是个factorybean，为了生成ShiroFilter。它主要保持了三项数据，securityManager，filters，filterChainDefinitionManager。
  
  
  7.DefaultAdvisorAutoProxyCreator，Spring的一个bean，由Advisor决定对哪些类的方法进行AOP代理。
  
  
  8.AuthorizationAttributeSourceAdvisor，shiro里实现的Advisor类，内部使用AopAllianceAnnotationsAuthorizingMethodInterceptor来拦截用以下注解的方法。
  
  
   */
}
```

`自定义筛选器`

```java
//shiro自定义筛选器示例
//JWT筛选器

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

