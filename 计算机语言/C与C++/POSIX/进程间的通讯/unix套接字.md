[toc]

## 原理

使用文件系统的socket

* unix套接字在进程间不需要管同步机制

## 限制

* 使用的文件位置没有限制
* 必须保证服务端bind时，unix socket文件最好不存在，最好创建前unlink一下
* unix套接字忘记释放后，可以通过删除文件的方式来释放。

## 例子

`global.h`

```
const char* share_file_name="/tmp/mysocket";
```

`recv`

```c
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "global.h"

int main() {
    int sockfd;
    struct sockaddr_un addr;
    

    sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket");
        exit(1);
    }

    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, share_file_name, sizeof(addr.sun_path) - 1);

    if (connect(sockfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        perror("connect");
        close(sockfd);
        exit(1);
    }
    char buf[6];
    
    while(true){
        memset(buf,0,6);
        int n = read(sockfd, buf, 5);
        if (n > 0) {
            printf("recv msg:%s\n",buf);
        }
    }
    

    close(sockfd);
    return 0;
}

```

`send`

```c
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "global.h"
#include <thread>

int main() {
    int server_fd, client_fd;
    struct sockaddr_un addr;

    // 删除旧socket文件
    unlink(share_file_name);

    server_fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (server_fd < 0) {
        perror("socket");
        exit(1);
    }

    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, share_file_name, sizeof(addr.sun_path) - 1);

    if (bind(server_fd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        perror("bind");
        close(server_fd);
        exit(1);
    }

    if (listen(server_fd, 5) < 0) {
        perror("listen");
        close(server_fd);
        exit(1);
    }

    printf("Server waiting for connection...\n");
    client_fd = accept(server_fd, NULL, NULL);
    if (client_fd < 0) {
        perror("accept");
        close(server_fd);
        exit(1);
    }

    printf("Client connected.\n");

    const char* buf="hello";
    while(true){
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));  // 睡眠1毫秒s
        write(client_fd, buf, 5);

    }
    

    close(client_fd);
    close(server_fd);
    unlink(share_file_name); // 清理
    return 0;
}

```

