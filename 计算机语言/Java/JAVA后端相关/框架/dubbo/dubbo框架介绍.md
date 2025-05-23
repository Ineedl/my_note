# 此处使用的dubbo配置方法
此处dubbo的使用以spring的xml配置为例子，当然，也可以直接使用api的配置方式或是配合SpringBoot或者编写dubbo官方规定的配置文件加载来使用。

[其他使用方法文档位置](https://dubbo.apache.org/zh/docs/references/)

## dubbo
duboo是一个开源的分布式框架，它提供了三大核心能力：面向接口的远程方法调用，智能容错和负载均衡，以及服务自动注册和发现。

> 分布式系统定义

分布式系统是许多的计算机合起来为用户提供服务，但是从用户的角度来说，用户只能感受到一个计算机在服务。

> 分布式原理

RPC(Remote Procedure Call)远程过程调用，多个服务器的远程接口调用，比如A服务器调用B服务器上的接口。


> 注册中心概念

注册中心用于保存远程服务器中的接口的相关信息，之后客户端程序在注册中心来选择要调用的接口。

> dubbo的实现

dubbo借由Spring框架来实现，故dubbo的许多配置都是使用的Spring的配置方式


## dubbo的原理
dubbo的底层采用Spring容器实现。  

提供接口包：对于消费者要远程调用的接口，一般是写好对应的接口(不包含实现类)与一些使用的实体类或bean对象后`注意接口只能使用允许序列化类型作为参数类型(实现了Serializable接口的类)，因为原理上远程调用接口是消费者传入序列化的对象给消费者来调用实现方法或是提供者返回序列化的对象给消费者`。将这些接口打包，给提供者导入以提供实现类和远程的接口功能；给消费者以提供远程调用时接口的规范。

对于提供者：只要在Spring的配置文件中设置对应的RFC协议(dubbo协议等),注册中心地址(可以直连，但一般是zookeeper)与暴露的端口然后加载配置文件即可完成远程接口的提供。

对于消费者：只要在Spring的配置文件中设置对应的RFC协议(dubbo协议等),注册中心地址(可以直连，但一般是zookeeper)，与需要的接口，然后使用byType或byName的注入方式来获取提供者的实现类对象(在消费者中该类的类型仍为接口类型)，使用自动注入的方式从注册中心获取对象后，即可调用对应的接口。


`简易原理图`


        `
            接口包abc.jar(提供service接口,service接口有一个方法test)
                                    |
                                    |
                                    |
                                    |
        -------------------------------------------------------------
        |                                                           |
        |                                                           |
        |                                                           |
        |                                                           |
        |                                                           |
    服务提供者。                                                消费者
    导入abc.jar包，                                         导入abc.jar包
    建立service接口的实例类，                               通过Spring配置文件  
    重写test方法。                                  告诉注册证中心需要用接口service
    然后通过Spring配置文件                      然后在某个类中声明一个自动注入的service对象
    注入该实例类到Spring IOC                    然后在这个类将相当于服务提供者的实现的service对象(实际上该对象没有被传过来)
    容器中，然后给注册中心注册                  然后直接调用该类的方法test就可以完成远程调用接口了
    表示用该实现类提供远程服务。
    
## dubbo的稳定性
当dubbo使用zookeeper注册中心时(这个常用，这里的结果以用这个为前提)，当消费者已经调用过提供者的接口后，再关闭注册中心后，消费者仍然可以访问提供者的接口(使用dubbo协议)，因为消费者中的dubbo协议已经缓存了提供者的连接信息，只要连接过一次，关闭注册中心仍然可以连接，但是没有用过的接口仍然无法使用。
