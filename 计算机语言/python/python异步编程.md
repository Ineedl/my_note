[toc]

## Python 异步编程

python异步编程用非阻塞的事件循环方式，提升 IO 密集型程序的性能。

## 异步编程的关键词

| 关键字    | 含义                                                |
| --------- | --------------------------------------------------- |
| `async`   | 声明一个协程函数                                    |
| `await`   | 等待一个协程对象的完成（仅能在 `async` 函数内使用） |
| `asyncio` | Python 官方异步库                                   |

* `await` 只能用于 **`async def`** 声明的函数中

* 异步函数调用本身不会执行，返回的是协程对象（需要 `await` 或 `loop` 执行）

* 遇到 `await`，当前协程将“让出控制权”给事件循环

* 不适用于 CPU 密集任务（应使用多进程或线程）

## 基本语法

### 定义异步函数

```python
async def fetch_data():
    return 42
```

### 使用 `await` 调用异步函数

```python
async def main():
    result = await fetch_data()
    print(result)
```

### 启动方式（Python 3.7+）

```python
import asyncio

asyncio.run(main())
```

## 协程调度：事件循环

事件循环是 `asyncio` 的核心，它会：

- 管理多个协程
- 在协程等待（如 `await asyncio.sleep`）时切换到其他协程
- 最终收集结果

```python
async def foo():
    print("Start foo")
    await asyncio.sleep(1)
    print("End foo")

async def bar():
    print("Start bar")
    await asyncio.sleep(2)
    print("End bar")

async def main():
    await asyncio.gather(foo(), bar())

asyncio.run(main())
```

## `await` 背后机制（简化）

`await coro()` 本质上是 **挂起当前协程，等待另一个协程执行完成后再继续执行当前协程剩下的部分。**

- 在 `await` 处挂起
- 等被等待的协程返回结果后再恢复执行

## 异步任务启动命令

### asyncio.create_task(coro)

把一个**协程对象**注册到事件循环中执行，并立即返回一个 `Task` 对象。

* 会立刻把协程“加入事件循环”
* 非阻塞，只是注册任务

```
import asyncio

async def foo():
    await asyncio.sleep(1)
    print("foo done")

async def main():
    task = asyncio.create_task(foo())  # 注册并调度
    await task  # 等待任务完成

asyncio.run(main())
```

### asyncio.gather(*coros, return_exceptions=False)

并发运行多个协程，**等待全部完成**，并返回它们的结果。

* *coros`：多个协程或 `Task
* `return_exceptions=True`：遇到异常时将其作为返回值返回，而不是抛出

```python
async def foo():
    await asyncio.sleep(1)
    return 'foo'

async def bar():
    await asyncio.sleep(2)
    return 'bar'

async def main():
    results = await asyncio.gather(foo(), bar())
    print(results)  # ['foo', 'bar']

asyncio.run(main())
```

## asyncio.run(main())

高层 API，**启动整个异步程序的入口函数**。它会：

1. 创建事件循环
2. 执行 `main()` 协程
3. 等待完成后关闭事件循环

```python
async def main():
    print("start")
    await asyncio.sleep(1)
    print("end")

asyncio.run(main())

```

**多次调用 `asyncio.run()` **， **每次都会新建一个事件循环，并在并行任务执行完成后销毁**（互不干扰）。

* `asyncio.run()`**不能嵌套调用**（即在已有事件循环中再次调用会报错）。