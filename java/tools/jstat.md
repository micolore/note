# Jstat

jstat工具特别强大，有众多的可选项，详细查看堆内各个部分的使用量，以及加载类的数量。使用时，需加上查看进程的进程id，和所选参数。

执行：cd $JAVA_HOME/bin中执行jstat，注意jstat后一定要跟参数。    

### 各个参数的意义。      
* jstat -class pid:显示加载class的数量，及所占空间等信息。 
* stat -compiler pid:显示VM实时编译的数量等信息。 
* jstat -gc pid:可以显示gc的信息，查看gc的次数，及时间。其中最后五项，分别是young gc的次数，young gc的时间，full gc的次数，full gc的时间，gc的总时间。 
* jstat -gccapacity:可以显示，VM内存中三代（young,old,perm）对象的使用和占用大小，如：PGCMN显示的是最小perm的内存使用量，PGCMX显示的是perm的内存最大使用量，PGC是当前新生成的perm内存占用量，PC是但前perm内存占用量。其他的可以根据这个类推， OC是old内纯的占用量。 
* jstat -gcnew pid:new对象的信息。 
* jstat -gcnewcapacity pid:new对象的信息及其占用量。 
* jstat -gcold pid:old对象的信息。 
* jstat -gcoldcapacity pid:old对象的信息及其占用量。 
* jstat -gcpermcapacity pid: perm对象的信息及其占用量。 
* jstat -util pid:统计gc信息统计。 
* jstat -printcompilation pid:当前VM执行的信息。   

除了以上一个参数外，还可以同时加上 两个数字，如：jstat -printcompilation 3024 250 6是每250毫秒打印一次，一共打印6次，还可以加上-h3每三行显示一下标题。    

### 语法结构：  
Usage: jstat -help|-options       
       jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]       
#### 参数解释：   
Options — 选项，我们一般使用 -gcutil 查看gc情况比较多   
vmid    — VM的进程号，即当前运行的java进程号   
interval– 间隔时间，单位为秒或者毫秒   
count   — 打印次数，如果缺省则打印无数次   
S0  — Heap上的 Survivor space 0 区已使用空间的百分比 
S1  — Heap上的 Survivor space 1 区已使用空间的百分比 
E   — Heap上的 Eden space 区已使用空间的百分比 
O   — Heap上的 Old space 区已使用空间的百分比 
P   — Perm space 区已使用空间的百分比 
YGC — 从应用程序启动到采样时发生 Young GC 的次数 
YGCT– 从应用程序启动到采样时 Young GC 所用的时间(单位秒) 
FGC — 从应用程序启动到采样时发生 Full GC 的次数 
FGCT– 从应用程序启动到采样时 Full GC 所用的时间(单位秒) 
GCT — 从应用程序启动到采样时用于垃圾回收的总时间(单位秒)
如：[root@localhost bin]# jstat -gcutil 25332  1000  10     （25332是java的进程号，ps -ef | grep java）

### 分代概念：

分代是Java垃圾收集的一大亮点，根据对象的生命周期长短，把堆分为3个代：   
Young，Old和Permanent，根据不同代的特点采用不同的收集算法，扬长避短也。

#### Young(Nursery)，年轻代。研究表明大部分对象都是朝生暮死，随生随灭的。因此所有收集器都为年轻代选择了复制算法。

复制算法优点是只访问活跃对象，缺点是复制成本高。因为年轻代只有少量的对象能熬到垃圾收集，因此只需少量的复制成本。而且复制收集器只访问活跃对象，对那些占了最大比率的死对象视而不见，充分发挥了它遍历空间成本低的优点。

#### Young（年轻代）

年 轻代分三个区。一个Eden区，两个Survivor区。大部分对象在Eden区中生成。当Eden区满时，还存活的对象将被复制到Survivor区 （两个中的一个），当这个Survivor区满时，此区的存活对象将被复制到另外一个Survivor区，当这个Survivor去也满了的时候，从第一 个Survivor区复制过来的并且此时还存活的对象，将被复制“年老区(Tenured)”。需要注意，Survivor的两个区是对称的，没先后关 系，所以同一个区中可能同时存在从Eden复制过来 对象，和从前一个Survivor复制过来的对象，而复制到年老区的只有从第一个Survivor去过来的对象。而且，Survivor区总有一个是空 的。

#### Tenured（年老代）

年老代存放从年轻代存活的对象。一般来说年老代存放的都是生命期较长的对象。

#### Perm（持久代）

用 于存放静态文件，如今Java类、方法等。持久代对垃圾回收没有显著影响，但是有些应用可能动态生成或者调用一些class，例如Hibernate等， 在这种时候需要设置一个比较大的持久代空间来存放这些运行过程中新增的类。持久代大小通过-XX:MaxPermSize=进行设置。

## Gc的基本概念

gc分为full gc 跟 minor gc，当每一块区满的时候都会引发gc。

### Scavenge GC

一般情况下，当新对象生成，并且在Eden申请空间失败时，就触发了Scavenge GC，堆Eden区域进行GC，清除非存活对象，并且把尚且存活的对象移动到Survivor区。然后整理Survivor的两个区。

### Full GC

对整个堆进行整理，包括Young、Tenured和Perm。Full GC比Scavenge GC要慢，因此应该尽可能减少Full GC。有如下原因可能导致Full GC：

1. Tenured被写满

2. Perm域被写满

3. System.gc()被显示调用

4. 上一次GC之后Heap的各域分配策略动态变化

## 结果参数值解析
* S0C：年轻代中第一个survivor（幸存区）的容量 (字节)         
* S1C：年轻代中第二个survivor（幸存区）的容量 (字节)         
* S0U：年轻代中第一个survivor（幸存区）目前已使用空间 (字节)        
* S1U：年轻代中第二个survivor（幸存区）目前已使用空间 (字节)         
* EC：年轻代中Eden（伊甸园）的容量 (字节)         
* EU：年轻代中Eden（伊甸园）目前已使用空间 (字节)         
* OC：Old代的容量 (字节)         
* OU：Old代目前已使用空间 (字节)         
* PC：Perm(持久代)的容量 (字节)         
* PU：Perm(持久代)目前已使用空间 (字节)         
* YGC：从应用程序启动到采样时年轻代中gc次数         
* YGCT：从应用程序启动到采样时年轻代中gc所用时间(s)         
* FGC：从应用程序启动到采样时old代(全gc)gc次数         
* FGCT：从应用程序启动到采样时old代(全gc)gc所用时间(s)         
* GCT：从应用程序启动到采样时gc用的总时间(s)         
* NGCMN：年轻代(young)中初始化(最小)的大小 (字节)         
* NGCMX：年轻代(young)的最大容量 (字节)         
* NGC：年轻代(young)中当前的容量 (字节)         
* OGCMN：old代中初始化(最小)的大小 (字节)         
* OGCMX：old代的最大容量 (字节)         
* OGC：old代当前新生成的容量 (字节)         
* PGCMN：perm代中初始化(最小)的大小 (字节)         
* PGCMX：perm代的最大容量 (字节)           
* PGC：perm代当前新生成的容量 (字节)         
* S0：年轻代中第一个survivor（幸存区）已使用的占当前容量百分比         
* S1：年轻代中第二个survivor（幸存区）已使用的占当前容量百分比         
* E：年轻代中Eden（伊甸园）已使用的占当前容量百分比         
* O：old代已使用的占当前容量百分比         
* P：perm代已使用的占当前容量百分比         
* S0CMX：年轻代中第一个survivor（幸存区）的最大容量 (字节)         
* S1CMX ：年轻代中第二个survivor（幸存区）的最大容量 (字节)         
* ECMX：年轻代中Eden（伊甸园）的最大容量 (字节)         
* DSS：当前需要survivor（幸存区）的容量 (字节)（Eden区已满）         
* TT： 持有次数限制         
* MTT ： 最大持有次数限制



