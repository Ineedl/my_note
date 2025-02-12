## portainer
portainer提供一个后台web面板供我们操作

    docker run -d -p x:9000  \
    --restart=always        \
    -v /var/run/docker.sock:/var/run/docker.sock    \
    --privileged=true portainer/portainer 