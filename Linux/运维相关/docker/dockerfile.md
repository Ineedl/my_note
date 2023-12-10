## dockerfile
dockerfile类似于makefile，但dockerfile是用来制作一个docker镜像。

* docker主键成为了一个企业交互作业的标准。

* 一个dockerfile就相当于一个最后的docker镜像产品

---

## docker的构建
* dockerfile中每个关键字必须是大写字母

* #表示注释

* dockerfile会从上到下执行

* dockerfile中每个指令都会创建一个新的镜像层并提交

### 镜像构建命令

    docker build -f <dockerfile文件位置> -t 镜像名称[:版本号] <build时的工作目录>
    
`例子`

    docker build -f ./dockerfile -t mycentos0.1 .
    

### dockerfile常用指令

|指令|作用|
|:--|:--|
| FROM | 指定制作该镜像的基础镜像 |
| MAINTAINER | 指定该镜像的维护者信息(名字+邮箱) |
| RUN | RUN 指令将在当前镜像顶部的新层中执行所有命令，并提交结果。生成的提交镜像将用于 Dockerfile 中的下一步。 |
| ADD | 添加镜像需要的内容压缩包或文件，如果参数是一个可识别的压缩格式(tar, gzip, bzip2, etc等)的本地文件，将会被自动解压到对应路径 |
| WORKDIR | 指定进入镜像时的默认目录(工作目录) |
| VOLUME | 指定镜像需要挂载的目录，VOLUME只能进行匿名挂载 |
| EXPOSE| 指定创建该镜像容器时会自动暴露的端口 |
| CMD | 指定该镜像的容器启动后需要运行的命令，CMD中命令不支持在docker run时用户再追加参数 |
| ENTRYPOINT | 作用同CMD，但是ENTRYPOINT在用户docker run之后的命令之后追加参数，但是仅限于给最后一个命令添加参数 |
| ONBUILD | 该指令这中内容将会被继承该dockerfile的dockerfile触发
| COPY| 类似ADD命令，但是并不会解压文件。 |
| ENV | 构建时设置容器内运行时环境变量。 |


* EXPOSE注意事项  
EXPOSE设置后，在启动容器时可以不指定映射的主机端口，这样EXPOSE中端口会自动被映射到主机上的一个随机端口。

* RUN相关  
如果需要在上层容器中进行编译或是到达摸个目录等操作请像下面这么做，在RUN只是执行命令并传递结果，其本质并不是一个shell。

    
    RUN bash -c 'cd ...;make -f makefile1;make install'


* VOLUME格式


    VOLUME ["挂载目录1","挂载目录2",...]

* 所有镜像都是最初来源于scratch的

`实例1，官方的centos7镜像`


    //centos7镜像
    FROM scratch
    ADD centos-7-x86_64-docker.tar.xz /
    
    LABEL \
        org.label-schema.schema-version="1.0" \
        org.label-schema.name="CentOS Base Image" \
        org.label-schema.vendor="CentOS" \
        org.label-schema.license="GPLv2" \
        org.label-schema.build-date="20201113" \
        org.opencontainers.image.title="CentOS Base Image" \
        org.opencontainers.image.vendor="CentOS" \
        org.opencontainers.image.licenses="GPL-2.0-only" \
        org.opencontainers.image.created="2020-11-13 00:00:00+00:00"
    
    CMD ["/bin/bash"]
    
    
`实例2，自己的centos建立`

    FROM centos
    MAINTAINER cjh<15342537816@163.com>
    
    ENV MYPATH /user/local
    WORKDIR $MYPATH
    
    RUN yum install -y vim
    RUN yum install -y net-tools
    
    EXPOSE 80
    
    CMD ["echo","$MYPATH"]
    CMD ["echo","---end---"]
    CMD [/bin/bash]

`实例3，建立自己的tomcat`


    FROM centos
    MAINTAINER cjh<15342537816@163.com>

    ADD apache-tomcat-7.0.73.tar.gz /usr/local/
    ADD jdk-8u144-linux-x64.tar.gz /usr/local/
  
    RUN yum -y install vim

    ENV MYPATH /usr/local
    WORKDIR $MYPATH
    
    ENV JAVA_HOME /usr/local/jdk1.8.0_144
    ENV CLASSPATH $JAVA_HOME/lib/dt:$JAVA_HOME/lib/tools.jar
    ENV CATALINA_HOME /usr/local/apache-tomcat-7.0.73
    ENV CATALINA_BASH /usr/local/apache-tomcat-7.0.73
    ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/lib:$CATALINA_HOME/bin
    
    EXPOSE 8080
    
    CMD /usr/local/apache-tomcat-7.0.73/bin/startup.sh && tail -F /url/local/apache-tomcat-7.0.73/bin/logs/catalina.out

    #命令docker build -f ./dockerfile -t mytomcat:0.1 .


#### CMD与ENTRYPOINT的区别
##### CMD

    //dockerfile
    FROM centos
    CMD ["ls", "-a"]

该镜像构建后，使用

    docker run <镜像名> -l
    
-l参数将无法添加到ls -a命令中，该运行会报错

* 一个Dockerfile仅仅最后一个CMD起作用。

* docker的CMD命令以shell的方式运行命令后，执行完毕会导致容器退出。

##### ENTRYPOINT

    //dockerfile
    FROM centos
    ENTRYPOINT ["ls", "-a"]

该镜像构建后，使用

    docker run <镜像名> -l
    
-l参数将会追加到ls -a命令中，运行不会报错