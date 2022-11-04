## 介绍

selenium本来是一个web自动化测试工具，可以像web浏览器一样一步步的模拟http请求，并返回请求后的完整页面，但是就是因为这，导致其某些时候用来做爬虫时，可以用xpath来从完整的页面中提取平时http模拟请求非常难以拿到的数据。

* 本笔记只介绍selenium的爬虫用法

## 使用步骤

* 此处只介绍单线程的selenium数据提取

1. 安装对应浏览器的引擎(通常只是一个应用程序，放在配置了环境变量能访问即可)
2. 导入对应引擎的库，并初始化一个引擎的引用

```python
#比如google浏览器的
import selenium.webdriver.chrome.webdriver


wd = webdriver.Chrome()  		#该引用后续发送http请求相关页面时，将会打开一个浏览器，模拟进行浏览器请求。
								#注意一个引擎引用一般只能在一个页面上操作，目前不考虑多页面

#当然也可以手动指定驱动位置
wd = webdriver.Chrome("F:/google驱动/chromedriver.exe")   
```

3. 打开想要获取的完整页面的url，打开后会同浏览器访问了该网址一样，如果访问后有相关跳转，模拟的浏览器也会跳转。

```python
wd.get("https://iot.console.aliyun.com/product")		#会打开一个浏览器，最终会到阿里云云平台登录页面
```

4. 从完整打开的网页中获取相关标签的元素(比如文本框，密码框，按钮，文字显示标签等)，一般使用xpath来匹配元素，当然也可以使用别的方法

```python
#此处用XPATH匹配的方法获取一个div
wd.find_element(By.XPATH, "//*[contains(text(),'clientId')]/following-sibling::div/child::span").
```

5. 从匹配的标签中获取数据，或操作这些标签完成进一步操作

* 注意，selenium不同于http爬虫，如果需要完整的爬取某一个页面，必须要让程序延时，等待模拟引擎将最终页面加载完毕。对于登录跳转也是相同原理，如果某页面a需要对某个页面b操作后才会显现，最好是等待b操作完后再跳转到a，然后等a加载完。

```python
#该函数获取阿里云登陆页面的username与password，并用用户数据填充，并且点击登录按钮，跳转到下一个页面
def login_web():
    wd = webdriver.Chrome()
    wd.get("https://iot.console.aliyun.com/product")
    wd.find_element(By.XPATH, "//*[contains(text(),'RAM用户')]").click()	#点击'ram用户'按钮，切换登陆方式
    wd.find_element(By.XPATH, "//*[contains(@name,'username')]").send_keys("cjh's username")
    wd.find_element(By.XPATH, "//*[contains(@class,'sc-bWXABl')]").click() #输入 username后需要点击下一步按钮才能输入密码
    wd.find_element(By.XPATH, "//*[contains(@name,'password')]").send_keys("cjh's password")
    wd.find_element(By.XPATH, "//*[contains(@type,'submit')]").click()		#点击登录页面
    time.sleep(5)							#等待登录页面跳转
    print("web login success")
    return wd
  
  
#获取阿里云物联网平台设备的mqtt连接信息，需要有上一步登录做支撑才能看到设备数据页面  
def get_device_info(wd, product_key, device_sn):
    wd.get("https://iot.console.aliyun.com/devices/"+product_key+"/"+device_sn+"/1")
    time.sleep(web_wait_time_sceond)
    wd.find_element(By.XPATH, "//*[contains(text(),'MQTT 连接参数')]/following-sibling::div/child::button").click()				#该标签被点击后才会弹出数据显示框
    time.sleep(0.5)
    client_id = wd.find_element(By.XPATH, "//*[contains(text(),'clientId')]/following-sibling::div/child::span").text
    username = wd.find_element(By.XPATH, "//*[contains(text(),'username')]/following-sibling::div/child::span").text
    password = wd.find_element(By.XPATH, "//*[contains(text(),'passwd')]/following-sibling::div/child::span").text
    mqtt_host_url = wd.find_element(By.XPATH, "//*[contains(text(),'mqttHostUrl')]/following-sibling::div/child::span").text
    #上面四个text数据如果不是模拟的情况下，阿里云会使用一个非对称加密的方式传输，一般的http请求爬虫爬取很难获取到该数据
    port = wd.find_element(By.XPATH, "//*[contains(text(),'port')]/following-sibling::div/child::span").text
    info = device_info(product_key, device_sn, client_id, username, password, mqtt_host_url, port)
    print(info)
    return info  
```

