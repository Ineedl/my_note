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

    Scanner scanner=new Scanner(System.in);

    while(scanner.hasNext())
    {
        String message = scanner.next();
        channel.basicPublish("test","myRoute", null,message.getBytes());

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

    //声明要到达的交换机
    channel.exchangeDeclare("test", BuiltinExchangeType.DIRECT);

    //声明一个队列
    channel.queueDeclare("Queue",false,false,true,null);

    //绑定队列与key与交换机
    channel.queueBind("Queue","test","myRoute");

    DeliverCallback deliverCallback = (consumerTag, message) ->{
        System.out.println(new String(message.getBody()));
    };

    CancelCallback cancelCallback = (consumerTag)->{
        System.out.println("消费中断");
    };


    System.out.println("等待接受消息");

    channel.basicConsume("Queue",true,deliverCallback,cancelCallback);

}


```