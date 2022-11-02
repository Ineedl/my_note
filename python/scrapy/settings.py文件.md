## 配置文件

该文件中定义了一些scrapy中的相关配置，用于提供给用户修改

## 常见配置

* BOT_NAME：大项目名称

```python
BOT_NAME = 'my_scrapy'
```

* CONCURRENT_REQUESTS

```python
CONCURRENT_REQUESTS = 32			#scrapy下载器线程数，默认16
```

* CONCURRENT_ITEMS

```python
CONCURRENT_ITEMS = 100				#所有并发的最大数量默认100
```

* CONCURRENT_REQUESTS_PER_DOMAIN

```
CONCURRENT_REQUESTS_PER_DOMAIN = 8			#对单个网站进行并发请求的最大值，默认8
```

* CONCURRENT_REQUESTS_PER_IP

```python
CONCURRENT_REQUESTS_PER_IP = 0	#对单个ip进行并发请求的最大线程数，默认0
```

* SPIDER_MODULES

```python
SPIDER_MODULES = ['my_scrapy.spiders']
```

* NEWSPIDER_MODULE

```python
NEWSPIDER_MODULE = 'my_scrapy.spiders'
```

* USER_AGENT：请求头使用的默认UA 

```python
USER_AGENT = r'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36'
```

* ROBOTSTXT_OBEY：是否遵守robots协议，robots协议为各个厂家规定的一个口头协议，表示互相不能爬取对方，在域名后加上robots.txt既可以查看某个厂家的协议规定内容，开启robots协议会无法爬取某些网站。

```python
ROBOTSTXT_OBEY = False
```

* LOG_LEVEL：日志等级

```python
LOG_LEVEL = 'ERROR'
```

* LOG_FILE：日志输出文件路径

```python
LOG_FILE = 'tmp.log'
```

* COOKIES_ENABLED ：是否使用默认请求头中的cookie

```python
COOKIES_ENABLED = True
#为False时
#scrapy 关闭自带的 CookiesMiddleware 中间件，response 设置的 cookie 失效
#使用 cookies 设置的 cookie 失效。
#使用 headers 设置的 cookie 保留。

#为True时
#scrapy 启动自带的 CookiesMiddleware 中间件，为请求自动添加服务器响应的 cookie，
#如果我们在 Request 中，使用 cookies 参数添加 cookie 时， 我们添加的 cookie 会额外加入到请求头中，如果响应有重名设置，则覆盖。（即，cookies 参数的cookie优先，但是 response 里的 cookie 也一个不少）
#如果我们使用 headers 参数添加 cookie，headers添加的 cookie 会失效，被响应 cookie 完全覆盖。（即，headers里设置的 cookie 无效）
```

* DEFAULT_REQUEST_HEADERS：默认请求头

```python
DEFAULT_REQUEST_HEADERS = {
    'Host': 'www.haodf.com',
    'Connection': 'keep-alive',
    'Cookie':'acw_tc=74d3b7a716545902959307938ec0ee0b33a343e59b35b9a5ac91ba924c'
}
#如果想在该设置中使用Cookie，则请设置 COOKIES_ENABLED = True
```

* SPIDER_MIDDLEWARES：请求中间件

```python
SPIDER_MIDDLEWARES = {																				#可以不开启，有默认中间件
   'my_scrapy.middlewares.MyScrapySpiderMiddleware': 543,			#数字代表调用优先级，越小越优先
}
```

* DOWNLOADER_MIDDLEWARES：下载器中间件

```python
DOWNLOADER_MIDDLEWARES = {																		#可以不开启，有默认中间件
   'my_scrapy.middlewares.MyScrapyDownloaderMiddleware': 543,	#数字代表调用优先级，越小越优先
}
```



* ITEM_PIPELINES：使用的管道

```python
ITEM_PIPELINES = {																		#默认可以不开启
   'my_scrapy.pipelines.MyScrapyPipeline': 300,				#数字代表优先级，越小越优先
}
```

