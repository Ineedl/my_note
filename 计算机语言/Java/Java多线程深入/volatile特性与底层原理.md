## volatile修饰类类型

volatile可以修饰引用类型，但是一般使用volatile来修饰基本类型的变量而非引用类型。

volatile修饰引用类型时，只能保证该引用变量中的地址改变的可见性，无法确定是否能确保变量引用对象中内容改变的可见性。


## 保证线程的可见性

Java线程中获取到的变量为该线程从主内存中获取到的拷贝，当只有线程中对该变量进行修改操作后，才会将该变量的修改同步到主存，如果线程对该变量只有读取操作，那么如果其他的线程修改了该变量的值，该线程也见不到这个改变，其只会一直读取自己原来的那份拷贝。

volatile保证了修饰的变量的每一次修改都会被引用了该变量的线程可见 (volatile保证了线程每次都从主存拿数据，而不是直接读取拷贝)，但是其不能保证该变量使用时的原子性。


`证明代码`
```

public class App extends Thread
{
    //去掉volatile后，主线程会一直循环不退出。
    public volatile int test=100;
    public static void main( String[] args )
    {
        App app = new App();
        app.start();
        while(true)
        if(app.test!=100)
        {
            System.out.println("主线程done");
            break;
        }


    }

    @Override
    public void run() {
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        test=99;
    }
}


```

## 禁止指令重排序(保证有序性)

部分超高并发场景中获取单例对象的懒汉代码中，有时候指令重排序会导致第一个初始化该单例对象的线程在获取到该单例对象时，先获取堆空间的引用地址，再进行变量初始化的过程，这会导致多个线程中的对象获取的对象初始化未完成。

`示例代码`
```
//单例模式

public class A{
    private static volatile A INSTANCE;
    private A(){
        //A单例的初始化
    }
    
    public static A getInstance(){
        //省略业务代码
        if(INSTANCE == null)
        {
            synchronized (A.class)
            {
                if(INSTANCE==null)
                {
                    try{
                        //1s
                        Thread.sleep(1);
                    } catch(Expection e)
                    {
                        e.printStackTrace();
                    }
                    
                   
                   
                    
                    
                    //单例对象的引用赋值以及初始化
                    INSTANCE = new A();
                    
                    //部分超高并发场景中，如果INSTANCE不使用volatile进行禁止汇编代码重排序
                    //可能会导致先把分配了空间的A的引用付给INSTANCE，再进行初始化
                    //这时候会发生除了初始化线程以外的线程，使用未初始化完毕的单例对象的情况。
                    
                    
                }
            }
        }
        return INSTANCE;
    }
    
}


```



## volatile不保证原子性

当多个线程使用多个步骤操作volatile变量时，volatile只保证这些步骤每次看到的volatile的确都是实时的值，但是其不能保证这一个操纵volatile多个步骤每一次都是事物性的执行，这就是volatile的局限性。

* volatile变量能每次都看到实时的值不假，但是其不能保证线程中于该变量相关的的一段代码的原子性。

* i++，i-- 这种都是非原子操作，其有两步内容。


## 底层原理

volatile底层使用了内存屏障来实现，该机制会在读取同步变量前，修改同步变量后，将数据与主存同步。同时保证了调用volatile变量的方法中，读取volatile变量之前的操作不会出现在该操作之后，写volatile变量之后的操作不会出现在该操作之前。