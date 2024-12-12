如果不考虑升级 Apollo，那么直接修改源码是一个明确且可控的方案。以下是详细的步骤描述，确保拦截器逻辑能够成功应用到 Apollo Config Server 的请求处理中。

---

### **1. 修改点概述**
Apollo Config Server 是基于 Spring Boot 构建的，因此可以通过修改 Spring Boot 的配置类或核心控制器逻辑来添加拦截器或过滤器。

**需要修改的文件：**
- **`ConfigApplication.java`**：添加 Spring Boot 的拦截器配置。
- **`BearerTokenInterceptor`**：实现自定义的拦截逻辑。

---

### **2. 具体修改步骤**

#### **2.1 添加拦截器实现**

在 `apollo-configservice` 项目中，创建拦截器类，用于验证请求中的 Bearer Token。

**文件路径：**
`apollo-configservice/src/main/java/com/ctrip/framework/apollo/configservice/interceptor/BearerTokenInterceptor.java`

**拦截器代码：**
```java
package com.ctrip.framework.apollo.configservice.interceptor;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Component
public class BearerTokenInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 从请求头中获取 Authorization
        String authorizationHeader = request.getHeader("Authorization");
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            String token = authorizationHeader.substring(7); // 提取 Token
            if (isValidToken(token)) {
                return true; // 验证成功，允许请求继续
            }
        }
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 返回 401 未授权
        return false; // 拦截请求
    }

    private boolean isValidToken(String token) {
        // 自定义 Token 验证逻辑
        return "valid-token".equals(token); // 仅供测试，实际应调用你的验证服务
    }
}
```

---

#### **2.2 注册拦截器**

在 Spring Boot 的配置中注册自定义拦截器。

**修改文件：**
`apollo-configservice/src/main/java/com/ctrip/framework/apollo/configservice/ConfigApplication.java`

**修改内容：**
在 `ConfigApplication` 文件中新增一个内部类，配置拦截器：

```java
package com.ctrip.framework.apollo.configservice;

import com.ctrip.framework.apollo.configservice.interceptor.BearerTokenInterceptor;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@SpringBootApplication
public class ConfigApplication {

    public static void main(String[] args) {
        SpringApplication.run(ConfigApplication.class, args);
    }

    @Configuration
    public static class WebConfig implements WebMvcConfigurer {

        private final BearerTokenInterceptor bearerTokenInterceptor;

        public WebConfig(BearerTokenInterceptor bearerTokenInterceptor) {
            this.bearerTokenInterceptor = bearerTokenInterceptor;
        }

        @Override
        public void addInterceptors(InterceptorRegistry registry) {
            // 注册自定义拦截器，对所有请求生效
            registry.addInterceptor(bearerTokenInterceptor).addPathPatterns("/**");
        }
    }
}
```

---

#### **2.3 添加拦截器到 Spring 容器**

确保拦截器能够被 Spring 自动扫描并注册到上下文中。在 `apollo-configservice` 的 Spring Boot 主包下新增或修改 `@ComponentScan` 的路径，确保包含 `interceptor` 包。

**修改 `ConfigApplication`：**
```java
@SpringBootApplication(scanBasePackages = "com.ctrip.framework.apollo")
public class ConfigApplication {
    public static void main(String[] args) {
        SpringApplication.run(ConfigApplication.class, args);
    }
}
```

---

### **3. 编译和运行**

#### **3.1 编译项目**
进入 Apollo 项目的根目录，执行以下命令重新构建 Config Server：

```bash
mvn clean package -DskipTests
```

#### **3.2 运行服务**
找到打包好的 Config Server JAR 文件（路径通常为 `apollo-configservice/target/apollo-configservice-x.y.z.jar`），运行修改后的 JAR：

```bash
java -jar apollo-configservice-x.y.z.jar
```

---

### **4. 验证拦截器**

启动 Apollo 后，向 Config Server 发起请求，验证拦截器逻辑是否生效：

#### **示例请求**
```bash
curl -H "Authorization: Bearer valid-token" http://localhost:8080/configs/{appId}/{clusterName}/{namespaceName}
```

#### **验证点**
1. 当 `Authorization` 头部包含正确的 Bearer Token 时，返回正常的 Apollo 配置数据。
2. 当 `Authorization` 头部缺失或 Token 无效时，返回 HTTP 401。

---

### **总结**

通过上述步骤，你可以：
1. 自定义拦截器 `BearerTokenInterceptor` 来验证 Token。
2. 在 `ConfigApplication` 中注册拦截器，使其生效。
3. 无需调整业务逻辑即可实现安全性控制。

这种方式灵活性高，且能够完全自定义验证逻辑，非常适合在不依赖外部工具的前提下实现细粒度的控制。
