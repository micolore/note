# heap

## 堆分析
### 堆直方图
jcmd 19941 GC.class_histogram   
jmap -histo process_id   
jmap -histo:live process_id   

### 堆转储
jcmd process_id GC.heap_dump /path/to/heap_dump.hprof   
jmap -dump:live,file=/path/to/heap_dump.hprof process_id      

1. 了解哪些对象正在消耗内存，是了解要优化代码中哪些对象的第一步。
2. 对于识别由创建了太多某一特定类型对象所引发的内存问题，直方图这
一方法快速且方便。
3. 堆转储分析是追踪内存使用的最强大的技术，不过要利用好，则需要一
些耐心和努力。
### 内存溢出错误
JVM 没有原生内存可用:    
* 永久代（在 Java 7 和更早的版本中）或元空间（在 Java 8 中）内存不足
如果你正在编写的应用会创建并丢弃大量类加载器，一定要非常谨慎，确保类加载器本身能正确丢弃（尤其是，确保没有线程将其上下文加载器设置成
一个临时的类加载器）   
Exception in thread "main" java.lang.OutOfMemoryError: Metaspace    
Exception in thread "main" java.lang.OutOfMemoryError: PermGen space
* Java 堆本身内存不足——对于给定的堆空间而言，应用中活跃对象太多
Exception in thread "main" java.lang.OutOfMemoryError: Java heap space    

* JVM 执行 GC 耗时太多。
Exception in thread "main" java.lang.OutOfMemoryError: GC overhead limit exceeded 执行 GC 上花费了太多时间     
原因：    
1. 花在 Full GC 上的时间超出了 -XX:GCTimeLimit=N 标志指定的值。其默认值是 98（也就
是，如果 98% 的时间花在了 GC 上，则该条件满足）。
2. 一次 Full GC 回收的内存量少于 -XX:GCHeapFreeLimit=N 标志指定的值。其默认值是 2，
这意味着如果 Full GC 期间释放的内存不足堆的 2%，则该条件满足。
3. 上面两个条件连续 5 次 Full GC 都成立（这个数值是无法调整的）。
4. -XX:+UseGCOverhead-Limit 标志的值为 true （默认如此）。

自动堆转储   
-XX:+HeapDumpOnOutOfMemoryError   JVM 会在抛出 OutOfMemoryError 时创建堆转储    
-XX:HeapDumpPath=<path>    指定了堆转储将被写入的位置，默认当前目录下面
-XX:+HeapDumpAfterFullGC   运行一次 Full GC 后生成一个堆转储文件   
-XX:+HeapDumpBeforeFullGC   运行一次 Full GC 之前生成一个堆转储文件

结论:   
1. 有多种原因会导致抛出 OutOfMemoryError，因此不要假设堆空间就是问题所在。
2. 对于永久代和普通的堆，内存泄漏是出现 OutOfMemoryError 的最常见原因；
堆分析工具可以帮助我们找到泄漏的根源

## 减少内存使用
### 减少对象大小
1. 减少实例变量的个数
2. 减少实例变量的大小

Shallow Size、Deep Size 还是 Retained size    
1. 减小对象大小往往可以改进 GC 效率。
2. 对象大小未必总能很明显地看出来：对象会被填充到 8 字节的边界，对
象引用的大小在 32 位和 64 位 JVM 上也有所不同。
3. 对象内部即使为 null 的实例变量也会占用空间   
### 延迟初始化

1. 只有当常用的代码路径不会初始化某个变量时，才去考虑延迟初始化该变量。
2. 一般不会在线程安全的代码上引入延迟初始化，否则会加重现有的同步成本。
3. 对于使用了线程安全对象的代码，如果要采用延迟初始化，应该使用双重检查锁。

### 不可变对象和标准化对象
### 字符串的保留  
-XX:StringTableSize=N    
1. 如果应用中有大量字符串是一样的，那通过保留实现字符串重用收效很大。
2. 要保留很多字符串的应用可能需要调整字符串保留表的大小（除非是运行在 Java 7u40 及更新的 64 位服务器 JVM 上）

## 对象生命周期管理
### 对象重用
1. 线程池
2. 线程局部变量
1. 对象重用通常是一种通用操作，我们并不鼓励使用它。但是这种技术可能适合初始化成本高昂，而且数量比较少的一组对象。
2. 在使用对象池还是使用线程局部变量这两种技术之间，应该有所取舍。一般而言，建设线程和可重用对象直接存在一一对应关系，则线程局部
变量更容易使用
### 弱引用、软引用与其他引用
1. 非确定引用（包括软引用、弱引用、虚引用和最终引用）会改变 Java 对象正常的生命周期，与池或线程局部变量相比，它可以以对 GC 更为友
好的方式实现对象重用。
2. 当应用对某个对象感兴趣，而且该对象在应用中的其他地方有强引用时，才应该使用弱引用。
3. 软引用保存可能长期存在的对象，提供了一个简单的、对 GC 友好的LRU 缓存。
4. 非确定引用自身会消耗内存，而且会长时间抓住其他对象的内存；应该谨慎使用。
