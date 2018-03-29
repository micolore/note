# jvm 命令 

## jstat   
jstat -class [pid] [time] [count]

generalOption:     
* -help 显示帮助信息。
* -version 显示版本信息
* -options 显示统计选项列表    
参数:     
 * -class：统计类装载器的行为
 * -compiler：统计HotSpot Just-in-Time编译器的行为
 * -gc：统计堆各个分区的使用情况
 * -gccapacity：统计新生区，老年区，permanent区的heap容量情况 
 * -gccause：统计最后一次gc和当前gc的原因
 * -gcnew：统计gc时，新生代的情况 
 * -gcnewcapacity：统计新生代大小和空间
 * -gcold：统计老年代和永久代的行为
 * -gcoldcapacity：统计老年代大小 
 * -gcpermcapacity：统计永久代大小 
 * -gcutil：统计gc时，heap情况 
 * -printcompilation：HotSpot编译方法统计
 
 ## jmap 
  *  -dump:[live,]format=b,file=<filename> 使用hprof二进制形式,输出jvm的heap内容到文件=. live子选项是可选的，假如指定live选项,那么只输出活的对象到文件. 
  *   -finalizerinfo 打印正等候回收的对象的信息.
  *   -heap 打印heap的概要信息，GC使用的算法，heap的配置及wise heap的使用情况.
  *   -histo[:live] 打印每个class的实例数目,内存占用,类全名信息. VM的内部类名字开头会加上前缀”*”. 如果live子参数加上后,只统计活的对象数量. 
  *   -permstat 打印classload和jvm heap长久层的信息. 包含每个classloader的名字,活泼性,地址,父classloader和加载的class数量. 另外,内部String的数量和占用内存数也会打印出来. 
  *   -F 强迫.在pid没有相应的时候使用-dump或者-histo参数. 在这个模式下,live子参数无效. 
  *   -h | -help 打印辅助信息 
  *   -J 传递参数给jmap启动的jvm. 
  *   pid 需要被打印配相信息的java进程id.
  
#生成的文件可以使用jhat工具进行分析，在OOM（内存溢出）时，分析大对象，非常有用
jmap -dump:live,format=b,file=data.hprof 2058

#通过使用如下参数启动JVM，也可以获取到dump文件：
 -XX:+HeapDumpOnOutOfMemoryError
 -XX:HeapDumpPath=./java_pid<pid>.hprof

#如果在虚拟机中导出的heap信息文件可以拿到WINDOWS上进行分析，可以查找诸如内存方面的问题，可以这么做：
jhat data.hprof  
#执行成功后，访问http://localhost:7000即可查看内存信息。（首先把7000端口打开）

Attaching to process ID 31846, please wait...
Debugger attached successfully.
Server compiler detected.
JVM version is 24.71-b01

using thread-local object allocation.
Parallel GC with 4 thread(s)//GC 方式

Heap Configuration: //堆内存初始化配置
   MinHeapFreeRatio = 0 //对应jvm启动参数-XX:MinHeapFreeRatio设置JVM堆最小空闲比率(default 40)
   MaxHeapFreeRatio = 100 //对应jvm启动参数 -XX:MaxHeapFreeRatio设置JVM堆最大空闲比率(default 70)
   MaxHeapSize      = 2082471936 (1986.0MB) //对应jvm启动参数-XX:MaxHeapSize=设置JVM堆的最大大小
   NewSize          = 1310720 (1.25MB)//对应jvm启动参数-XX:NewSize=设置JVM堆的‘新生代’的默认大小
   MaxNewSize       = 17592186044415 MB//对应jvm启动参数-XX:MaxNewSize=设置JVM堆的‘新生代’的最大大小
   OldSize          = 5439488 (5.1875MB)//对应jvm启动参数-XX:OldSize=<value>:设置JVM堆的‘老生代’的大小
   NewRatio         = 2 //对应jvm启动参数-XX:NewRatio=:‘新生代’和‘老生代’的大小比率
   SurvivorRatio    = 8 //对应jvm启动参数-XX:SurvivorRatio=设置年轻代中Eden区与Survivor区的大小比值 
   PermSize         = 21757952 (20.75MB)  //对应jvm启动参数-XX:PermSize=<value>:设置JVM堆的‘永生代’的初始大小
   MaxPermSize      = 85983232 (82.0MB)//对应jvm启动参数-XX:MaxPermSize=<value>:设置JVM堆的‘永生代’的最大大小
   G1HeapRegionSize = 0 (0.0MB)
jmap -heap:   
Heap Usage://堆内存使用情况
PS Young Generation
Eden Space://Eden区内存分布
   capacity = 33030144 (31.5MB)//Eden区总容量
   used     = 1524040 (1.4534378051757812MB)  //Eden区已使用
   free     = 31506104 (30.04656219482422MB)  //Eden区剩余容量
   4.614088270399305% used //Eden区使用比率
From Space:  //其中一个Survivor区的内存分布
   capacity = 5242880 (5.0MB)
   used     = 0 (0.0MB)
   free     = 5242880 (5.0MB)
   0.0% used
To Space:  //另一个Survivor区的内存分布
   capacity = 5242880 (5.0MB)
   used     = 0 (0.0MB)
   free     = 5242880 (5.0MB)
   0.0% used
PS Old Generation //当前的Old区内存分布
   capacity = 86507520 (82.5MB)
   used     = 0 (0.0MB)
   free     = 86507520 (82.5MB)
   0.0% used
PS Perm Generation//当前的 “永生代” 内存分布
   capacity = 22020096 (21.0MB)
   used     = 2496528 (2.3808746337890625MB)
   free     = 19523568 (18.619125366210938MB)
   11.337498256138392% used

670 interned Strings occupying 43720 bytes.

## jinfo
#查看java进程的配置信息
jinfo 2058
#####################
Attaching to process ID 2058, please wait...
Debugger attached successfully.
Server compiler detected.
JVM version is 24.0-b56
Java System Properties:

java.runtime.name = Java(TM) SE Runtime Environment
project.name = Amoeba-MySQL
java.vm.version = 24.0-b56
sun.boot.library.path = /usr/local/java/jdk1.7/jre/lib/amd64
................................................

## 查看2058的MaxPerm大小可以用
 jinfo -flag MaxPermSize 2058
############################
-XX:MaxPermSize=100663296

## jps  

#列出系统中所有的java进程
  jps
#######################
2306 Bootstrap
3370 Jps 2058 xxxxxxxxx

## 术语
S0C：年轻代中第一个survivor（幸存区）的容量 (字节)  
S1C：年轻代中第二个survivor（幸存区）的容量 (字节)   
S0U：年轻代中第一个survivor（幸存区）目前已使用空间 (字节)  
S1U：年轻代中第二个survivor（幸存区）目前已使用空间 (字节)   
EC：年轻代中Eden（伊甸园）的容量 (字节)   
EU：年轻代中Eden（伊甸园）目前已使用空间 (字节)  
OC：Old代的容量 (字节)  
OU：Old代目前已使用空间 (字节)   
PC：Perm(持久代)的容量 (字节)  
PU：Perm(持久代)目前已使用空间 (字节)  
YGC：从应用程序启动到采样时年轻代中gc次数  
YGCT：从应用程序启动到采样时年轻代中gc所用时间(s)  
FGC：从应用程序启动到采样时old代(全gc)gc次数   
FGCT：从应用程序启动到采样时old代(全gc)gc所用时间(s)    
GCT：从应用程序启动到采样时gc用的总时间(s)  
NGCMN：年轻代(young)中初始化(最小)的大小 (字节)   
NGCMX：年轻代(young)的最大容量 (字节)   
NGC：年轻代(young)中当前的容量 (字节)   
OGCMN：old代中初始化(最小)的大小 (字节)    
OGCMX：old代的最大容量 (字节)   
OGC：old代当前新生成的容量 (字节)   
PGCMN：perm代中初始化(最小)的大小 (字节)    
PGCMX：perm代的最大容量 (字节)      
PGC：perm代当前新生成的容量 (字节)   
S0：年轻代中第一个survivor（幸存区）已使用的占当前容量百分比   
S1：年轻代中第二个survivor（幸存区）已使用的占当前容量百分比   
E：年轻代中Eden（伊甸园）已使用的占当前容量百分比  
O：old代已使用的占当前容量百分比  
P：perm代已使用的占当前容量百分比  
S0CMX：年轻代中第一个survivor（幸存区）的最大容量 (字节)  
S1CMX：年轻代中第二个survivor（幸存区）的最大容量 (字节)  
ECMX：年轻代中Eden（伊甸园）的最大容量 (字节)  
DSS：当前需要survivor（幸存区）的容量 (字节)（Eden区已满）   
TT： 持有次数限制   
MTT ： 最大持有次数限制   




 
