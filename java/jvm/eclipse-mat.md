# mat  eclipse
先使用jmap打印出来
jmap -dump:live,format=b,file=data.hprof pid   
jmap -dump,format=b,file=data.hprof pid  
如果使用jhat 要设置内存防止内存不够   
## download 
[down-load-mat](http://www.eclipse.org/mat/downloads.php)
##  Leak Suspects

## 使用mat 直接打开第一步生成的文件

### 分析报告
分析三步曲
通常我们都会采用下面的“三步曲”来分析内存泄露问题：

首先，对问题发生时刻的系统内存状态获取一个整体印象。

第二步，找到最有可能导致内存泄露的元凶，通常也就是消耗内存最多的对象

接下来，进一步去查看这个内存消耗大户的具体情况，看看是否有什么异常的行为。

下面将用一个基本的例子来展示如何采用“三步曲”来查看生产的分析报告。

#### example 
* Shortest Paths To the Accumulation Point  从根元素到内存消耗聚集点的最短路径
* Accumulated Objects in Dominator Tree
* Accumulated Objects by Class in Dominator Tree
* All Accumulated Objects by Class
* shallow 浅 就是对象本身占用内存的大小，不包含其引用的对象
* retained 保留 它表示如果一个对象被释放掉，那会因为该对象的释放而减少引用进而被释放的所有的对象（包括被递归释放的）所占用的heap大小。于是，如果一个对象的某个成员new了一大块int数组，那这个int数组也可以计算到这个对象中。相对于shallow heap，Retained heap可以更精确的反映一个对象实际占用的大小（因为如果该对象释放，retained heap都可以被释放）。
* list number of instances per class
* outgoing references ：表示该对象的出节点（被该对象引用的对象）。
* incoming references ：表示该对象的入节点（引用到该对象的对象）。
action
* histogram 直方图
* dominator tree  
* top consumer 消费者
* duplicate class 重复的类
report
* leak suspects
* top components

##  OOM

### 调试
-XX:ErrorFile=./hs_err_pid<pid>.log：如果JVM crashed，将错误日志输出到指定文件路径。        
-XX:HeapDumpPath=./java_pid<pid>.hprof：堆内存快照的存储文件路径。      
-XX:-HeapDumpOnOutOfMemoryError：在OOM时，输出一个dump.core文件，记录当时的堆内存快照     
-XX:-TraceClassLoading：打印class装载信息到stdout。记Loaded状态。       
-XX:-TraceClassUnloading：打印class的卸载信息到stdout。记Unloaded状态。      
-XX:+PrintGC：输出形式:      
[GC 118250K->113543K(130112K), 0.0094143 secs]   
[Full GC 121376K->10414K(130112K), 0.0650971 secs]   
  
-XX:+PrintGCDetails：输出形式:    
[GC [DefNew: 8614K->781K(9088K), 0.0123035 secs] 118250K->113543K(130112K), 0.0124633 secs]   
[GC [DefNew: 8614K->8614K(9088K), 0.0000665 secs][Tenured: 112761K->10414K(121024K), 0.0433488 secs] 121376K- >10414K(130112K), 0.0436268 secs]     
-XX:+PrintGCTimeStamps：打印GC停顿耗时      
-XX:+PrintGCApplicationStoppedTime：打印垃圾回收期间程序暂停的时间.   
-XX:+PrintHeapAtGC：打印GC前后的详细堆栈信息    
-Xloggc:filename：把相关日志信息记录到文件以便分析.



