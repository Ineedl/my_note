[toc]

## 介绍

用于管理k8s的南北流量(对外映射)

## 原理

外部访问Ingress，然后Ingress访问service。Ingress在k8s中相当于nginx。在k8s中相当于nginx的抽象。Ingress的其中一个使用就是nginx。k8s中最常用的Ingress控制器就是nginx-Ingress。

* Ingress有多种控制器，每个控制器都是Ingress抽象的实现。

## 安装

使用Ingress需要使用k8s的包管理器来安装Ingress。