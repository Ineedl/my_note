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

        /*
        routeKey 一个个试
        
        quick.orange.rabbit
        lazy.orange.elephant
        quick.orange.fox
        lazy.brown.fox
        lazy.pink.rabbit
        quick.brown.fox
        quick.orange.male.rabbit
        lazy.orange.male.rabbit
        
         */
        channel.basicPublish("myTopic","lazy.orange.male.rabbit", null,message.getBytes());

    }
    System.out.println("message send over ! ");
}


```

## 消费者1

```

public static void main(String[] args)throws Exception
{
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("120.24.243.216");
    factory.setUsername("guest");
    factory.setPassword("zxc563221659");
    Connection connection = factory.newConnection();

    Channel channel = connection.createChannel();

    //建立一个交换机
    channel.exchangeDeclare("myTopic", BuiltinExchangeType.TOPIC);

    //声明一个队列
    channel.queueDeclare("Queue",false,false,true,null);

    //绑定队列与key与交换机
    channel.queueBind("Queue","myTopic","*.orange.*");

    DeliverCallback deliverCallback = (consumerTag, message) ->{
        System.out.println("收到消息 : "+new String(message.getBody())+",Key值 : "+message.getEnvelope().getRoutingKey());
    };

    CancelCallback cancelCallback = (consumerTag)->{
        System.out.println("消费中断");
    };

    System.out.println("等待接受消息");

    channel.basicConsume("Queue",true,deliverCallback,cancelCallback);

}

```

## 消费者2

```

public static void main(String[] args)throws Exception
{
    ConnectionFactory factory = new ConnectionFactory();
    factory.setHost("120.24.243.216");
    factory.setUsername("guest");
    factory.setPassword("zxc563221659");
    Connection connection = factory.newConnection();

    Channel channel = connection.createChannel();

    //建立一个交换机
    channel.exchangeDeclare("myTopic", BuiltinExchangeType.TOPIC);

    //声明一个队列
    channel.queueDeclare("Queue2",false,false,true,null);

    //绑定队列与key与交换机
    //可以绑定多个Key
    channel.queueBind("Queue2","myTopic","*.*.rabbit");
    channel.queueBind("Queue2","myTopic","lazy.#");

    DeliverCallback deliverCallback = (consumerTag, message) ->{
        System.out.println("收到消息 : "+new String(message.getBody())+",Key值 : "+message.getEnvelope().getRoutingKey());
    };

    CancelCallback cancelCallback = (consumerTag)->{
        System.out.println("消费中断");
    };

    System.out.println("等待接受消息");

    channel.basicConsume("Queue2",true,deliverCallback,cancelCallback);

}

```