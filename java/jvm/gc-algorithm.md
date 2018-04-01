# 垃圾收集算法

## 理解 throughput收集器
基本操作：   
1. 回收新生代的垃圾
 一般在eden区空间快用尽时，把eden空间所有对象移走，一部分对象会移动到survivor空间 其他会被移动到老年代
 Minor GC
 ```
 17.806: [GC [PSYoungGen: 227983K->14463K(264128K)] 280122K->66610K(613696K), 0.0169320 secs]
[Times: user=0.05 sys=0.00, real=0.02 secs]
 ```
 
2. 回收老年代的垃圾
Full GC
```
64.546: [Full GC [PSYoungGen: 15808K->0K(339456K)]
[ParOldGen: 457753K->392528K(554432K)] 473561K->392528K(893888K)
[PSPermGen: 56728K->56728K(115392K)], 1.3367080 secs]
[Times: user=4.44 sys=0.01, real=1.34 secs]
```
结论:   
1. throughput 收集器 会进行两种操作 分别是Minor Gc 和 Full Gc
2. 通过 GC日志中的时间输出，我们可以判断throughput收集器的gc操作对应用程序总体性能的影响

### 堆大小的自适应调整和景泰调整
Throughput 收集器的调优总是围绕着停顿时间进行的，寻求堆的总体大小，新生代的大小以及老年代的大小之间平衡
两种取舍:    
1. 时间与空间的取舍
2. 取舍与完成垃圾回收所需的时长相关    
采用动态调整是进行堆调优极好的入手点    
静态地设置堆的大小也可能获得最优的性能    


## 理解cms收集器
基本操作:    
1. cms收集器会对新生代的对象进行回收 所有的应用线程暂停
2. cms收集器会启动一个并发的线程对老年代空间的垃圾进行回收
3. 如果有必要，cms会引发full gc    

结论:   
1. cms垃圾回收有多个回收操作，但是期望的操作是Minor GC和并发回收
2. cms收集过程中的并发模式失效以及晋升失败的代价非常昂贵，我们尽量调优cms收集器以避免这种情况
3. 默认情况下cms收集器不会对永久代进行垃圾回收

### 针对并发模式失效的调优
避免cms收集器并发模式失效的方法   
1. 想办法增大老年代空间，要么只移动部分的新生代对象到老年代，要么增加更多的堆空间
2. 以更高的频率运行后台回收线程
3. 使用更多的后台回收线程
-XX:CMSInitiatingOccupancyFraction=N 和 -XX:+UseCMSInitiatingOccupancyOnly  更早的启动并发收集周期
-XX:ConcGCThreads=N 调整cms后台线程

### cms收集器的永久代调优
-XX:+CMSPermGenSweepingEnabled      永久代中的垃圾使用与老年代同样的方式进行垃圾收集
-XX:CMSInitiatingPermOccupancyFraction=N     指定 CMS 收集器在永久代空间占用比达到设定值时启动永久代垃圾回收线程    

-XX:+CMSClassUnloadingEnabled   
-XX:CMSIncrementalSafetyFactor=N
-XX:CMSIncrementalDutyCycleMin=N 和 -XX:CMSIncrementalPacing
-XX:+CMSIncrementalMode 
 可以控制垃圾收集后台线程为应用程序线程让出多少 CPU 周期
 
增量式 CMS 垃圾收集依据责任周期（duty cycle）原则进行工作     
责任周期的时间长度是以新生代相邻两次垃圾收集之间的时间长度计算得出的  
-CMSIncrementalDutyCycleMin 受jvm自动调整影响，可以使用CMSIncrementalDutyCycle 关闭自动调节
### 增量式cms收集器

## 理解g1收集器
工作在堆内不同分区(region)的收集器,又为首先收集垃圾最多的分区    

为老年代设计分区的初衷是我们发现并发后台线程在回收老年代中，没有引用的对象时，有的分区垃圾对象的数量很多，另一些分区的垃圾对象相对较少。虽然分区的垃圾收集工作实际仍然会暂停应用程序线程，不过由于 G1 收集器专注于垃圾最多的分区，最终的效果是花费较少的时间就能回收这些分区的垃圾    

基本操作:   
1. 新生代垃圾收集
2. 后台收集 并发周期
3. 混合式垃圾收集
4. 以及必要的full gc

结论:   
1. g1 垃圾收集包含多个周期 ，调优良好的jvm运行g1收集器时应该只经历 新生代周期、混合式周期、并发gc周期
2. g1 的并发阶段会产生少量的停顿
3. 恰当的时候，对g1进行调优，才能避免full gc周期发生

### g1垃圾收集器调优
主要目标就是避免发生并发模式失败或者疏散失败    
* 通过增加总的堆空间大小或者调整老年代、新生代之间的比例来增加老年代空间的
大小。
*  增加后台线程的数目（假设我们有足够的 CPU 资源运行这些线程）。
*  以更高的频率进行 G1 的后台垃圾收集活动。
*  在混合式垃圾回收周期中完成更多的垃圾收集工作。
 -XX:MaxGCPauseMillis=N   200ms
## 高级调优
### 晋升及survivor空间
1. 设计 Survivor 空间的初衷是为了让对象（尤其是已经分配的对象）在新生代停留更多的 GC 周期。这个设计增大了对象晋升到老年代之前被回
收释放的几率。
2. 如果 Survivor 空间过小，对象会直接晋升到老年代，从而触发更多的老年代 GC。
3. 解决这个问题的最好方法是增大堆的大小（或者至少增大新生代），让JVM 来处理 Survivor 空间的回收。
4. 有的情况下，我们需要避免对象晋升到老年代，调整晋升阈值或者Survivor 空间的大小可以避免对象晋升到老年代
### 分配大对象
Thread Local Allocation Buffer，TLAB   线程本地分配缓冲区
 -XX:+PrintTLAB    
 ```
TLAB: gc thread: 0x00007f3c10b8f800 [id: 18519] desired_size: 221KB
slow allocs: 8 refill waste: 3536B alloc: 0.01613 11058KB
refills: 73 waste 0.1% gc: 10368B slow: 2112B fast: 0B
 ```
### aggressiveheap标志
1. AggressiveHeap 是个历史悠久的调优标志，设计初衷是为了在强大的机
器上运行单一 JVM 时调整堆的各种参数。
2. 这个标志设定的值并没有随着 JVM 技术的发展同步调整，因此它的有
效性从长远来看是值得质疑的（虽然到目前为止，这个标志还常常被
使用）
### 全盘掌握堆空间的大小
1. 大多数的机器上堆的初始空间和最大空间的默认值计算是比较直观的。
2. 达到堆大小的临界情况时，需要考虑的因素更多，计算也更加复杂。
