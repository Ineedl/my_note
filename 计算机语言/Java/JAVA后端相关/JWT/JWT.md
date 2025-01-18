## JWT

JSON Web Token

* JWT不应该用来放私密数据，因为Base64编码是可逆的。

`结构组成`

* 标头(Header):通常由两部分组成，令牌的类型与签名算法(比如HMAC SHA256)，他会被 Base64 编码为JWT的第一部分。
* 有效载荷(Payload):其中包含声明。声明是有关实体和其他数据的声明，他会被Base64编码为JWT的第二部分。
* 签名(Signature):Signature使用编码后的Header与Payload以及一个密钥、然后使用header中指定的签名算法进行签名、其作用是保证JWT中途被篡改能感觉出来。

`例子`

```json
//header
{
  "alg":"HS256",
  "type":"JWT"
}

//Payload
{
  "id":123456,
  "name":"Tom",
  "admin":true
}

//Signature
//加入使用HS256签名
Signature = HMACSHA256(base64UrlEncode(header) + "." + base64UrlEncode(paylod),secret);
```

## 简单实例

```xml
<dependency>
  <groupId>com.auth0</groupId>
  <artifactId>java-jwt</artifactId>
  <version>3.5.0</version>
</dependency>
```

```java
package org.example;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.Verification;
import org.junit.Test;

import java.util.Calendar;
import java.util.HashMap;

public class AppTest4 {
    @Test
    public void A(){
        HashMap<String,Object> map = new HashMap<>();

        Calendar instance = Calendar.getInstance();
        instance.add(Calendar.SECOND,600);

        String token = JWT.create()
                .withHeader(map)                    //head
                .withClaim("userId",1)
                .withClaim("userName","cjh")
                .withExpiresAt(instance.getTime())    //令牌过期时间
                .sign(Algorithm.HMAC256("!@#$%@%"));    //密钥与对应算法
        System.out.println(token);
    }

    @Test
        public void B(){
        JWTVerifier jwtVerifier = JWT.require(Algorithm.HMAC256("!@#$%@%")).build();        //使用对应算法与密钥
        DecodedJWT verify = jwtVerifier.verify("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyTmFtZSI6ImNqaCIsImV4cCI6MTY3NzMxODI3OSwidXNlcklkIjoxfQ.XT91OzmN0MpVK41GC_vcRLjifxmHalscVbMm6P4YgQc");
        System.out.println(verify.getClaims().get("userId").asInt());   //要拿什么就转换成啥类型
        System.out.println(verify.getClaims().get("userName").asString());   //要拿什么就转换成啥类型
        System.out.println(verify.getExpiresAt());                      //拿到过期时间
    }
}

```

`常见异常`

* SignatureVerificationException:签名不一致
* TokenExpiredException:令牌过期
* AlgorithmMismatchException:算法不匹配
* InvalidClaimException:失效的payload