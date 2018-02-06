# TLS/SSL

* SSL：（Secure Socket Layer，安全套接字层），为Netscape所研发，用以保障在Internet上数据传输之安全，利用数据加密(Encryption)技术，可确保数据在网络上之传输过程中不会被截取。当前版本为3.0。它已被广泛地用于Web浏览器与服务器之间的身份认证和加密数据传输。  
SSL协议位于TCP/IP协议与各种应用层协议之间，为数据通讯提供安全支持。SSL协议可分为两层： SSL记录协议（SSL Record Protocol）：它建立在可靠的传输协议（如TCP）之上，为高层协议提供数据封装、压缩、加密等基本功能的支持。 SSL握手协议（SSL Handshake Protocol）：它建立在SSL记录协议之上，用于在实际的数据传输开始前，通讯双方进行身份认证、协商加密算法、交换加密密钥等。

* TLS：(Transport Layer Security，传输层安全协议)，用于两个应用程序之间提供保密性和数据完整性。  
TLS 1.0是IETF（Internet Engineering Task Force，Internet工程任务组）制定的一种新的协议，它建立在SSL 3.0协议规范之上，是SSL 3.0的后续版本，可以理解为SSL 3.1，它是写入了 RFC 的。该协议由两层组成： TLS 记录协议（TLS Record）和 TLS 握手协议（TLS Handshake）。较低的层为 TLS 记录协议，位于某个可靠的传输协议（例如 TCP）上面。

!["tls&ssl"](https://github.com/micolore/blogs/blob/master/protocol/img/ssl.png)

## SSL/TLS协议提供的服务主要有：
1. 认证用户和服务器，确保数据发送到正确的客户机和服务器；  
2. 加密数据以防止数据中途被窃取；  
3. 维护数据的完整性，确保数据在传输过程中不被改变。  

## TLS与SSL的区别
1. 版本号：TLS记录格式与SSL记录格式相同，但版本号的值不同，TLS的版本1.0使用的版本号为SSLv3.1。
2. 报文鉴别码：SSLv3.0和TLS的MAC算法及MAC计算的范围不同。TLS使用了RFC-2104定义的HMAC算法。SSLv3.0使用了相似的算法，两者差别在于SSLv3.0中，填充字节与密钥之间采用的是连接运算，而HMAC算法采用的是异或运算。但是两者的安全程度是相同的。
3. 伪随机函数：TLS使用了称为PRF的伪随机函数来将密钥扩展成数据块，是更安全的方式。
4. 报警代码：TLS支持几乎所有的SSLv3.0报警代码，而且TLS还补充定义了很多报警代码，如解密失败（decryption_failed）、记录溢出（record_overflow）、未知CA（unknown_ca）、拒绝访问（access_denied）等。
5. 密文族和客户证书：SSLv3.0和TLS存在少量差别，即TLS不支持Fortezza密钥交换、加密算法和客户证书。
6.certificate_verify和finished消息：SSLv3.0和TLS在用certificate_verify和finished消息计算MD5和SHA-1散列码时，计算的输入有少许差别，但安全性相当。
7. 加密计算：TLS与SSLv3.0在计算主密值（master secret）时采用的方式不同。
填充：用户数据加密之前需要增加的填充字节。在SSL中，填充后的数据长度要达到密文块长度的最小整数倍。而在TLS中，填充后的数据长度可以是密文8. 块长度的任意整数倍（但填充的最大长度为255字节），这种方式可以防止基于对报文长度进行分析的攻击

## TLS主要增强的内容  
TLS的主要目标是使SSL更安全，并使协议的规范更精确和完善  
* 更安全的MAC算法
* 更严密的警报
* “灰色区域”规范的更明确的定义

##  密钥协商过程——TLS握手
SSL协议分为两部分：Handshake Protocol和Record Protocol。其中Handshake Protocol用来协商密钥，协议的大部分内容就是通信双方如何利用它来安全的协商出一份密钥。 Record Protocol则定义了传输的格式。  
由于非对称加密的速度比较慢，所以它一般用于密钥交换，双方通过公钥算法协商出一份密钥，然后通过对称加密来通信，当然，为了保证数据的完整性，在加密前要先经过HMAC的处理。  

!["tls-ssl"](https://github.com/micolore/blogs/blob/master/protocol/img/tls-ssl.svg)

###  客户端发出请求（ClientHello）
 client 必须把自身支持的加密方式告知server端，并生成一个随机数。
1. 支持的协议版本，比如TLS 1.0版
2. 一个客户端生成的随机数，稍后用于生成"对话密钥"
4. 支持的加密方法，比如RSA公钥加密
5. 支持的压缩方法

### 服务器回应（SeverHello)
1. 确认使用的加密通信协议版本，比如TLS 1.0版本。如果浏览器与服务器支持的版本不一致，服务器关闭加密通信
3. 一个服务器生成的随机数，稍后用于生成"对话密钥"
4. 确认使用的加密方法，比如RSA公钥加密
5. 服务器证书

### 客户端回应（Certificate Verify）
验证证书合法之后（机构、域名、有效期），向服务器发送以下信息。
1. 一个随机数。该随机数用服务器公钥加密，防止被窃听
2. 编码改变通知，表示随后的信息都将用双方商定的加密方法和密钥发送
3. 客户端握手结束通知，表示客户端的握手阶段已经结束。这一项同时也是前面发送的所有内容的hash值，用来供服务器校验


### 服务器的最后回应（Server Finish）
服务端在接收到客户端传过来的 PreMaster 加密数据之后，使用私钥对这段加密数据进行解密，并对数据进行验证，也会使用跟客户端同样的方式生成 Session Secret，一切准备好之后，会给客户端发送一个 ChangeCipherSpec，告知客户端已经切换到协商过的加密套件状态，准备使用加密套件和 Session Secret加密数据了。之后，服务端也会使用 Session Secret 加密一段 Finish 消息发送给客户端，以验证之前通过握手建立起来的加解密通道是否成功。

### 几个secret
!["tls-kes-create"](https://github.com/micolore/blogs/blob/master/protocol/img/tls-keys-create.svg)


参考连接：   
[SSL/TLS原理详解](https://segmentfault.com/a/1190000002554673)
