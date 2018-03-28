# 看了很多知识点就是在需要的时候不知道从什么地方下手

##  开始
为什么要看jvm？应该研究到什么程度才能算是了解了jvm？
学习jvm的步骤？

### jvm 的结构 
程序运行之后具体的每个步骤都做了什么事情,会有哪些风险出现？怎么观察具体的信息来验证我们的判断？   
比如字符串存到哪里？数组集合又存到什么地方？
![jvm](https://github.com/micolore/blogs/blob/master/java/img/jvm/jvm-1.jpg)    

[//]：(https://github.com/micolore/blogs/blob/master/java/img/jvm/jvm-2.png)

## jvm基本特征
* 基于栈的体系结构
 求值栈(操作数栈、表达式栈)与调用栈
* 动态加载程序
* 安全性
* 自动内存管理
* 多线程支持
* 与本地库的交互





## 部分常用查看命令

java -client -XX:+PrintFlagsFinal Benchmark  一个按字母排序的590个参数表格    

java -server -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+PrintFlagsFinal Benchmark  724     

java -server -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+PrintFlagsFinal Benchmark | grep ":"       

java -server -XX:+PrintCommandLineFlags Benchmark    
