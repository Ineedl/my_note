## 查看nginx版本

    nginx -v
    
## 启动nginx

    nginx
    
## nginx使用的配置文件

    nginx -t

## 关闭nginx

    nginx -s stop
    
## 重新加载nginx配置文件

    nginx -s reload
    
* 该方式为热更新，当nginx正在处理请求时，该加载不会中止这些请求。