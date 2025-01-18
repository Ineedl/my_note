## 新特性
jdk7后，支持再try后面跟随()来管理释放资源。

`java代码示例`
```

try (
    InputStream fis = new FileInputStream(source);
    OutputStream fos = new FileOutputStream(target)){
    
    byte[] buf = new byte[8192];
    
    int i;
    while ((i = fis.read(buf)) != -1) {
      fos.write(buf, 0, i);
    }
}
catch (Exception e) {
    e.printStackTrace();
}


```

try括号内的资源会在try语句结束后自动释放，前提是这些可关闭的资源必须实现 java.lang.AutoCloseable 接口。无论是否有异常抛出。