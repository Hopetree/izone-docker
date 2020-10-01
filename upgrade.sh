#!/bin/bash

# 判断如果不是root权限就退出执行
[ `id -u` -ne 0 ] && echo "[WARNING] it should be root" && exit 1
cd `dirname $0`
source ./.env
# 仅更新web镜像
upgrade_web()
{
    echo "[INFO] only upgrade web image"
    docker pull ${IZONE_IMAGE}
    docker-compose rm -f -s web
    docker images|grep '<none>'|awk '{print $3}'|xargs -I {} docker image rm {}
    docker-compose up -d web
    echo "[INFO] only upgrade web image"
}

# 更新静态文件
upgrade_static()
{
    echo "[INFO] upgrade static start"
    docker-compose run web python manage.py collectstatic --noinput
    docker-compose rm -f -s web
    docker-compose up -d web
    echo "[INFO] upgrade static done"
}

# 更新nginx容器
upgrade_nginx()
{
    echo "[INFO] only upgrade nginx image"
    docker pull ${NGINX_IMAGE}
    docker-compose rm -f -s nginx
    docker images|grep '<none>'|awk '{print $3}'|xargs -I {} docker image rm {}
    docker-compose up -d nginx
    echo "[INFO] only upgrade nginx done"
}

action=$1

case $action in
    static)
    upgrade_web
    upgrade_static
    ;;
    nginx)
    upgrade_nginx
    ;;
    *)
    upgrade_web
    ;;
esac

docker images

