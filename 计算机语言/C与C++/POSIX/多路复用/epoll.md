[toc]

## 原理

epoll基于内核回调来触发fd就绪事件，并且不需要轮训检查，效率远高于select，并且只需要注册一次fd就，就不需要再传输fd。

* epoll没有套接字上线。
* epoll支持连接数非常高，支持数万，理论上无限。
* epoll效率是O(1)，直接就是内核回调的。

## API

### 创建epoll描述符

```c
int epoll_create(int size);  // 旧版
int epoll_create1(int flags);  // 新版，推荐使用
```

**参数**

- `size`: 这个参数在 `epoll_create` 中指定了内核为 epoll 实例分配的内存大小（通常可以设为 1，不会影响行为）。在 `epoll_create1` 中没有作用。
- `flags`: 在 `epoll_create1` 中，你可以传递标志位：
  - `EPOLL_CLOEXEC`：设置文件描述符在执行 `exec()` 时会被关闭。
  - `0`：等同于epoll_create(0)。

**返回值**

- 成功返回一个 epoll 文件描述符。
- 失败返回 `-1`，并设置 `errno`。

### epoll_event结构

```c++
struct epoll_event {
    uint32_t events;   // 事件类型
    epoll_data_t data; // 附加数据
};

typedef union epoll_data {
    void *ptr;        // 任意指针类型，通常用于存储指向结构体等的指针
    int fd;           // 文件描述符，直接存放文件描述符值
    uint32_t u32;     // 一个 32 位无符号整数
    uint64_t u64;     // 一个 64 位无符号整数
} epoll_data_t;
```

**`events`**:

- 类型：`uint32_t`
- 该字段表示感兴趣的事件类型，或者说是 `epoll` 要监控的 I/O 事件，支持用 | 来监听多个事件
- 常见的事件类型有：
  - `EPOLLIN`: 可读事件。表示文件描述符上的数据可以读取。
  - `EPOLLOUT`: 可写事件。表示文件描述符上可以写入数据。
  - `EPOLLERR`: 错误事件。表示文件描述符发生了错误。
  - `EPOLLHUP`: 挂起事件。表示文件描述符发生了挂起。
  - `EPOLLET`: 边缘触发事件。表示采用边缘触发模式。与水平触发模式不同，边缘触发只会在状态发生变化时触发一次。
  - `EPOLLONESHOT`: 一次性事件。表示事件只会触发一次，触发后将从 epoll 中删除。

**`data`**:

- 类型：`epoll_data_t`（实际上是一个联合体）
- 用于存放与文件描述符相关的附加数据，通常是文件描述符本身或者其他用户定义的数据。
- `epoll_data_t` 是一个联合体，可以存放不同类型的数据。通过这种方式，用户可以在事件发生时，通过 `data` 字段获取有关文件描述符的其他信息。

### 添加、修改、删除监视的文件描述符

```
int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);
```

- `epfd`: `epoll_create` 或 `epoll_create1` 返回的 epoll 文件描述符。
- `op`: 操作类型，可以是：
  - `EPOLL_CTL_ADD`: 将文件描述符 `fd` 添加到 epoll 实例中。
  - `EPOLL_CTL_MOD`: 修改已添加的文件描述符的事件监听。
  - `EPOLL_CTL_DEL`: 从 epoll 实例中删除文件描述符。
- `fd`: 需要添加、修改或删除的文件描述符。
- `event`: 指向 `struct epoll_event` 的指针，描述事件的类型和相关数据。

**返回值**

- 成功返回 `0`。
- 失败返回 `-1`，并设置 `errno`。

### 等待epoll事件发生

```c
int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout);
```

**参数**

- `epfd`: `epoll_create` 或 `epoll_create1` 返回的 epoll 文件描述符。
- `events`: 用于存放发生事件的数组，`maxevents` 表示数组的最大大小。
  - 一个epoll_event表示一个socket，一个epoll_event中的event可能包含多种事件。其epoll_event.data.fd就是触发的套接字。
- `maxevents`: 表示 `events` 数组的大小，最大可以返回的事件数。
- `timeout`: 超时时间，单位为毫秒：
  - `-1`: 阻塞等待直到事件发生。
  - `0`: 非阻塞，即使没有事件，也立即返回。
  - 正数：指定等待时间，单位为毫秒。

**返回值**

- 返回实际发生的事件数。如果没有事件发生并且 `timeout` 是 `0`，则返回 `0`。
- 失败返回 `-1`，并设置 `errno`。

### 等待epoll事件发生(多线程版本)

```c
int epoll_pwait(int epfd, struct epoll_event *events, int maxevents, int timeout, const sigset_t *sigmask);
```

**参数**

- `sigmask`: 指定一个信号集，表示在调用期间阻塞的信号。

**返回值**

- 和 `epoll_wait` 一样。