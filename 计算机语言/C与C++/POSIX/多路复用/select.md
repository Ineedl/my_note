[toc]

## 原理

select对传入的套接字进行O(n)的轮训扫描，并且每次调用都需要全量拷贝fd，而且用户也要轮训自己传入的fd

* 效率低于epoll
* 最多只支持轮训1024的描述符

## API

### 清理描述符列表

```
#include <sys/select.h>
#include <sys/time.h>

FD_ZERO(fd_set *fd_list);
```

### 设置描述符到列表

```
#include <sys/select.h>
#include <sys/time.h>

FD_SET(int fd,fd_set *fd_list);
```

### 查看描述符是否就绪

```
#include <sys/select.h>
#include <sys/time.h>

int FD_ISSET(fd1, &readfds);
```

`返回值`

* 0：未就绪
* 非0：就绪

## 一次select轮训

```c
#include <sys/select.h>
#include <sys/time.h>

int select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout);
```

**参数说明**

| 参数        | 含义                                                       |
| ----------- | ---------------------------------------------------------- |
| `nfds`      | 监听的最大 fd 值 + 1。比如你要监听的最大 fd 是 6，则传 7。 |
| `readfds`   | 可读监听集合，检测是否可以进行 read 操作（如 `recv()`）。  |
| `writefds`  | 可写监听集合，检测是否可以进行 write 操作（如 `send()`）。 |
| `exceptfds` | 异常监听集合，通常用于监听 out-of-band 数据（极少用）。    |
| `timeout`   | 超时时间。NULL 表示永远阻塞。可以传 0 实现非阻塞。         |

**返回值 **

* \>0：有文件描述符准备好，可以执行相应操作。返回值是**准备好的文件描述符数量**，即已经就绪的文件描述符数。

* = 0：表示**超时**，没有文件描述符在指定的超时时间内准备好。
  - 如果你传递了 `timeout` 参数且该时间过期，`select` 会返回 0，表示超时。

* = -1：出现错误。
  - 可以通过 `errno` 获取错误的详细原因。常见的错误包括：
    - `EBADF`：一个无效的文件描述符。
    - `EINTR`：调用被中断（例如，收到信号）。

## 例子

```c
fd_set readfds, writefds, exceptfds;
FD_ZERO(&readfds);
FD_ZERO(&writefds);
FD_ZERO(&exceptfds);

FD_SET(sock, &readfds);  // 检查 sock 是否可读
FD_SET(sock, &writefds); // 检查 sock 是否可写
FD_SET(sock, &exceptfds); // 检查 sock 是否有异常

select(sock + 1, &readfds, &writefds, &exceptfds, NULL);

if (FD_ISSET(sock, &readfds)) {
    // sock 可读
}
if (FD_ISSET(sock, &writefds)) {
    // sock 可写
}
if (FD_ISSET(sock, &exceptfds)) {
    // sock 异常
}
```

