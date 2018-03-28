# 集中式

1. OSCache

OSCache有以下特点：缓存任何对象，你可以不受限制的缓存部分jsp页面或HTTP请求，任何java对象都可以缓存。拥有全面的API--OSCache API给你全面的程序来控制所有的OSCache特性。永久缓存--缓存能随意的写入硬盘，因此允许昂贵的创建(expensive-to-create)数据来保持缓存，甚至能让应用重启。支持集群--集群缓存数据能被单个的进行参数配置，不需要修改代码。缓存记录的过期--你可以有最大限度的控制缓存对象的过期，包括可插入式的刷新策略(如果默认性能不需要时)。

2. JCache

Java缓存新标准（javax.cache）

3. cache4j

cache4j是一个有简单API与实现快速的Java对象缓存。它的特性包括：在内存中进行缓存，设计用于多线程环境，两种实现：同步与阻塞，多种缓存清除策略：LFU, LRU, FIFO，可使用强引用。

4. ShiftOne

ShiftOneJavaObject Cache是一个执行一系列严格的对象缓存策略的Java lib，就像一个轻量级的配置缓存工作状态的框架。

5. WhirlyCache

Whirlycache是一个快速的、可配置的、存在于内存中的对象的缓存。

6. Guava Cache

Guava Cache是一个全内存的本地缓存实现，它提供了线程安全的实现机制。
 
 
## 分布式
1. Ehcache

Ehcache是一个Java实现的开源分布式缓存框架，EhCache 可以有效地减轻数据库的负载，可以让数据保存在不同服务器的内存中，在需要数据的时候可以快速存取。同时EhCache 扩展非常简单，官方提供的Cache配置方式有好几种。你可以通过声明配置、在xml中配置、在程序里配置或者调用构造方法时传入不同的参数。

2. Cacheonix– 高性能Java分布式缓存系统

Cacheonix同样也是一个基于Java的分布式集群缓存系统，它同样可以帮助你实现分布式缓存的部署。

3. JBoss Cache– 基于事物的Java缓存框架

JBoss Cache是一款基于Java的事务处理缓存系统，它的目标是构建一个以Java框架为基础的集群解决方案，可以是服务器应用，也可以是Java SE应用。

4. Voldemort– 基于键-值（key-value）的缓存框架

Voldemort是一款基于Java开发的分布式键-值缓存系统，像JBoss Cache一样，Voldemort同样支持多台服务器之间的缓存同步，以增强系统的可靠性和读取性能。

5. Redis

Redis是基于内存、可持久化的日志型、Key-Value数据库高性能存储系统，并提供多种语言的API.

6. memcached

memcached是应用最广的开源cache产品，它本身不提供分布式的解决方案，我猜想一方面它想尽量保持产品简单高效，另一方面cache的key-value的特性使得让memcached分布式起来比较简单。memcached的分布式主要在于客户端，通过客户端的路由处理来搭建memcached集群环境，因此在服务端，memcached集群环境实际上就是一个个memcached服务器的堆积品，环境的搭建比较简单。下面从客户端做路由和服务端集群环境搭建两方面来谈如何让memcached分布式


# note
使用集中式缓存，必须要注意不能在程序中操作缓存里面的数据，否则你会怀疑人生。


 
