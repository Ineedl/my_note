## 属性修饰符

* public：不写时默认

* protected

* private

* readonly 只读属性

```ts
class Person{
	public name:string;
	age: number;	//默认public
  private readonly test: number
}
```

`属性的简写式`

```ts
class Person{
	constructor(
  public name:string,
  public age number,
  private readonly test: number,
  )
}
```

## 抽象类

```ts
abstract class Package{
	constructor(
  	public name:string,
    public age number,
    private readonly test: number,
  )
    abstract calculate(x:number,y:number) void
}
```

