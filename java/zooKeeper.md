# ZooKeeper
> 数据发布/订阅、负载均衡、命名服务、分布式协调/通知、集群管理、Master选举、分布式锁和分布式队列
## 一致性
* 顺序一致性 
* 原子性
* 单一视图
* 可靠性
* 实时性
## 角色
* Leader
* Follower
* Observer
> ZooKeeper集群的所有机器通过一个Leader选举过程来选定一台被称为『Leader』的机器，Leader服务器为客户端提供读和写服务。
 Follower和Observer都能提供读服务，不能提供写服务。两者唯一的区别在于，Observer机器不参与Leader选举过程，
 也不参与写操作的『过半写成功』策略，因此Observer可以在不影响写性能的情况下提升集群的读性能
 
 ## 会话 
 >Session是指客户端会话，在讲解客户端会话之前，我们先来了解下客户端连接。在ZooKeeper中，
 一个客户端连接是指客户端和ZooKeeper服务器之间的TCP长连接。ZooKeeper对外的服务端口默认是2181，客户端启动时，
 首先会与服务器建立一个TCP连接，从第一次连接建立开始，客户端会话的生命周期也开始了，通过这个连接，
 客户端能够通过心跳检测和服务器保持有效的会话，也能够向ZooKeeper服务器发送请求并接受响应，
 同时还能通过该连接接收来自服务器的Watch事件通知。Session的SessionTimeout值用来设置一个客户端会话的超时时间。
 当由于服务器压力太大、网络故障或是客户端主动断开连接等各种原因导致客户端连接断开时，
 只要在SessionTimeout规定的时间内能够重新连接上集群中任意一台服务器，那么之前创建的会话仍然有效。

## 数据节点
> 在谈到分布式的时候，一般『节点』指的是组成集群的每一台机器。而ZooKeeper中的数据节点是指数据模型中的数据单元，
称为ZNode。ZooKeeper将所有数据存储在内存中，数据模型是一棵树（ZNode Tree），由斜杠（/）进行分割的路径，
就是一个ZNode，如/hbase/master,其中hbase和master都是ZNode。
每个ZNode上都会保存自己的数据内容，同时会保存一系列属性信息。
* 持久节点
>所谓持久节点是指一旦这个ZNode被创建了，除非主动进行ZNode的移除操作，否则这个ZNode将一直保存在ZooKeeper上。
* 临时节点
>临时节点的生命周期跟客户端会话绑定，一旦客户端会话失效，那么这个客户端创建的所有临时节点都会被移除。
 
## 版本
> ZooKeeper的每个ZNode上都会存储数据，对应于每个ZNode，ZooKeeper都会为其维护一个叫作Stat的数据结构，
Stat中记录了这个ZNode的三个数据版本，分别是version（当前ZNode的版本）、cversion（当前ZNode子节点的版本）
和aversion（当前ZNode的ACL版本）。

## 状态信息
> 每个ZNode除了存储数据内容之外，还存储了ZNode本身的一些状态信息。

## 事务操作
>在ZooKeeper中，能改变ZooKeeper服务器状态的操作称为事务操作。一般包括数据节点创建与删除、
数据内容更新和客户端会话创建与失效等操作。对应每一个事务请求，ZooKeeper都会为其分配一个全局唯一的事务ID，
用ZXID表示，通常是一个64位的数字。每一个ZXID对应一次更新操作，从这些ZXID中可以间接地识别出ZooKeeper处理这些事务操作请求的全局顺序
 
## Watcher
> Watcher（事件监听器），是ZooKeeper中一个很重要的特性。ZooKeeper允许用户在指定节点上注册一些Watcher，
并且在一些特定事件触发的时候，ZooKeeper服务端会将事件通知到感兴趣的客户端上去。该机制是ZooKeeper实现分布式协调服务的重要特性。

## ACL
* CREATE: 创建子节点的权限。
* READ: 获取节点数据和子节点列表的权限。
* WRITE：更新节点数据的权限。
* DELETE: 删除子节点的权限。
* ADMIN: 设置节点ACL的权限。

# ZAB协议
>ZooKeeper是Chubby的开源实现，而Chubby是Paxos的工程实现，所以很多人以为ZooKeeper也是Paxos算法的工程实现。
事实上，ZooKeeper并没有完全采用Paxos算法，而是使用了一种称为ZooKeeper Atomic Broadcast（ZAB，ZooKeeper原子广播协议）
的协议作为其数据一致性的核心算法。  
>ZAB协议并不像Paxos算法和Raft协议一样，是通用的分布式一致性算法，它是一种特别为ZooKeeper设计的崩溃可恢复的原子广播算法。

## 核心
> 所有事务请求必须由一个全局唯一的服务器来协调处理，这样的服务器被称为Leader服务器，而剩下的其他服务器则成为Follower服务器。
Leader服务器负责将一个客户端事务请求转换成一个事务Proposal（提案）并将该Proposal分发给集群中所有的Follower服务器。
之后Leader服务器需要等待所有Follower服务器的反馈，一旦超过半数的Follower服务器进行了正确的反馈后，
Leader就会再次向所有的Follower服务器分发Commit消息，要求对刚才的Proposal进行提交。
## 协议
ZAB协议包括两种基本的模式，分别是崩溃恢复和消息广播。在整个ZooKeeper集群启动过程中，或是当Leader服务器出现网络中断、
崩溃退出与重启等异常情况时，ZAB协议就会进入恢复模式并选举产生新的Leader服务器。当选举产生了新的Leader服务器，
同时集群中有过半的机器与该Leader服务器完成了状态同步之后，ZAB协议就会退出恢复模式。其中，状态同步是指数据同步，
用来保证集群中存在过半的机器能够和Leader服务器的数据状态保持一致。  
崩溃恢复模式包括两个阶段：Leader选举和数据同步

## 应用场景
* 数据发布与订阅（配置中心）
* 命名服务(Naming Service)
* 分布式协调/通知
* 分布式锁
* 排他锁
* 共享锁







