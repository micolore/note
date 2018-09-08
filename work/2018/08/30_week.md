# 20180806
## work
   * 缓存优化
     减少key数量,保证每个key的value不是很大
     频繁更新的热缓存,确保并发没问题
   * 缓存结构以及后续的更新都是很大的问题 
   * 缓存的统计热点及利用率
   * 现在都不知道具体的缓存调用者都在什么地方
     delete a key so  worry!
   * 自动更新 依赖具体的组件
     而我想根据具体的业务进行更新或者删除、清空,那应该怎么办
   * 缓存的查询调用者、缓存的更新调用者 
     怎么样最大限度的解耦合


## mat
* list object
	List objects with （以Dominator Tree的方式查看）
	incoming references 引用到该对象的对象
	outcoming references 被该对象引用的对象

	Show objects by class （以class的方式查看）
	incoming references 引用到该对象的对象
	outcoming references 被该对象引用的对象
	参考链接:
	https://dzone.com/articles/java-thread-retained-memory
	http://java.jiderhamn.se/2011/12/11/classloader-leaks-i-how-to-find-classloader-leaks-with-eclipse-memory-analyser-mat/
##  me 
       弄清它的本质,在你的脑海里面是透明的,每个环节都了如指掌,遇到问题才能快速解决


## web服务器
 *  角色
    通信维护者、请求处理者
	Connector负责的是底层的网络通信的实现
	Container负责的是上层servlet业务的实现

