# log4j

## history

## development 

## structure

### Logger
公共类Logger， 负责处理日志记录的大部分操作  
ALL    	打开所有日志   
DEBUG    	细粒度信息事件，对调试应用程序是非常有帮助的      
INFO    	粗粒度信息事件，突出强调应用程序的运行过程       
WARN    	可能出现潜在错误的情形      
ERROR    	虽然发生错误事件，但仍然不影响系统的继续运行      
FATAL    	指出每个严重的错误事件将会导致应用程序的退出    
OFF    	关闭所有日志    

### Appender   
公共接口Appender，负责控制日志记录操作的输出       
ConsoleAppender	使用用户指定的布局(layout)输出日志事件到System.out或者 System.err。默认的目标是System.out   
FileAppender	把日志事件写入一个文件   
DailyRollingFileAppender	扩展FileAppender，因此多个日志文件可以以一个用户选定的频率进行循环日志记录   
RollingFileAppender	扩展FileAppender，备份容量达到一定大小的日志文件   
WriterAppender	根据用户的选择把日志事件写入到Writer或者OutputStream   
SMTPAppender	当特定的日志事件发生时，一般是指发生错误或者重大错误时，发送一封邮件   
SocketAppender	给远程日志服务器（通常是网络套接字节点）发送日志事件（LoggingEvent）对象  
SocketHubAppender	给远程日志服务器群组（通常是网络套接字节点）发送日志事件（LoggingEvent）对象   
SyslogAppender	给远程异步日志记录的后台精灵程序(daemon)发送消息   
TelnetAppender	一个专用于向只读网络套接字发送消息的log4j appender   

### Layout
公共抽象类，负责格式化Appender的输出  
HTMLLayout	格式化日志输出为HTML表格   
PatternLayout	根据指定的转换模式格式化日志输出，或者如果没有指定任何转换模式，就使用默认的转换模式  
SimpleLayout	以一种非常简单的方式格式化日志输出，它打印级别 Level，然后跟着一个破折号“-“ ，最后才是日志消息    

## Features
  logback 、log4j2

###   PatternLayout-ConversionPattern
* %m   输出代码中指定的消息
* %p   输出优先级，即DEBUG，INFO，WARN，ERROR，FATAL
* %r   输出自应用启动到输出该log信息耗费的毫秒数
* %c   输出所属的类目，通常就是所在类的全名
* %t   输出产生该日志事件的线程名
* %n   输出一个回车换行符，Windows平台为“/r/n”，Unix平台为“/n”
* %d   输出日志时间点的日期或时间。默认格式为ISO8601，也可以在其后指定格式。比如：%d{yyy MMM dd HH:mm:ss , SSS}，输出类似：2002年10月18日 22:10:28, 921
* %l   输出日志事件的发生位置，包括类目名、发生的线程，以及在代码中的行数
