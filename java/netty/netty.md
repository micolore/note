 # Netty
 Non-bloking I/O

## netty core
* channel
> 它代表一个到实体（如一个硬件设备、一个文件、一个网络套接字或者一个能够执
行一个或者多个不同的I/O操作的程序组件）的开放连接，如读操作和写操作
* 回调
```
public class ConnectHandler extends ChannelInboundHandlerAdapter {

@Override
public void channelActive(ChannelHandlerContext ctx)
		throws Exception {
			System.out.println(
		    "Client " + ctx.channel().remoteAddress() + " connected");
		}
}
```
* future

```
Channel channel = ...;
ChannelFuture future = channel.connect(new InetSocketAddress("192.168.0.1", 25));
```
```
 Channel channel = ...;
 // Does not block
 ChannelFuture future = channel.connect(new InetSocketAddress("192.168.0.1", 25));
 future.addListener(new ChannelFutureListener() { 
 @Override
 public void operationComplete(ChannelFuture future) {
 	    if (future.isSuccess()){
			ByteBuf buffer = Unpooled.copiedBuffer("Hello",Charset.defaultCharset());
			ChannelFuture wf = future.channel().writeAndFlush(buffer);
			....
		} else {
			Throwable cause = future.cause();
			cause.printStackTrace();
		}
	}
});
```
* 事件&channelhandler

# first echo server  
1. 至少一个 ChannelHandler — 该组件实现了服务器对从客户端接收的数据的处理，即
它的业务逻辑。  
2. 引导 — 这是配置服务器的启动代码。至少，它会将服务器绑定到它要监听连接请求的
## ChannelHandler 和业务逻辑  
端口上。  
* io.netty.channel.ChannelInboundHandler.channelReadComplete(ChannelHandlerContext)
* io.netty.channel.ChannelInboundHandler.channelRead(ChannelHandlerContext, Object)
* io.netty.channel.ChannelInboundHandler.exceptionCaught(ChannelHandlerContext, Throwable)
```
@Sharable
public class EchoServerHandler extends ChannelInboundHandlerAdapter {

@Override
public void channelRead(ChannelHandlerContext ctx, Object msg) {
		ByteBuf in = (ByteBuf) msg;
		System.out.println("Server received: " + in.toString(CharsetUtil.UTF_8));
		ctx.write(in);
}

@Override
public void channelReadComplete(ChannelHandlerContext ctx) {
  	    ctx.writeAndFlush(Unpooled.EMPTY_BUFFER).addListener(ChannelFutureListener.CLOSE);
}

@Override
public void exceptionCaught(ChannelHandlerContext ctx,Throwable cause) {
		cause.printStackTrace();
		ctx.close();
	}
}
```
> 针对不同类型的事件来调用 ChannelHandler；
应用程序通过实现或者扩展 ChannelHandler 来挂钩到事件的生命周期，并且提供自
定义的应用程序逻辑；
在架构上，ChannelHandler 有助于保持业务逻辑与网络处理代码的分离。这简化了开
发过程，因为代码必须不断地演化以响应不断变化的需求

## 引导服务器
绑定到服务器将在其上监听并接受传入连接请求的端口  
配置 Channel ，以将有关的入站消息通知给 EchoServerHandler 实例   

```
public class EchoServer {
	private final int port;
	public EchoServer(int port) {
		this.port = port;
	}
	public static void main(String[] args) throws Exception {
		  if (args.length != 1) {
	         System.err.println("Usage: " + EchoServer.class.getSimpleName() +" <port>");
	      }
		    int port = Integer.parseInt(args[0]);
		    new EchoServer(port).start();
    }
	public void start() throws Exception {
		final EchoServerHandler serverHandler = new EchoServerHandler();
		EventLoopGroup group = new NioEventLoopGroup();
		try {
			ServerBootstrap b = new ServerBootstrap();
			b.group(group).channel(NioServerSocketChannel.class)
 						  .localAddress(new InetSocketAddress(port))
						  .childHandler(new ChannelInitializer<SocketChannel>(){
			@Override
			public void initChannel(SocketChannel ch) throws Exception {
				ch.pipeline().addLast(serverHandler); ①
			}
		});
 		ChannelFuture f = b.bind().sync();
		f.channel().closeFuture().sync();
	   } finally {
			group.shutdownGracefully().sync();
	  }
   }
}
```

# first echo client 

1. 连接到服务器；
2. 发送一个或者多个消息；
3. 对于每个消息，等待并接收从服务器发回的相同的消息；
4. 关闭连接。

```
	@Sharable
	public class EchoClientHandler extends SimpleChannelInboundHandler<ByteBuf> {
	@Override
	public void channelActive(ChannelHandlerContext ctx) {
		ctx.writeAndFlush(Unpooled.copiedBuffer("Netty rocks!",CharsetUtil.UTF_8));
    }
	@Override
	public void channelRead0(ChannelHandlerContext ctx, ByteBuf in) {
	    System.out.println("Client received: " + in.toString(CharsetUtil.UTF_8));
    }
	public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
		cause.printStackTrace();
		ctx.close();
	}
}
```
## 引导客户端

```
public class EchoClient {
	private final String host;
	private final int port;
	public EchoClient(String host, int port) {
		this.host = host;
		this.port = port;
	}
	public void start() throws Exception {
		  EventLoopGroup group = new NioEventLoopGroup();
     try {
			Bootstrap b = new Bootstrap();
			b.group(group)
			 .channel(NioSocketChannel.class)
		     .remoteAddress(new InetSocketAddress(host, port))
			 .handler(new ChannelInitializer<SocketChannel>() {
			 @Override
			 public void initChannel(SocketChannel ch) throws Exception {
				ch.pipeline().addLast(
				new EchoClientHandler());
				}
			 });
		  ChannelFuture f = b.connect().sync();
		  f.channel().closeFuture().sync();
	   } finally {
		group.shutdownGracefully().sync();
	  }
 }
 public static void main(String[] args) throws Exception {
		if (args.length != 2) {
			System.err.println("Usage: " + EchoClient.class.getSimpleName() +" <host> <port>");
            return;
         }
			String host = args[0];
			int port = Integer.parseInt(args[1]);
			new EchoClient(host, port).start();
		}
}
```

# netty 组件

## Channel、EventLoop 和 ChannelFuture

* Channel — Socket

1. EmbeddedChannel
2. LocalServerChannel
3. NioDatagramChannel
4. NioSctpChannel
5. NioSocketChannel

* EventLoop — 控制流、多线程处理、并发
1. 一个 EventLoopGroup 包含一个或者多个 EventLoop；
2. 一个 EventLoop 在它的生命周期内只和一个 Thread 绑定；
3. 所有由 EventLoop 处理的 I/O 事件都将在它专有的 Thread 上被处理；
4. 一个 Channel 在它的生命周期内只注册于一个 EventLoop；
5. 一个 EventLoop 可能会被分配给一个或多个 Channel

* ChannelFuture — 异步通知
    注册占位符

## ChannelHandler 和 ChannelPipeline

### ChannelHandler  
它充当了所有处理入站和出站数据的应用程序逻辑的容器   
ChannelInboundHandler 是一个你将会经常实现的子接口。这种类型的ChannelHandler 接收入站事件和数据，这些数据随后将会被你的应用程序的业务逻辑所处理

### ChannelPipeline 接口
ChannelPipeline 提供了 ChannelHandler 链的容器，并定义了用于在该链上传播入站
和出站事件流的 API。当 Channel 被创建时，它会被自动地分配到它专属的 ChannelPipeline。
ChannelHandler 是专为支持广泛的用途而设计的，可以将它看作是处理往来 Channel-
Pipeline 事件（包括数据）的任何代码的通用容器
Channel-Handler 派生的 ChannelInboundHandler 和 ChannelOutboundHandler 接口

### 编码器和解码器
当你通过 Netty 发送或者接收一个消息的时候，就将会发生一次数据转换。入站消息会被解
码；也就是说，从字节转换为另一种格式，通常是一个 Java 对象。如果是出站消息，则会发生
相反方向的转换：它将从它的当前格式被编码为字节。这两种方向的转换的原因很简单：网络数
据总是一系列的字节
所有由 Netty 提供的编码器/解码器适配器类都实现了 ChannelOutboundHandler 或者 ChannelInboundHandler 接口
 out-messagetobyte , in-bytetomessage

### 抽象类 SimpleChannelInboundHandler

####  引导
Netty 的引导类为应用程序的网络层配置提供了容器，这涉及将一个进程绑定到某个指定的
端口，或者将一个进程连接到另一个运行在某个指定主机的指定端口上的进程。
通常来说，我们把前面的用例称作引导一个服务器，后面的用例称作引导一个客户端。虽然
这个术语简单方便，但是它略微掩盖了一个重要的事实，即“服务器”和“客户端”实际上表示
了不同的网络行为；
换句话说，是监听传入的连接还是建立到一个或者多个进程的连接。

有两种类型的引导：一种用于客户端（简单地称为 Bootstrap），而另一种（ServerBootstrap）用于服务器

ServerBootstrap 为什么需要两个
第一组将只包含一个 ServerChannel，代表服务器自身的已绑定到某个本地端口的正在监听的套接字。
而第二组将包含所有已创建的用来处理传入客户端连接（对于每个服务器已经接受的连接都有一个）的 Channel


# 传输

## 传输api

 interface Channel
   每个 Channel 都将会被分配一个 ChannelPipeline 和 ChannelConfig  
   
* 将数据从一种格式转换为另一种格式；
* 提供异常的通知；
* 提供 Channel 变为活动的或者非活动的通知；
* 提供当 Channel 注册到 EventLoop 或者从 EventLoop 注销时的通知；
* 提供有关用户自定义事件的通知。  

拦截过滤器 ChannelPipeline 实现了一种常见的设计模式 — 拦截过滤器（Intercepting
Filter）。UNIX 管道是另外一个熟悉的例子：多个命令被链接在一起，其中一个命令的输出端将连
接到命令行中下一个命令的输入端

### 内置的传输

1. nio

java.nio.channels.SelectionKey  定义的位模式,这些位模式可以组合起来定义一组应用程序正在请求通知的状态变化集

零拷贝
零拷贝（zero-copy）是一种目前只有在使用 NIO 和 Epoll 传输时才可使用的特性。它使你可以快速
高效地将数据从文件系统移动到网络接口，而不需要将其从内核空间复制到用户空间，其在像 FTP 或者
HTTP 这样的协议中可以显著地提升性能。但是，并不是所有的操作系统都支持这一特性。特别地，它对
于实现了数据加密或者压缩的文件系统是不可用的——只能传输文件的原始内容。反过来说，传输已被
加密的文件则不是问题

2. Epoll — 用于 Linux 的本地非阻塞传输
Linux作为高性能网络编程的平台，其重要性与日俱增，这催生了大量先进特性的开发，其
中包括epoll——一个高度可扩展的I/O事件通知特性。这个API自Linux内核版本 2.5.44（2002）被
引入，提供了比旧的POSIX select和poll系统调用
 
3. OIO — 旧的阻塞 I/O

Netty是如何能够使用和用于异步传输相同的API来支持OIO的呢。
答案就是，Netty利用了SO_TIMEOUT这个Socket标志，它指定了等待一个I/O操作完成的最大毫秒
数。如果操作在指定的时间间隔内没有完成，则将会抛出一个SocketTimeout Exception。Netty
将捕获这个异常并继续处理循环。在EventLoop下一次运行时，它将再次尝试。这实际上也是
类似于Netty这样的异步框架能够支持OIO的唯一方式


4. 用于 JVM 内部通信的 Local 传输

5. Embedded 传输

### 总结

应用程序的需求 推荐的传输
非阻塞代码库或者一个常规的起点 -NIO（或者在 Linux 上使用 epoll）
阻塞代码库   - OIO
在同一个 JVM 内部的通信 -   Local
测试 ChannelHandler的实现 - Embedded


# bytebuf

网络数据的基本单位总是字节。Java NIO 提供了 ByteBuffer 作为它的字节容器

## abstract class ByteBuf 和 interface  ByteBufHolder

* 它可以被用户自定义的缓冲区类型扩展；
* 通过内置的复合缓冲区类型实现了透明的零拷贝；
* 容量可以按需增长（类似于 JDK 的 StringBuilder）；
* 在读和写这两种模式之间切换不需要调用 ByteBuffer 的 flip()方法；
* 读和写使用了不同的索引；
* 支持方法的链式调用；
* 支持引用计数；
* 支持池化。 

## ByteBuf 类——Netty 的数据容器

### 如何工作

ByteBuf 维护了两个不同的索引：一个用于读取，一个用于写入。
当你从 ByteBuf 读取时，它的 readerIndex 将会被递增已经被读取的字节数。
同样地，当你写入 ByteBuf 时，它的writerIndex 也会被递增

#### ByteBuf 的使用模式
1. 堆缓冲区
 最常用的 ByteBuf 模式是将数据存储在 JVM 的堆空间中。这种模式被称为支撑数组
（backing array），它能在没有使用池化的情况下提供快速的分配和释放。这种方式，非常适合于有遗留的数据需要处理的情况

2. 直接缓冲区
直接缓冲区是另外一种 ByteBuf 模式。我们期望用于对象创建的内存分配永远都来自于堆
中，但这并不是必须的——NIO 在 JDK 1.4 中引入的 ByteBuffer 类允许 JVM 实现通过本地调
用来分配内存。这主要是为了避免在每次调用本地 I/O 操作之前（或者之后）将缓冲区的内容复
制到一个中间缓冲区（或者从中间缓冲区把内容复制到缓冲区）

直接缓冲区的主要缺点是，相对于基于堆的缓冲区，它们的分配和释放都较为昂贵。如果你
正在处理遗留代码，你也可能会遇到另外一个缺点：因为数据不是在堆上，所以你不得不进行一
次复制

3. 复合缓冲区

第三种也是最后一种模式使用的是复合缓冲区，它为多个 ByteBuf 提供一个聚合视图。在
这里你可以根据需要添加或者删除 ByteBuf 实例，这是一个 JDK 的 ByteBuffer 实现完全缺
失的特性

##  字节级操作

1. 随机访问索引
2. 顺序访问索引
3. 可丢弃字节
4. 可读字节
5. 可写字节
6. 索引管理
7. 查找操作
8. 派生缓冲区
9. 读/写操作

## ByteBufHolder 接口

我们经常发现，除了实际的数据负载之外，我们还需要存储各种属性值。HTTP 响应便是一
个很好的例子，除了表示为字节的内容，还包括状态码、cookie 等

为了处理这种常见的用例，Netty 提供了 ByteBufHolder。ByteBufHolder 也为 Netty 的
高级特性提供了支持，如缓冲区池化，其中可以从池中借用 ByteBuf，并且在需要时自动释放

### ByteBuf 分配
1. 按需分配：ByteBufAllocator 接口
2. Unpooled 缓冲区
3. ByteBufUtil 类

## 引用计数

引用计数是一种通过在某个对象所持有的资源不再被其他对象引用时释放该对象所持有的资源来优化内存使用和性能的技术。
Netty 在第 4 版中为 ByteBuf 和 ByteBufHolder 引入了引用计数技术，它们都实现了 interface ReferenceCounted

# ChannelHandler 和 ChannelPipeline

## ChannelHandler 家族

### Channel 的生命周期
 状态模型(流转)
ChannelUnregistered Channel 已经被创建，但还未注册到 EventLoop
ChannelRegistered Channel 已经被注册到了 EventLoop
ChannelActive Channel 处于活动状态（已经连接到它的远程节点）。它现在可以接收和发送数据了
ChannelInactive Channel 没有连接到远程节点

### ChannelHandler 的生命周期

handlerAdded   当把 ChannelHandler 添加到 ChannelPipeline 中时被调用
handlerRemoved  当从 ChannelPipeline 中移除 ChannelHandler 时被调用
exceptionCaught 当处理过程中在 ChannelPipeline 中有错误产生时被调用

Netty 定义了下面两个重要的 ChannelHandler 子接口：
* ChannelInboundHandler——处理入站数据以及各种状态变化；
* ChannelOutboundHandler——处理出站数据并且允许拦截所有的操作。

### ChannelInboundHandler 接口

channelRegistered   当 Channel 已经注册到它的 EventLoop 并且能够处理 I/O 时被调用
channelUnregistered 当 Channel 从它的 EventLoop 注销并且无法处理任何 I/O 时被调用
channelActive 当 Channel 处于活动状态时被调用； Channel 已经连接/绑定并且已经就绪
channelInactive 当 Channel 离开活动状态并且不再连接它的远程节点时被调用
channelReadComplete当 Channel 上的一个读操作完成时被调用
channelRead 当从 Channel 读取数据时被调用
ChannelWritability-Changed 当 Channel 的可写状态发生改变时被调用。用户可以确保写操作不会完成
得太快（以避免发生 OutOfMemoryError ）或者可以在 Channel 变为再次可写时恢复写入。可以通过调用 Channel 的 isWritable() 方法来检测Channel 的可写性。与可写性相关的阈值可以通过 Channel.config().setWriteHighWaterMark() 和 Channel.config().setWriteLowWater-Mark() 方法来设置
userEventTriggered  当 ChannelnboundHandler.fireUserEventTriggered() 方法被调
用时被调用，因为一个 POJO 被传经了 ChannelPipeline

### ChannelOutboundHandler 接口

bind(ChannelHandlerContext,SocketAddress,ChannelPromise) 当请求将 Channel 绑定到本地地址时被调用
connect(ChannelHandlerContext,SocketAddress,SocketAddress,ChannelPromise)当请求将 Channel 连接到远程节点时被调用
disconnect(ChannelHandlerContext, ChannelPromise)当请求将 Channel 从远程节点断开时被调用
close(ChannelHandlerContext,ChannelPromise) 当请求关闭 Channel 时被调用deregister(ChannelHandlerContext,
ChannelPromise)当请求将 Channel 从它的 EventLoop 注销时被调用
read(ChannelHandlerContext)当请求从 Channel 读取更多的数据时被调用
flush(ChannelHandlerContext)当请求通过 Channel 将入队数据冲刷到远程节点时被调用
write(ChannelHandlerContext,Object,
ChannelPromise)当请求通过 Channel 将数据写到远程节点时被调用

### ChannelHandler 适配器

你可以使用 ChannelInboundHandlerAdapter 和 ChannelOutboundHandlerAdapter
类作为自己的ChannelHandler 的起始点。这两个适配器分别提供了ChannelInboundHandler
和 ChannelOutboundHandler 的基本实现。通过扩展抽象类 ChannelHandlerAdapter，它们
获得了它们共同的超接口ChannelHandler 的方法

ChannelHandlerAdapter 还提供了实用方法 isSharable()。如果其对应的实现被标
注为 Sharable，那么这个方法将返回 true，表示它可以被添加到多个 ChannelPipeline
中

### 资源管理

每当通过调用 ChannelInboundHandler.channelRead()或者 ChannelOutbound-
Handler.write()方法来处理数据时，你都需要确保没有任何的资源泄漏

## ChannelPipeline 接口

如果你认为ChannelPipeline是一个拦截流经Channel的入站和出站事件的Channel-
Handler 实例链，那么就很容易看出这些 ChannelHandler 之间的交互是如何组成一个应用
程序数据和事件处理逻辑的核心的

每一个新创建的 Channel 都将会被分配一个新的 ChannelPipeline。这项关联是永久性
的；Channel 既不能附加另外一个 ChannelPipeline，也不能分离其当前的。在 Netty 组件
的生命周期中，这是一项固定的操作，不需要开发人员的任何干预

>ChannelHandlerContext
ChannelHandlerContext使得ChannelHandler能够和它的ChannelPipeline以及其他的
ChannelHandler交互。ChannelHandler可以通知其 所属的ChannelPipeline中的下一个
ChannelHandler，甚至可以动态修改它所属的ChannelPipeline ① 。

### 修改 ChannelPipeline

ChannelHandler 可以通过添加、删除或者替换其他的 ChannelHandler 来实时地修改
ChannelPipeline 的布局。（它也可以将它自己从ChannelPipeline 中移除。）


>ChannelHandler 的执行和阻塞
通常 ChannelPipeline 中的每一个 ChannelHandler 都是通过它的 EventLoop（I/O 线程）来处
理传递给它的事件的。所以至关重要的是不要阻塞这个线程，因为这会对整体的 I/O 处理产生负面的影响。
但有时可能需要与那些使用阻塞 API 的遗留代码进行交互。对于这种情况，ChannelPipeline 有一些
接受一个 EventExecutorGroup 的 add()方法。如果一个事件被传递给一个自定义的EventExecutor-
将 该 实 例 作 为"handler1"添加到ChannelPipeline 中将一个 SecondHandler的实例作为"handler2"添加到ChannelPipeline的第一个槽中。这意味着它将被放置在已有的"handler1"之前将一个 ThirdHandler 的实例作为"handler3"添加到 ChannelPipeline 的最后一个槽中
Group，它将被包含在这个 EventExecutorGroup 中的某个 EventExecutor 所处理，从而被从该
Channel 本身的 EventLoop 中移除。对于这种用例，Netty 提供了一个叫 DefaultEventExecutor-
Group 的默认实现。


### 触发事件
* ChannelPipeline 保存了与 Channel 相关联的 ChannelHandler；
* ChannelPipeline 可以根据需要，通过添加或者删除 ChannelHandler 来动态地修改；
* ChannelPipeline 有着丰富的 API 用以被调用，以响应入站和出站事件

## ChannelHandlerContext 接口

ChannelHandlerContext 代表了 ChannelHandler 和 ChannelPipeline 之间的关
联，每当有 ChannelHandler 添加到 ChannelPipeline 中时，都会创建 ChannelHandler-
Context。ChannelHandlerContext 的主要功能是管理它所关联的 ChannelHandler 和在
同一个 ChannelPipeline 中的其他 ChannelHandler 之间的交互   

ChannelHandlerContext 有很多的方法，其中一些方法也存在于 Channel 和 Channel-
Pipeline 本身上，但是有一点重要的不同。如果调用 Channel 或者 ChannelPipeline 上的这
些方法，它们将沿着整个 ChannelPipeline 进行传播。而调用位于 ChannelHandlerContext
上的相同方法，则将从当前所关联的 ChannelHandler 开始，并且只会传播给位于该
ChannelPipeline 中的下一个能够处理该事件的ChannelHandler   

当使用 ChannelHandlerContext 的 API 的时候，请牢记以下两点：    
1. ChannelHandlerContext 和 ChannelHandler 之间的关联（绑定）是永远不会改
变的，所以缓存对它的引用是安全的；
2. 如同我们在本节开头所解释的一样，相对于其他类的同名方法，ChannelHandler Context
的方法将产生更短的事件流，应该尽可能地利用这个特性来获得最大的性能

###  使用 ChannelHandlerContext

要想调用从某个特定的 ChannelHandler 开始的处理过程，必须获取到在（Channel-
Pipeline）该 ChannelHandler 之前的 ChannelHandler 所关联的 ChannelHandler-
Context。这个 ChannelHandlerContext 将调用和它所关联的 ChannelHandler 之后的
ChannelHandler  

### ChannelHandler 和 ChannelHandlerContext 的高级用法

你可以通过调用 ChannelHandlerContext 上的
pipeline()方法来获得被封闭的 ChannelPipeline 的引用。这使得运行时得以操作
ChannelPipeline 的 ChannelHandler，我们可以利用这一点来实现一些复杂的设计。例如，
你可以通过将 ChannelHandler 添加到 ChannelPipeline 中来实现动态的协议切换。   
另一种高级的用法是缓存到 ChannelHandlerContext 的引用以供稍后使用，这可能会发
生在任何的 ChannelHandler 方法之外，甚至来自于不同的线程。代码清单 6-9 展示了用这种
模式来触发事件   

为何要共享同一个 ChannelHandler 在多个ChannelPipeline中安装同一个ChannelHandler
的一个常见的原因是用于收集跨越多个Channel 的统计信息

## 异常处理

### 处理入站异常

如果在处理入站事件的过程中有异常被抛出，那么它将从它在 ChannelInboundHandler
里被触发的那一点开始流经 ChannelPipeline。要想处理这种类型的入站异常，你需要在你
的 ChannelInboundHandler 实现中重写下面的方法    
* ChannelHandler.exceptionCaught()的默认实现是简单地将当前异常转发给
* ChannelPipeline 中的下一个 ChannelHandler；如果异常到达了 ChannelPipeline 的尾端，它将会被记录为未被处理；
* 要想定义自定义的处理逻辑，你需要重写 exceptionCaught()方法。然后你需要决定是否需要将该异常传播出去

### 处理出站异常
用于处理出站操作中的正常完成以及异常的选项，都基于以下的通知机制。

* 每个出站操作都将返回一个 ChannelFuture。注册到 ChannelFuture 的 Channel-
FutureListener 将在操作完成时被通知该操作是成功了还是出错了。
* 几乎所有的 ChannelOutboundHandler 上的方法都会传入一个 ChannelPromise
的实例。作为 ChannelFuture 的子类，ChannelPromise 也可以被分配用于异步通
知的监听器


# EventLoop 和线程模型

## 线程模型概述

线程池 Executor
基本的线程池化模式可以描述为：
* 从池的空闲线程列表中选择一个 Thread，并且指派它去运行一个已提交的任务（一个Runnable 的实现）；
* 当任务完成时，将该 Thread 返回给该列表，使其可被重用  

虽然池化和重用线程相对于简单地为每个任务都创建和销毁线程是一种进步，但是它并不能
消除由上下文切换所带来的开销，其将随着线程数量的增加很快变得明显，并且在高负载下愈演
愈烈。此外，仅仅由于应用程序的整体复杂性或者并发需求，在项目的生命周期内也可能会出现
其他和线程相关的问题

## EventLoop 接口
Netty 的 EventLoop 是协同设计的一部分，它采用了两个基本的 API：并发和网络编程。
首先，io.netty.util.concurrent 包构建在 JDK 的 java.util.concurrent 包上，用
来提供线程执行器。其次，io.netty.channel 包中的类，为了与 Channel 的事件进行交互，
扩展了这些接口/类    

在这个模型中，一个 EventLoop 将由一个永远都不会改变的 Thread 驱动，同时任务
（Runnable 或者 Callable）可以直接提交给 EventLoop 实现，以立即执行或者调度执行。
根据配置和可用核心的不同，可能会创建多个 EventLoop 实例用以优化资源的使用，并且单个
EventLoop 可能会被指派用于服务多个 Channel。   

事件/任务的执行顺序 事件和任务是以先进先出（FIFO）的顺序执行的。这样可以通过保证字
节内容总是按正确的顺序被处理，消除潜在的数据损坏的可能性。

### Netty 4 中的 I/O 和事件处理
事件的性质通常决定了它将被如何处理；它可能将数据从网络栈中传递到你的应用程序中，
或者进行逆向操作，或者 执行一些截然不同的操作。但是事件的处理逻辑必须足够的通用和灵活，
以处理所有可能的用例。因此，在Netty 4 中，所有的I/O操作和事件都由已经被分配给了
EventLoop的那个Thread来处理

### Netty 3 中的 I/O 操作

在以前的版本中所使用的线程模型只保证了入站（之前称为上游）事件会在所谓的 I/O 线程
（对应于 Netty 4 中的 EventLoop）中执行。所有的出站（下游）事件都由调用线程处理，其可
能是 I/O 线程也可能是别的线程。开始看起来这似乎是个好主意，但是已经被发现是有问题的，
因为需要在 ChannelHandler 中对出站事件进行仔细的同步。简而言之，不可能保证多个线程
不会在同一时刻尝试访问出站事件   

当出站事件触发了入站事件时，将会导致另一个负面影响。当 Channel.write()方法导
致异常时，需要生成并触发一个 exceptionCaught 事件。但是在 Netty 3 的模型中，由于这是
一个入站事件，需要在调用线程中执行代码，然后将事件移交给 I/O 线程去执行，然而这将带来
额外的上下文切换。    

Netty 4 中所采用的线程模型，通过在同一个线程中处理某个给定的 EventLoop 中所产生的
所有事件，解决了这个问题。这提供了一个更加简单的执行体系架构，并且消除了在多个
ChannelHandler 中进行同步的需要（除了任何可能需要在多个 Channel 中共享的）

## 任务调度

###  JDK 的任务调度 API

虽然 ScheduledExecutorService API 是直截了当的，但是在高负载下它将带来性能上的负担

### 使用 EventLoop 调度任务

### 实现细节

如果（当前）调用线程正是支撑 EventLoop 的线程，那么所提交的代码块将会被（直接）
执行。否则，EventLoop 将调度该任务以便稍后执行，并将它放入到内部队列中。当 EventLoop
下次处理它的事件时，它会执行队列中的那些任务/事件。这也就解释了任何的 Thread 是如何
与 Channel 直接交互而无需在 ChannelHandler 中进行额外同步的。  

注意，每个 EventLoop 都有它自已的任务队列，独立于任何其他的 EventLoop   
我们再以另一种方式重申一次：“永远不要将一个长时间运行的任务放入到执行队列中，因为它将阻塞需要在同一线程上执行的任何
其他任务。”如果必须要进行阻塞调用或者执行长时间运行的任务，我们建议使用一个专门的
EventExecutor。（见 6.2.1 节的“ChannelHandler 的执行和阻塞”）


#### EventLoop/线程的分配

1．异步传输
    异步传输实现只使用了少量的 EventLoop（以及和它们相关联的 Thread），而且在当前的
线程模型中，它们可能会被多个 Channel 所共享。这使得可以通过尽可能少量的 Thread 来支撑大量的 Channel，
而不是每个 Channel 分配一个 Thread    

一旦一个 Channel 被分配给一个 EventLoop，它将在它的整个生命周期中都使用这个
EventLoop（以及相关联的 Thread）。请牢记这一点，因为它可以使你从担忧你的 Channel-
Handler 实现中的线程安全和同步问题中解脱出来   

EventLoopGroup 负责为每个新创建的 Channel 分配一个 EventLoop。在当前实现中，
使用顺序循环（round-robin）的方式进行分配以获取一个均衡的分布，并且相同的 EventLoop
可能会被分配给多个 Channel   

另外，需要注意的是，EventLoop 的分配方式对 ThreadLocal 的使用的影响。因为一个
EventLoop 通常会被用于支撑多个 Channel，所以对于所有相关联的 Channel 来说，
ThreadLocal 都将是一样的。这使得它对于实现状态追踪等功能来说是个糟糕的选择。然而，
在一些无状态的上下文中，它仍然可以被用于在多个 Channel 之间共享一些重度的或者代价昂
贵的对象，甚至是事件
2. 阻塞传输
这里每一个 Channel 都将被分配给一个 EventLoop（以及它的 Thread）

# 引导  Bootstrapping

## Bootstrap 类

引导类的层次结构包括一个抽象的父类和两个具体的引导子类

### 引导客户端和无连接协议

Bootstrap 类被用于客户端或者使用了无连接协议的应用程序

#### 引导客户端

Bootstrap 类负责为客户端和使用无连接协议的应用程序创建 Channel

#### Channel 和 EventLoopGroup 的兼容性

必须保持这种兼容性，不能混用具有不同前缀的组件

### 引导服务器

####  ServerBootstrap 类

#### 引导服务器


### 从 Channel 引导客户端

假设你的服务器正在处理一个客户端的请求，这个请求需要它充当第三方系统的客户端。当
一个应用程序（如一个代理服务器）必须要和组织现有的系统（如 Web 服务或者数据库）集成
时，就可能发生这种情况。在这种情况下，将需要从已经被接受的子 Channel 中引导一个客户
端 Channel

### 在引导过程中添加多个 ChannelHandler 

如果你的应用程序使用了多个 ChannelHandler，请定义你自己的 ChannelInitializer
实现来将它们安装到ChannelPipeline 中。

### 使用 Netty 的 ChannelOption 和属性

在每个 Channel 创建时都手动配置它可能会变得相当乏味。幸运的是，你不必这样做。相
反，你可以使用 option()方法来将 ChannelOption 应用到引导。你所提供的值将会被自动
应用到引导所创建的所有 Channel。可用的 ChannelOption 包括了底层连接的详细信息，如
keep-alive 或者超时属性以及缓冲区设置。   



###  引导 DatagramChannel


### 关闭 

引导使你的应用程序启动并且运行起来，但是迟早你都需要优雅地将它关闭。当然，你也可
以让 JVM 在退出时处理好一切，但是这不符合优雅的定义，优雅是指干净地释放资源。关闭 Netty
应用程序并没有太多的魔法，但是还是有些事情需要记在心上。  

最重要的是，你需要关闭 EventLoopGroup，它将处理任何挂起的事件和任务，并且随后
释放所有活动的线程。这就是调用 EventLoopGroup.shutdownGracefully()方法的作用。
这个方法调用将会返回一个 Future，这个 Future 将在关闭完成时接收到通知。需要注意的是，
shutdownGracefully()方法也是一个异步的操作，所以你需要阻塞等待直到它完成，或者向
所返回的 Future 注册一个监听器以在关闭完成时获得通知

# EmbeddedChannel


#编解码器 

## 什么是编解码器

每个网络应用程序都必须定义如何解析在两个节点之间来回传输的原始字节，以及如何将其和
目标应用程序的数据格式做相互转换。这种转换逻辑由编解码器处理，编解码器由编码器和解码
器组成，它们每种都可以将字节流从一种格式转换为另一种格式

区别   

如果将消息看作是对于特定的应用程序具有具体含义的结构化的字节序列 — 它的数据。那
么编码器是将消息转换为适合于传输的格式（最有可能的就是字节流）；而对应的解码器则是将
网络字节流转换回应用程序的消息格式。因此，编码器操作出站数据，而解码器处理入站数据

## 解码器

* 将字节解码为消息——ByteToMessageDecoder 和 ReplayingDecoder
* 将一种消息类型解码为另一种——MessageToMessageDecoder

### 抽象类 ByteToMessageDecoder

>编解码器中的引用计数
正如我们在第 5 章和第 6 章中所提到的，引用计数需要特别的注意。对于编码器和解码器来说，其过程
也是相当的简单：一旦消息被编码或者解码，它就会被ReferenceCountUtil.release(message)调用
自动释放。如果你需要保留引用以便稍后使用，那么你可以调用ReferenceCountUtil.retain(message)
方法。这将会增加该引用计数，从而防止该消息被释放。

### 抽象类 ReplayingDecoder

### 抽象类 MessageToMessageDecoder

### TooLongFrameException 类

由于 Netty 是一个异步框架，所以需要在字节可以解码之前在内存中缓冲它们。因此，不能
让解码器缓冲大量的数据以至于耗尽可用的内存。为了解除这个常见的顾虑，Netty 提供了
TooLongFrameException 类，其将由解码器在帧超出指定的大小限制时抛出   

为了避免这种情况，你可以设置一个最大字节数的阈值，如果超出该阈值，则会导致抛出一
个 TooLongFrameException（随后会被 ChannelHandler.exceptionCaught()方法捕
获）。然后，如何处理该异常则完全取决于该解码器的用户。某些协议（如 HTTP）可能允许你
返回一个特殊的响应。而在其他的情况下，唯一的选择可能就是关闭对应的连接

## 编码器

* 将消息编码为字节
* 将消息编码为消息

### 抽象类 MessageToByteEncoder

### 抽象类 MessageToMessageEncoder

## 抽象的编解码器类

虽然我们一直将解码器和编码器作为单独的实体讨论，但是你有时将会发现在同一个类中管理
入站和出站数据和消息的转换是很有用的。Netty 的抽象编解码器类正好用于这个目的，因为它们每
个都将捆绑一个解码器/编码器对，以处理我们一直在学习的这两种类型的操作。正如同你可能已经
猜想到的，这些类同时实现了ChannelInboundHandler 和ChannelOutboundHandler 接口。
为什么我们并没有一直优先于单独的解码器和编码器使用这些复合类呢？因为通过尽可能
地将这两种功能分开，最大化了代码的可重用性和可扩展性，这是 Netty 设计的一个基本原则


### 抽象类 ByteToMessageCodec

让我们来研究这样的一个场景：我们需要将字节解码为某种形式的消息，可能是 POJO，随
后再次对它进行编码。ByteToMessageCodec 将为我们处理好这一切，因为它结合了
ByteToMessageDecoder 以及它的逆向——MessageToByteEncoder。表 10-5 列出了其中
重要的方法。

### 抽象类 MessageToMessageCodec

decode()方法是将INBOUND_IN类型的消息转换为OUTBOUND_IN类型的消息，而
encode()方法则进行它的逆向操作。将INBOUND_IN类型的消息看作是通过网络发送的类型，
而将OUTBOUND_IN类型的消息看作是应用程序所处理的类型，将可能有所裨益


通过使用 MessageToMessageCodec，我们可以在一个单个的类中实现该转换的往返过程


在两种不同
的消息 API 之间来回转换数据。当我们不得不和使用遗留或者专有消息格式的 API 进行互操作
时，我们经常会遇到这种模式。

### CombinedChannelDuplexHandler 类

这个类充当了 ChannelInboundHandler 和 ChannelOutboundHandler（该类的类型
参数 I 和 O）的容器。通过提供分别继承了解码器类和编码器类的类型，我们可以实现一个编解
码器，而又不必直接扩展抽象的编解码器类


#  预置的 ChannelHandler和编解码器

## 通过 SSL/TLS 保护 Netty 应用程序

SslHandler 将是 ChannelPipeline 中的第一个 ChannelHandler   

在握手阶段，两个节点将相互验证并且商定一种加密方式。你可以通过配置 SslHandler 来修改它的行为，或者在 SSL/TLS
握手一旦完成之后提供通知，握手阶段完成之后，所有的数据都将会被加密。SSL/TLS 握手将会
被自动执行

## 构建基于 Netty 的 HTTP/HTTPS 应用程序

### HTTP 解码器、编码器和编解码器

### 聚合 HTTP 消息  


在 ChannelInitializer 将 ChannelHandler 安装到 ChannelPipeline 中之后，你
便可以处理不同类型的 HttpObject 消息了。但是由于 HTTP 的请求和响应可能由许多部分组
成，因此你需要聚合它们以形成完整的消息。为了消除这项繁琐的任务，Netty 提供了一个聚合
器，它可以将多个消息部分合并为 FullHttpRequest 或者 FullHttpResponse 消息。通过
这样的方式，你将总是看到完整的消息内容    

引入这种自动聚合机制只不过是向 ChannelPipeline 中添加另外一个 ChannelHandler罢了    


### HTTP 压缩

当使用 HTTP 时，建议开启压缩功能以尽可能多地减小传输数据的大小。虽然压缩会带来一
些 CPU 时钟周期上的开销，但是通常来说它都是一个好主意，特别是对于文本数据来说

### 使用 HTTPS

### WebSocket

WebSocket解决了一个长期存在的问题：既然底层的协议（HTTP）是一个请求/响应模式的交互序列，
那么如何实时地发布信息呢？AJAX提供了一定程度上的改善，但是数据流仍然是由客户端所发送的请求驱动的。
还有其他的一些或多或少的取巧方式

WebSocket规范以及它的实现代表了对一种更加有效的解决方案的尝试。简单地说，WebSocket提供了“
在一个单个的TCP连接上提供双向的通信……结合WebSocket API……它为网页和远程服务器之间的双向通
信提供了一种替代HTTP轮询的方案。”，但是最终它们仍然属于扩展性受限的变通之法    

要想向你的应用程序中添加对于 WebSocket 的支持，你需要将适当的客户端或者服务器
WebSocket ChannelHandler 添加到 ChannelPipeline 中。这个类将处理由 WebSocket 定义
的称为帧的特殊消息类型    

## 空闲的连接和超时

如果连接超过60 秒没有接收或者发送任何的数据，那么 IdleStateHandler 将会使用一个
IdleStateEvent 事件来调用 fireUserEventTriggered()方法。HeartbeatHandler 实现
了 userEventTriggered()方法，如果这个方法检测到 IdleStateEvent 事件，它将会发送心
跳消息，并且添加一个将在发送操作失败时关闭该连接的ChannelFutureListener   

## 解码基于分隔符的协议和基于长度的协议 

### 基于分隔符的协议

基于分隔符的（delimited）消息协议使用定义的字符来标记的消息或者消息段（通常被称
为帧）的开头或者结尾。由RFC文档正式定义的许多协议（如SMTP、POP3、IMAP以及Telnet名 称）
都是这样的。此外，当然，私有组织通常也拥有他们自己的专有格式。无论你使用什么样的协议

### 基于长度的协议

基于长度的协议通过将它的长度编码到帧的头部来定义帧，而不是使用特殊的分隔符来标记它的结束

## 写大型数据

在我们讨论传输（见 4.2 节）的过程中，提到了 NIO 的零拷贝特性，这种特性消除了将文件
的内容从文件系统移动到网络栈的复制过程。所有的这一切都发生在 Netty 的核心中，所以应用
程序所有需要做的就是使用一个 FileRegion 接口的实现，其在 Netty 的 API 文档中的定义是：
“通过支持零拷贝的文件传输的 Channel 来发送的文件区域。

因为网络饱和的可能性，如何在异步框架中高效地写大块的数据是一个特殊的问题。由于写
操作是非阻塞的，所以即使没有写出所有的数据，写操作也会在完成时返回并通知 Channel-
Future。当这种情况发生时，如果仍然不停地写入，就有内存耗尽的风险。所以在写大型数据
时，需要准备好处理到远程节点的连接是慢速连接的情况，这种情况会导致内存释放的延迟


逐块输入 要使用你自己的 ChunkedInput 实现，请在 ChannelPipeline 中安装一个ChunkedWriteHandler

## 序列化数据

### JDK 序列化

### 使用 JBoss Marshalling 进行序列化

### 通过 Protocol Buffers 序列化


# 网络协议

## WebSocket

实时 Web 利用技术和实践，使用户在信息的作者发布信息之后就能够立即收到信
息，而不需要他们或者他们的软件周期性地检查信息源以获取更新。

## WebSocket 简介  

旨在为 Web 上的双向数据传输问题提供一个切实可行的解决方案，使得客户端和服务器之间可以在任意时刻传输消息，因此，这也就要求
它们异步地处理消息回执。（作为 HTML5 客户端 API 的一部分，大部分最新的浏览器都已经支持了 WebSocket。）

### 处理 HTTP 请求

### 处理 WebSocket 帧

### 初始化 ChannelPipeline
 
### 引导

# 使用 UDP 广播事件

## UDP 的基础知识

## UDP 广播

## 消息 POJO: LogEvent

## 编写广播者

## 编写监视器

## 运行 LogEventBroadcaster 和 LogEventMonitor
