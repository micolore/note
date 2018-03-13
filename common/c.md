# c

### 语法

## hello world

```
#include <stdio.h>
 
int main()
{
    /* 我的第一个 C 程序 */
    printf("Hello, World! \n");
 
    return 0;
}

```
###  编译 & 执行 C 程序

打开一个文本编辑器，添加上述代码。  
保存文件为 hello.c。    
打开命令提示符，进入到保存文件所在的目录。   
键入 gcc hello.c，输入回车，编译代码。   
如果代码中没有错误，命令提示符会跳到下一行，并生成 a.out 可执行文件。   
现在，键入 a.out 来执行程序。   
您可以看到屏幕上显示 "Hello World"。   

```
$ gcc hello.c
$ ./a.out
Hello, World!

```


### 注释

/* 我的第一个 C 程序 */

### 分号

分号 ; 

### 标识符

### 关键字

auto	else	long	switch   
break	enum	register	typedef   
case	extern	return	union   
char	float	short	unsigned   
const	for	signed	void   
continue	goto	sizeof	volatile    
default	if	static	while    
do	int	struct	_Packed   
double   

### 空格
```
int age;

fruit = apples + oranges;   // 获取水果的总数
```

## 数据类型 
基本类型：   
它们是算术类型，包括两种类型：整数类型和浮点类型   
枚举类型：  
它们也是算术类型，被用来定义在程序中只能赋予其一定的离散整数值的变量。  
void 类型：
类型说明符 void 表明没有可用的值。   
派生类型：   
它们包括：指针类型、数组类型、结构类型、共用体类型和函数类型。      

数组类型和结构类型统称为聚合类型。函数的类型指的是函数返回值的类型。    

char	1 字节	-128 到 127 或 0 到 255   
unsigned char	1 字节	0 到 255   
signed char	1 字节	-128 到 127   
int	2 或 4 字节	-32,768 到 32,767 或 -2,147,483,648 到 2,147,483,647   
unsigned int	2 或 4 字节	0 到 65,535 或 0 到 4,294,967,295   
short	2 字节	-32,768 到 32,767   
unsigned short	2 字节	0 到 65,535   
long	4 字节	-2,147,483,648 到 2,147,483,647   
unsigned long	4 字节	0 到 4,294,967,295    

### void 类型

函数返回为空    
C 中有各种函数都不返回值，或者您可以说它们返回空。不返回值的函数的返回类型为空。例如 void exit (int status);   
函数参数为空   
C 中有各种函数不接受任何参数。不带参数的函数可以接受一个 void。例如 int rand(void);   
指针指向 void        
类型为 void * 的指针代表对象的地址，而不是类型。例如，内存分配函数 void *malloc( size_t size ); 返回指向 void 的指针，可以转换为任何数据类型。


