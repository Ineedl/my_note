# 目录
## [Java多线程实现方法](#多线程实现的方式)
* [Runnable接口实现多线程](#实现runnable接口)
* [继承Thread实现多线程](#继承thread类实现多线程)
* [Callable接口实现多线程](#实现callable接口)
* [三种方法实现的区别](#三种方法实现的区别)

## [Java线程的生命周期](#java多线程的生命周期)

## [线程的名字相关](#线程的名字)
* [获取线程名字的方法](#获取线程名字的方法)  
* [设置线程名字的方法](#设置线程名字的方法)

## [返回当前线程对象](#返回当前运行线程的线程对象)

## [线程睡眠相关](#线程的睡眠)
* [让一个线程睡眠的方法](#睡眠)  
* [让一个线程中止睡眠的方法](#线程的中止睡眠)  

## [线程的中止](#中止线程)
* [强制的中止](#强制中止) 
* [合理的中止](#合理中止线程)

## [线程调度设置](#线程的调度)
* [优先级的设置](#设置线程优先级)
* [优先级的获取](#获取线程优先级)
* [线程的让位](#线程让位)
* [一个线程等待某个线程执行完毕](#等待某个线程执行完毕)
* [一个线程限制时间内等待某个线程执行完毕](#限制时间内等待某个线程执行完毕)   

## [synchronized关键字实现线程同步](#synchronized线程同步)
* [代码块方式的线程限制区](#代码块线程限制区) 
* [设置一个方法为限制区](#方法限制区)

## [守护线程相关](#守护线程)
* [设置线程为守护线程](#设置守护线程)

## [让线程释放锁并待续](#让线程等待并释放锁)

## [线程异常相关](#线程相关异常)
  
  
--------------------------------------------------  
  
  
## 多线程实现的方式
* 实现 Runnable 接口，并实现相关方法，然后将实现后的类传递给Thread运行。
* 继承java.lang.Thread类，并重写相关方法，并且使用start启动线程。
* 实现Callable 接口，并实现相关方法，实现后的类传递给Thread运行，该方式可以让线程运行后返回结果。


* 注意不管是哪种方法，都是以一个Thread对象为一个线程对象。

* 注意run中不能抛出异常，只能用try catch捕捉

### 实现Runnable接口
* 所在包 java.lang.Rinnable
* 实现方法public void run()
* 构建一该实现了Runnable接口类的一个对象
* 构建一个Thread对象并且将上述中对象传递给Thread类
* 使用上述构建的Thread类对象的start方法来将实现后的run方法作为一个线程运行

例：

    class MyRunnable implements Runnable
    {
        public void run()
        {
            .............
        }
    }
    
    //main代码或其他线程代码中
    Thread t = new Thread(new MyRunnable);
    t.start();

### 继承Thread类实现多线程
* Thread所在的包 java.lang.Thread
* 继承Thread类后重写public void run()方法.
* 调用从Thread中继承的start方法将该类的run方法作为一个线程运行.
* 注意一般都需要定义一个String类型的ThreadName变量来区分线程.

例：

    class MyRunnable extends Thread
    {
        public void run()
        {
            .............
        }
    }
    
    //main代码或其他线程代码中
    MyRunnable t = new MyRunnable();
    t.start();

### 实现Callable接口
* 需要导入包 java.util.concurrent.Callable
* 决定返回结果类型，并实现泛型方法public T call()
* 构建一该实现了Runnable接口类的一个对象
* 构建一个Thread对象并且将上述中对象传递给Thread类
* 使用上述构建的Thread类对象的start方法来将实现后的run方法作为一个线程运行

例：

    class MyRunnable implements Callable<Integer>
    {
        public Integer call() throws Exception{
        //call可以抛出异常，run不可以
        {
            .............
        }
    }
    
    //main代码或其他线程代码中
    Thread t = new Thread(new MyRunnable);
    t.start();

### 三种方法实现的区别
继承Thread类的方法适用于简单的多线程任务，继承Thread类后每次建立的线程对象中的数据不共享，相互独立(不像实现Runnable那样需要传递给Thread对象)。

实现Runnable接口的做法使得多个线程可以共享一个Runnable的对象(也可以不共享，不同的Runnable对象传递给不同的Thread对象即可)，并且由于Runnable是接口，在实现了相关方法后，仍然可以继续继承(注意Java不允许多继承，这使得实现Runnable接口后该类仍然具有非常大的扩展性)。

实现Callable和Runnable差不多，只是说多了个获取线程执行结果，但是Callable效率更低点，而且获取线程执行结果的时候线程被阻塞。

Runnable和Callable的实现方法相较于Thread来说，更像是传递任务给线程执行，而不是直接根据任务写一个线程来执行。以Runnable和Callable为对象的容器可以说相当于是一个任务队列。

## Java多线程的生命周期

![](https://note.youdao.com/yws/api/personal/file/WEBd34ddcc67e445337ebb5a7db00ec76fa?method=download&shareKey=80bf0dd8d30f37304be0ad479a428540)


## 线程的名字
### 获取线程名字的方法  
public String getName()，该方法为Thread的方法

### 设置线程名字的方法  
public void setName(String threadName)，该方法为Thread的方法

* Java线程不设置名字时有默认名，切一般也有一个递增的编号，但是主线程名字默认为main

### 返回当前运行线程的线程对象  
public static Thread currentThread()，该方法为Thread的方法


## 线程的睡眠
### 睡眠  
public static void sleep(long ms)，该方法为Thread的方法  
sleep让调用该方法的线程进入阻塞状态

### 线程的中止睡眠  
public void interrupt()，该方法为Thread的方法  
interrupt让调用的thread对象离开sleep方法的睡眠  
该方法需要配合run中的异常捕捉来中断线程的sleep睡眠，该方法使用后会使sleep方法抛出一个异常

## 中止线程
### 强制中止  
public void	stop()，该方法为Thread的方法  
不建议使用，已弃用  
该方法会强行中止线程，相当于电脑关机或是任务管理器中止线程。  
这样将丢失线程中没保存的信息，如果线程在某个时刻必须强行中止且不考虑数据丢失，可以使用

### 合理中止线程  
设置一个标志位，线程需要退出时，通过if判断标志位然后直接return


## 线程调度设置
### 设置线程优先级  
public void setPriority(int newPriority)，该方法为Thread的方法    
优先级1-10，越大优先级越高，默认为5  
注意优先级不是大的一直运行，只是说优先级大的该线程占用CPU的概率更大

### 获取线程优先级  
public int gerPriority()，该方法为Thread的方法  

### 线程让位
public static void yield()，该方法为Thread的方法    
该方法让调用该方法的线程马上让出CPU让其他线程运行  
yield并非阻塞，而是将线程从运行状态变为就绪状态，就如上述线程状态的图中所示，由JVM调度

### 等待某个线程执行完毕  
public void join()，该方法为Thread的方法    
如果某个线程使用某个Thread对象调用join方法，那么他将会等待该Thread对象对应的线程运行完毕后再运行。

    这里的join含义仍然和线程的分离态与可结合状有关


### 限制时间内等待某个线程执行完毕 
public void join(long millis)，该方法为Thread的方法  

## synchronized线程同步
### 代码块线程限制区  

语法：

    synchronized(线程们需要共享对象){
        
    }

* 当()中放的是一个变量或对象时时，在synchronized包裹的代码块中，同一时间只有一个线程能使用该变量或对象来运行该代码块，即将该变量或对象当做了锁。

* ()中一般放入共享的对象，对象或变量均可，但是他们必须是被线程共享的，所以可以直接使用字符串，因为字符串都在常量池中，属于独立的一个。  
    例：  

        synchronized("ABC"){
            
        }
        
* ()中不能为null，否则会有空指针异常抛出

* ()中获取class对象(类的Class对象)，表示整个类上了类锁，表示该类的所有对象同一时间也只有一个对象能运行该类中的方法。(注意类锁这里不存在死锁问题，即有类锁后，一个对象在嵌套调用该类的方法时，不会产生死锁(synchronized底层实现有信号量)，该类的下一个对象如果想要调用该类的方法，必须在上一个对象不使用该类中任何一个方法后才可以)

### 方法限制区
synchronized可以直接加在方法前面，此时相当于线程运行这个该方法时整个方法以this上锁。  

例：

    class test
    {
        public synchronized void synMethod() {
         //方法体
        }
    }

* synchronized可以给static方法上锁，上锁后表示该方法同一时间只有一个线程在调用。(一个小的类锁)



## 守护线程
守护线程在用户进程结束后都会运行，直到JVM结束运行，守护线程一般是一个无循环的线程，其作用是监控其他线程资源或释放资源。

### 设置守护线程  
    void setDaemon(boolean on)  
    true为守护线程，false为用户线程

* 主线程结束后，用户线程还会继续，所有用户线程结束后，JVM将会退出，JVM是否会退出和守护线程是否存在无关(这个和linux C不同，linux C的主线程在return后会调用exit()等部分函数来结束掉全部的子线程，相当于该程序进程的终结，如果没有让主线程运行到return而提前结束的话，将会等待全部线程结束后才会终结进程)


## 让线程等待并释放锁
有三个方法可以达到该效果

wait(), notify(), notifyAll()

* wait(), notify(), notifyAll()是所有类都拥有的方法，其来源于Object类

* wait()的作用是让调用对象上活动的线程进入等待状态(无限制)。注意不是由线程调用。wait在线程中调用后会释放对象或变量锁。

* notify()和notifyAll()的作用，则是唤醒当前锁的等待线程；notify()是唤醒单个线程，而notifyAll()是唤醒所有的线程，notify()与notifyAll()调用后并不会释放锁。

* wait(long timeout)让当前线程处于“等待(阻塞)状态”，“直到其他线程调用此对象的notify()方法或 notifyAll() 方法，或者超过指定的时间量”，当前线程被唤醒(进入“就绪状态”)。

* 合理的使用wait与notify可以让线程达到交替工作的状态，同时注意wait会释放锁，如果线程在释放了锁的情况下对锁进行操作，很容易会抛出异常，notify在某个对象没有被上锁的情况下最多被调用一次(第二次会抛出异常)

        错误示范：

        package com.cjh;
    
        //交替打印程序
        public class HelloMaven {
            public static void main(String[] args)
            {
                CMyThread t1=new CMyThread("t1");
                CMyThread t2=new CMyThread("t2");
                Thread run1=new Thread(t1);
                Thread run2=new Thread(t2);
                run1.start();
                run2.start();
            }
        
        }
        
        class CMyThread implements Runnable
        {
            private String strOutput;
            public CMyThread(String output)
            {
                strOutput = output;
            }
            public void run()
            {
                while(true)
                {
                    MyPrint();
                }
            }
            
            public synchronized void MyPrint() 
            //实际上锁的为this，而非CMyThread.class
            {
                System.out.println(strOutput);
                //该类第二个对象调用这里的notify()就会报错，
                //因为CMyThread.class并没有被上锁。
                System.out.println("ok");
                CMyThread.class.notify();
                System.out.println("ok2");
                try {
                    CMyThread.class.wait();
                    Thread.sleep(100);// 防止打印速度过快导致混乱
                } catch (InterruptedException e) {
                
                }
            }
            
            //正确版本
            public void MyPrint2()
            {
                synchronized(CMyThread.class) {
                    System.out.println(strOutput);
                    CMyThread.class.notify();
                    try {
                        CMyThread.class.wait();
                        Thread.sleep(100);// 防止打印速度过快导致混乱
                    } catch (InterruptedException e) {
                        // NO
                    }
                }
            }
        }

## 线程相关异常
* java.lang.IllegalMonitorStateException  
该异常是由于线程在未获对象锁时，对对象使用了wait(),notify(),notifyAll()等方法
