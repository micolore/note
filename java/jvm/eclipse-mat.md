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
* shallow 浅
* retained 保留
* list number of instances per class
action
* histogram 直方图
* dominator tree  
* top consumer 消费者
* duplicate class 重复的类
report
* leak suspects
* top components
