# JDK&JRE Bin tools 
   以下这些工具,用以排查问题，解决故障,根据目标阀值来判断数据是否为异常状态。工具-数据-状态-问题-解决 
## 基本工具
* javac.exe	Java语言编译器
* java.exe	Java应用程序启动器
* javaw.exe	Java运行工具，用于运行.class字节码文件或.jar文件，但不会显示控制台输出信息，适用于运行图形化程序。
* javadoc.exe	Java API文档生成器
* apt.exe	java 注释处理器
* appletviewer.exe	java applet小程序查看器
* jar.exe	java文件压缩打包工具
* jdb.exe	Java调试器
* javah.exe	C头文件和stub生成器，用于写本地化方法，例如生产JNI样式的头文件
* javap.exe	class文件反编译工具
* extcheck.exe	用于检测jar包中的问题
* jcmd.exe	Java命令行(Java Command)，用于向正在运行的JVM发送诊断命令请求。

## 安全工具
* keytool.exe	管理密钥库和证书
* jarsigner.exe	生产和校验JAR签名
* policytool.exe	有用户界面的规则管理工具
* kinit.exe	用于获得和缓存网络认证协议Kerberos 票证的授予票证
* klist.exe	凭据高速缓存和密钥表中的 Kerberos 显示条目
* ktab.exe	密钥和证书管理工具

## 国际化工具
* native2ascii.exe 

## 远程方法调用
* rmic.exe	生成远程对象的stubs and skeletons(存根和框架)
* rmid.exe	Java远程方法调用(RMI:Remote Method Invocation)活化系统守护进程
* rmiregistry.exe	Java远程对象注册表
* serialver.exe	返回类的 serialVersionUID
* java-rmi.exe	Java远程方法调用(Java Remote Method Invocation)工具，主要用于在客户机上调用远程服务器上的对象

## Java IDL and RMI-IIOP 工具
* tnameserv.exe	Java IDL瞬时命名服
* idlj.exe	生产映射到OMG IDL接口可以使Java应用程序使用CORBA的.java文件
* orbd.exe	为客户可以在CORBA环境下透明的定位和调用服务器的稳定的对象提供支持
* servertool.exe	为应用程序提供易于使用的接口用于注册，注销，启动，关闭服务器

## java部署工具
* pack200.exe	使用java gzip压缩工具将JAR文件转换为压缩的pack200文件，生产打包文件是高度压缩的JAR包，可以直接部署，减少下载时间
* unpack200.exe	解包pack200文件为JARs

## Java web工具
* javaws.exe	Java web 启动命令行工具
* schemagen.exe	Java构架的XML Schema生成器
* wsgen.exe	生成 JAX-WS
* wsimport.exe	生成 JAX-WS
* xjc.exe	绑定编译器

## Java故障检修，程序概要分析，监视和管理工具
* jvisualvm.exe	一个图形化的Java虚拟机
* jconsole.exe	java监视台和管理控制台
* jps.exe	JVM Process Status进程状态工具。列出目标系统的HotSpot JJVM
* jstat.exe	按照命令行的具体要求记录和收集一个JVM的性能数据
* jstatd.exe	JVM jstat 的守护进程
* jmc.exe	Java任务控制工具(Java Mission Control)，主要用于HotSpot JVM的生产时间监测、分析、诊断。

## 故障检测和修理工具
* jinfo.exe	配置或打印某个Java进程VM flag
* jhat.exe	堆储存查看器
* jmap.exe	Java内存图
* jsadebugd.exe	Java的 Serviceability Agent Debug的守护进程
* jstack.exe	Java堆栈跟踪

## Java 脚本工具
* jrunscript.exe	运行脚本

## other
* jabswitch.exe	Java Access Bridge Switch的简称，用于控制Java访问桥的开/关。Java访问桥是一种技术，让Java应用程序实现Accessibility API，以供Microsoft Windows系统的辅助技术访问。
* javafxpackager.exe	JavaFX打包工具  


[参考链接](http://www.codingwhy.com/view/858.html 'jdk bin目录下工具介绍')
