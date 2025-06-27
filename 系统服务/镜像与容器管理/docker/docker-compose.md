[toc]

## 简介

Compose 是用于定义和运行多容器 Docker 应用程序的工具。通过 Compose，您可以使用 YML 文件来配置应用程序需要的所有服务。然后，使用一个命令，就可以从 YML 文件配置中创建并启动所有服务。

- 服务(service)：一个应用的容器，实际上可以包括若干运行相同镜像的容器实例。
- 项目(project)：由一组关联的应用容器组成的一个完整业务单元，在docker-compose.yml文件中定义。

`简单实例`

```yaml
# docker-compose.yml yaml 配置实例
version: '3'    #指定依赖哪个compose版本
services:       #指定构建的服务
  web:          #自定义服务名称
    build: ./   #使用镜像的dockerfile目录
    ports:      #映射出的端口
    restart: always #容器重启策略
    - "5000:5000" 
    volumes:    #映射出的目录
    - .:/code
    - logvolume01:/var/log
    links:
    - redis
  redis:
    image: redis #构建使用的镜像
volumes:
  logvolume01: {}
```

`复杂build参数`

```yaml
version: '3'
services:
  webapp:
    build:
      context: ./dir #定Dockerfile的上下文目录为当前目录的dir目录下
      dockerfile: Dockerfile-alternate #指定dockerfile文件名字
      args:        #构建时变环境变量
        buildno: 1
      command: ["test.jar"] #构建后覆盖的命令参数
      labels: #为构建的镜像添加元数据标签，用于标注或辅助管理。
        - "com.example.description=Accounting webapp"
        - "com.example.department=Finance"
        - "com.example.label-with-empty-value"
      target: prod
      # 构建多阶段 Docker 镜像时，指定构建的目标阶段为 `prod`。
      # dockerfile中的命令
      # FROM base AS prod 表示生产环境相关配置
```

## 命令

### 启动指定的项目所有容器

```bash
docker-compose up -f <compose_file_path>
```

* 不加-f 默认使用当前目录下的docker-compose.yml

### 停止相关项目所有容器

```
docker-compose stop
```

### 停止相关项目并删除容器

```
docker-compose down
 					--volumes --rmi all #删除容器、网络、镜像及卷
```

### 列出所有服务状态

```
docker-compose ps
```

### 查看日志

```bash
docker-compose logs

docker-compose logs -f #持续查看
```

