## maven依赖
```

<dependency>
            <groupId>com.rabbitmq</groupId>
            <artifactId>amqp-client</artifactId>
            <version>5.8.0</version>
</dependency>

```

## 生产者
```
package com.test;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;

public class Producer {

    public static void main(String[] args) throws Exception
    {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("120.24.243.216");
        factory.setUsername("guest");
        factory.setPassword("zxc563221659");
        Connection connection = factory.newConnection();

        Channel channel = connection.createChannel();

        /*
        生成一个队列
        1. 对列名
        2. 队列是否持久化
        3. 该队列是否只供一个消费者进行消费
        4. 是否在最后一个消费者断开连接后 删除队列
        5. 其他参数
         */
        channel.queueDeclare("hello",true,false,true,null);

        String message = "hello MQ";

        /*
        发送消息
        1. 发送的交换机
        2. 路由的key值
        3. 其他参数信息
        4. 发送的消息的消息体
         */
        channel.basicPublish("","hello",null,message.getBytes());

        System.out.println("message send over ! ");

    }
}

```

## 消费者
```

//当用多个线程同时启动以下代码时，为工作队列模式。
//默认配置下，RabbitMQ会以轮询的方式将消息发给多个消费者确保一条消息只会被一个消费者消费。
package com.test;

import com.rabbitmq.client.*;

public class Consumer {

    public static void main(String[] args)throws Exception
    {
        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("120.24.243.216");
        factory.setUsername("guest");
        factory.setPassword("zxc563221659");
        Connection connection = factory.newConnection();

        Channel channel = connection.createChannel();

        /*
        消费队列
        1. 消费哪个队列
        2. 消费成功后是否要自动应答
        3. 消费者未成功消费时的一个回调
        4. 消费者取消消费回调
         */

        DeliverCallback deliverCallback = (consumerTag,message)->{
            System.out.println(new String(message.getBody()));
        };

        CancelCallback cancelCallback = (consumerTag)->{
            System.out.println("消费中断");
        };

        channel.basicConsume("hello",true,deliverCallback,cancelCallback);
    }
}


```