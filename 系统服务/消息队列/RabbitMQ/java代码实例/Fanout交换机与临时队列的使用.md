## 生产者

```

public static void main(String[] args) throws Exception
    {

        ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("120.24.243.216");
        factory.setUsername("guest");
        factory.setPassword("zxc563221659");
        Connection connection = factory.newConnection();

        Channel channel = connection.createChannel();

        //创建一个交换机，如果存在同名同类型的交换机则跳过，否则出现异常
        channel.exchangeDeclare("test","fanout");

        Scanner scanner=new Scanner(System.in);

        while(scanner.hasNext())
        {
            String message = scanner.next();
            channel.basicPublish("test","", null,message.getBytes());

        }

        System.out.println("message send over ! ");

    }


```


## 消费者

```

public static void main(String[] args)throws Exception
{
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("120.24.243.216");
    factory.setUsername("guest");
    factory.setPassword("zxc563221659");
    Connection connection = factory.newConnection();

    Channel channel = connection.createChannel();

    //创建一个交换机，如果存在同名同类型的交换机则跳过，否则出现异常
    channel.exchangeDeclare("test","fanout");

    DeliverCallback deliverCallback = (consumerTag, message) ->{
        System.out.println(new String(message.getBody()));
    };

    CancelCallback cancelCallback = (consumerTag)->{
        System.out.println("消费中断");
    };

    //创建一个临时队列
    String queueName=channel.queueDeclare().getQueue();

    //绑定队列与交换机
    channel.queueBind(queueName,"test","");
    System.out.println("等待接受消息");

    channel.basicConsume(queueName,true,deliverCallback,cancelCallback);

}
    
```