[toc]

## 基础数据类型

包括所有的JS类型，此外新增以下6个类型

### any

表示放弃了对变量的类型检查，后续该变量可以存储任何形式的数值

```ts
let a: any
let b		//隐式声明
```

* any可以赋值给任何变量，但是不会进行任何检查，所以使用any不注意时很容易出错

```ts
let a: any
a = 9
let c: string
c = a //异常 
```

### unknown

unknown表示未知类型，基本等同一个一个安全的any类型

* 将unknow赋值给其他变量必须断言
* unknown可以赋予任何值，但是在使用他的时候必须先断言类型。

```ts
let a: unknown 
a = 9
let c: string
c = a //异常，无法将一个unknown类型
```

`安全赋值方法`

```ts
let a: unknown 
a = 9
let c: string

if(typeof a === 'string'){
  c = a
}

x = a as string

(a as string).toUpperCase()

x = <string> a
```

### never

表示一个非值，任何值都不能有，null，undefined都不行

```ts
function demo(): never{
  throw new Error('!!!!!!!')
}
```

* never用于标记函数，never标记的函数表示永远执行不完，或者必须返回undefine
* never不用于限制变量
* never类型的变量一般时ts主动推导出来的

```ts
let a: string


if(typeof a === 'string'){

}else{
	console.log(a)		//推导为never
}
```

### void

用于函数返回值，但是提前返回需要返回undefined，因为void只接受undefine的返回

* void一般不用于变量，但是ts允许将void函数赋值为变量
* void效果超过undefined，所以void函数的返回赋值给变量后，该变量无法使用。

```ts
function logMessage():void{
	let a: bool
	if(a){
		return undefined
	}
	return undefined
}


function logMessage():undefined{		//和void效果一样 但是void效果超过undefined

}
```

### object

object范围太大，所以实际开发中用的相对较少。

object表示非原始类型。

* object只能存储除了原始类型以外的类型
* Object能存储可以调用到Object方法的类型

```ts
let a: object

a={}
a={name:'tome'}
a=[1,3,5,7,9]
class Person{}

a = new Person()


a = 1 //报错
a = true //报错
a = '你好' //报错

let b: Object

b = 1	//被包装为Number
b = true	//被包装为Boolean
b = '你好' //被包装为String

b = null //报错
b = undefined //报错
```

#### 声明对象类型

##### 隐式限制对象类型

```ts
let person: {name:string,age:number}		//age和number必选，不在时赋值变量报错
let person: {name:string,age?:number}		//age可选，不在时赋值变量不报错
```

##### 索引签名

```ts
let person:{
	name: string
  age?: number
  [key:string]: any		//签名，只要后续对象中新增的数据key是字符串，类型是any就能接受
  										//即允许任意数量的属性
  										//名字可以任意，一般写key
}

person = {name:'tom',age: 18,gender: '男'}		//合法
```

#### 声明函数类型

```ts
//声明一个函数指针
let count: (a:number,b:number) => number

count = function(a:number,b:number):number{
  return a + b
}

//也合法 被简化
count = function(a,b){
  return a + b
}
```

#### 声明数组类型

```ts
let arr: string[]
arr = ['a','b']

let arr2: Array<number>
arr2 = [1,2]
```

### tuple

元组，一个特殊的数组类型，存储固定数量的元素，并且每个元素的类型是已知的并且可以不同。

* ?表示可选元素

```ts
let arr1: [string,number]
let arr2: [string,boolean?]
let arr3: [number,...string[]]

arr1 = ['hello',100]
arr2 = ['hello',false]
arr2 = ['hello']
arr3 = [1,'a','b','c']
```

### enum

枚举量默认使用const关键字定义，在编译时会被内联，避免生成一些额外的代码。

```ts
enum enum_name {
	Up,			//从0开始计数，enum无法修改开始编号
	Down,
	Left,
	Right
}


function walk(data:enum_name){
  if(daa === enum_name.Up){
   	console.log("up")
  }
}
```

## 自定义类型的方式

两个自定义类型的方式

### type

能为任意类型创建别名

```ts
type shuzi = number

let a: shuzi

a = 100


type LogFunc = () => void		//ts并不会严格要求函数返回空
														//函数仍然可以返回任何值
let f1 : LogFunc
f1 = function(){
  return undefined
}
f1 = function(){
  return 200
}

//不严格要求原因，为了兼容下面的情况
const src = [1,2,3];
const dst = [0];
src.forEach((e1)=>dst.push(el))	//遍历函数传入的要求是void返回，但是大部分情况传入的函数都有void情况
```

#### 联合类型

类似于c的联合类型

```ts
type Status = number | string
type Gender = '男'  ｜ '女'  //这个类型只能传入两种字符串
//限制传入类型为number或者string
function printStatus(data:Status):void{

}

//限制传入必须为男或女字符串
function printStatus(data:Gender):void{

}
```

#### 交叉类型

```ts
type Area = {
	height: number;
	width: number;
}

type Address = {
	num:number
	cell:number
	room:string
}

type House = Area & Address //house类型必须拥有上述两个结构的所有属性

const house:House={
  height: 100,
  width: 100,
  num:3,
  cell:4
  root:"702"
}


type Demo = number & string	//允许这样说明 但是最终只有never类型能符合赋值要求
```

### interface

接口，类似于java，但是interface可以有属性，并且其中的内容都是public

```ts
interface IPerson {
	name:string
	age:number
	speak(n:number): void
}
```

