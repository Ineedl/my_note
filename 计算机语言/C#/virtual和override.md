## virtual

性质等同于C++，被virtual标记的函数被子类继承后，可以不用再标记为virtual

## override

被virtual标记的函数，在子类中重写时，必须用override标记，否则，将不会在转型后调用原本类型的方法，而是对应转型的方法。

* override只能标记被virtual标记的父类的函数。

## 示例

1. 使用了override

```
using System;
namespace shap
{
    class Program
    {
        static void Main(string[] args)
        {
        
            C c=new C();
            c.Speek();
            B b = (B)c;
            b.Speek();
            //输出
            //CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
            //CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
           
            
        }
    }


    class A
    {
        public virtual void Speek()
        {
            Console.WriteLine("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        }
    }

    class B: A
    {

        public override void Speek()
        {
            Console.WriteLine("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
        }
    }

    class C : B
    {

        public override void Speek()
        {
            Console.WriteLine("CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
        }
    }

}

```

2. 未使用override，无论子类是否被virtual再次标记，都无法实现转型后调用原本对象函数的作用

```
using System;
namespace shap
{
    class Program
    {
        static void Main(string[] args)
        {
        
            C c=new C();
            c.Speek();
            B b = (B)c;
            b.Speek();
            //输出
            //CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
            //BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
           
            
        }
    }


    class A
    {
        public virtual void Speek()
        {
            Console.WriteLine("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        }
    }

    class B: A
    {

        public virtual void Speek()
        {
            Console.WriteLine("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
        }
    }

    class C : B
    {

        public virtual void Speek()
        {
            Console.WriteLine("CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
        }
    }

}

```

