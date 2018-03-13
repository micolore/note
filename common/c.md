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

## 变量

声明  
1、一种是需要建立存储空间的。例如：int a 在声明的时候就已经建立了存储空间。   
2、另一种是不需要建立存储空间的，通过使用extern关键字声明变量名而不定义它。 例如：extern int a 其中变量 a 可以在别的文件中定义的。
除非有extern关键字，否则都是变量的定义。    
左值和右值   
左值（lvalue）：指向内存位置的表达式被称为左值（lvalue）表达式。左值可以出现在赋值号的左边或右边。    
右值（rvalue）：术语右值（rvalue）指的是存储在内存中某些地址的数值。右值是不能对其进行赋值的表达式，也就是说，右值可以出现在赋值号的右边，但不能出现在赋值号的左边。    

### 常量
定义    
使用 #define 预处理器。      
使用 const 关键字。  
```
#include <stdio.h>
 
#define LENGTH 10   
#define WIDTH  5
#define NEWLINE '\n'
 
int main()
{
 
   int area;  
  
   area = LENGTH * WIDTH;
   printf("value of area : %d", area);
   printf("%c", NEWLINE);
 
   return 0;
   
}
//  const
const type variable = value;

```
### 存储类

auto    
  auto 只能修饰局部变量。      
register    
存储类用于定义存储在寄存器中而不是 RAM 中的局部变量。这意味着变量的最大尺寸等于寄存器的大小（通常是一个词），且不能对它应用一元的 '&' 运算符（因为它没有内存位置）   
```
{
   register int  miles;
}
```
static     
存储类指示编译器在程序的生命周期内保持局部变量的存在，而不需要在每次它进入和离开作用域时进行创建和销毁。因此，使用 static 修饰局部变量可以在函数调用之间保持局部变量的值     
```
static int Count;
int Road;

main()
{
    printf("%d\n", Count);
    printf("%d\n", Road);
 }
```
extern     
存储类用于提供一个全局变量的引用，全局变量对所有的程序文件都是可见的。当您使用 'extern' 时，对于无法初始化的变量，会把变量名指向一个之前定义过的存储位置。      
```
#include <stdio.h>
 
int count ;
extern void write_extern();
 
int main()
{
   count = 5;
   write_extern();
}


#include <stdio.h>
 
extern int count;
 
void write_extern(void)
{
   printf("count is %d\n", count);
}


```

## 运算符
 
算术运算符  
关系运算符  
逻辑运算符  
位运算符   
赋值运算符   
杂项运算符   

## 判断 

## 循环

## 函数
```
return_type function_name( parameter list )
{
   body of the function
}
声明
return_type function_name( parameter list );

int max(int num1, int num2);

int max(int, int);
```
函数调用
```
#include <stdio.h>
 
/* 函数声明 */
int max(int num1, int num2);
 
int main ()
{
   /* 局部变量定义 */
   int a = 100;
   int b = 200;
   int ret;
 
   /* 调用函数来获取最大值 */
   ret = max(a, b);
 
   printf( "Max value is : %d\n", ret );
 
   return 0;
}
 
/* 函数返回两个数中较大的那个数 */
int max(int num1, int num2) 
{
   /* 局部变量声明 */
   int result;
 
   if (num1 > num2)
      result = num1;
   else
      result = num2;
 
   return result; 
}
```
 
传值调用	该方法把参数的实际值复制给函数的形式参数。在这种情况下，修改函数内的形式参数不会影响实际参数。   
引用调用	通过指针传递方式，形参为指向实参地址的指针，当对形参的指向操作时，就相当于对实参本身进行的操作。    
c 默认值传递不是引用传递，这意味着函数内的代码不能改变用于调用函数的实际参数。

## c 作用域

在函数或块内部的局部变量   
在所有函数外部的全局变量   
在形式参数的函数参数定义中    

### 初始化局部变量和全局变量
当局部变量被定义时，系统不会对其初始化，您必须自行对其初始化。定义全局变量时，系统会自动对其初始化    

## 数组

多维数组	C 支持多维数组。多维数组最简单的形式是二维数组。   
传递数组给函数	您可以通过指定不带索引的数组名称来给函数传递一个指向数组的指针。   
从函数返回数组	C 允许从函数返回数组。    
指向数组的指针	您可以通过指定不带索引的数组名称来生成一个指向数组中第一个元素的指针。    


## 指针

```
#include <stdio.h>
 
int main ()
{
   int  var1;
   char var2[10];
 
   printf("var1 变量的地址： %p\n", &var1  );
   printf("var2 变量的地址： %p\n", &var2  );
 
   return 0;
}
```

指针是一个变量，其值为另一个变量的地址，即，内存位置的直接地址     

```
type *var-name;  

int    *ip;    /* 一个整型的指针 */
double *dp;    /* 一个 double 型的指针 */
float  *fp;    /* 一个浮点型的指针 */
char   *ch;     /* 一个字符型的指针 */

```

操作     
定义一个指针变量、把变量地址赋值给指针、访问指针变量中可用地址的值   

```
#include <stdio.h>
 
int main ()
{
   int  var = 20;   /* 实际变量的声明 */
   int  *ip;        /* 指针变量的声明 */
 
   ip = &var;  /* 在指针变量中存储 var 的地址 */
 
   printf("Address of var variable: %p\n", &var  );
 
   /* 在指针变量中存储的地址 */
   printf("Address stored in ip variable: %p\n", ip );
 
   /* 使用指针访问值 */
   printf("Value of *ip variable: %d\n", *ip );
 
   return 0;
}
```
指针的算术运算	可以对指针进行四种算术运算：++、--、+、-    
指针数组	可以定义用来存储指针的数组。   
指向指针的指针	C 允许指向指针的指针。    
传递指针给函数	通过引用或地址传递参数，使传递的参数在调用函数中被改变。   
从函数返回指针	C 允许函数返回指针到局部变量、静态变量和动态内存分配。     

###  函数指针
```
typedef int (*fun_ptr)(int,int); // 声明一个指向同样参数、返回值的函数指针类型
```

### 回调函数  

```
#include <stdlib.h>  
#include <stdio.h>
 
// 回调函数
void populate_array(int *array, size_t arraySize, int (*getNextValue)(void))
{
    for (size_t i=0; i<arraySize; i++)
        array[i] = getNextValue();
}
 
// 获取随机值
int getNextRandomValue(void)
{
    return rand();
}
 
int main(void)
{
    int myarray[10];
    populate_array(myarray, 10, getNextRandomValue);
    for(int i = 0; i < 10; i++) {
        printf("%d ", myarray[i]);
    }
    printf("\n");
    return 0;
}
```

## 字符串
```
#include <stdio.h>

int main ()
{
   char greeting[6] = {'H', 'e', 'l', 'l', 'o', '\0'};

   printf("Greeting message: %s\n", greeting );

   return 0;
}
```

## 结构体

```
struct [structure tag]
{
   member definition;
   member definition;
   ...
   member definition;
} [one or more structure variables];

struct Books
{
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
} book;

```

```
#include <stdio.h>
#include <string.h>
 
struct Books
{
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
};
 
/* 函数声明 */
void printBook( struct Books book );
int main( )
{
   struct Books Book1;        /* 声明 Book1，类型为 Books */
   struct Books Book2;        /* 声明 Book2，类型为 Books */
 
   /* Book1 详述 */
   strcpy( Book1.title, "C Programming");
   strcpy( Book1.author, "Nuha Ali"); 
   strcpy( Book1.subject, "C Programming Tutorial");
   Book1.book_id = 6495407;
 
   /* Book2 详述 */
   strcpy( Book2.title, "Telecom Billing");
   strcpy( Book2.author, "Zara Ali");
   strcpy( Book2.subject, "Telecom Billing Tutorial");
   Book2.book_id = 6495700;
 
   /* 输出 Book1 信息 */
   printBook( Book1 );
 
   /* 输出 Book2 信息 */
   printBook( Book2 );
 
   return 0;
}
void printBook( struct Books book )
{
   printf( "Book title : %s\n", book.title);
   printf( "Book author : %s\n", book.author);
   printf( "Book subject : %s\n", book.subject);
   printf( "Book book_id : %d\n", book.book_id);
}

```
指向结构的指针
```
struct Books *struct_pointer;

struct_pointer = &Book1;
//访问成员
struct_pointer->title;
```

```
#include <stdio.h>
#include <string.h>
 
struct Books
{
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
};
 
/* 函数声明 */
void printBook( struct Books *book );
int main( )
{
   struct Books Book1;        /* 声明 Book1，类型为 Books */
   struct Books Book2;        /* 声明 Book2，类型为 Books */
 
   /* Book1 详述 */
   strcpy( Book1.title, "C Programming");
   strcpy( Book1.author, "Nuha Ali"); 
   strcpy( Book1.subject, "C Programming Tutorial");
   Book1.book_id = 6495407;
 
   /* Book2 详述 */
   strcpy( Book2.title, "Telecom Billing");
   strcpy( Book2.author, "Zara Ali");
   strcpy( Book2.subject, "Telecom Billing Tutorial");
   Book2.book_id = 6495700;
 
   /* 通过传 Book1 的地址来输出 Book1 信息 */
   printBook( &Book1 );
 
   /* 通过传 Book2 的地址来输出 Book2 信息 */
   printBook( &Book2 );
 
   return 0;
}
void printBook( struct Books *book )
{
   printf( "Book title : %s\n", book->title);
   printf( "Book author : %s\n", book->author);
   printf( "Book subject : %s\n", book->subject);
   printf( "Book book_id : %d\n", book->book_id);
}
```

###  位域

```
struct 位域结构名 
{

 位域列表

};

struct bs{
    int a:8;
    int b:2;
    int c:6;
}data;

位域变量名.位域名  
位域变量名->位域名  

```

```
main(){
    struct bs{
        unsigned a:1;
        unsigned b:3;
        unsigned c:4;
    } bit,*pbit;
    bit.a=1;    /* 给位域赋值（应注意赋值不能超过该位域的允许范围） */
    bit.b=7;    /* 给位域赋值（应注意赋值不能超过该位域的允许范围） */
    bit.c=15;    /* 给位域赋值（应注意赋值不能超过该位域的允许范围） */
    printf("%d,%d,%d\n",bit.a,bit.b,bit.c);    /* 以整型量格式输出三个域的内容 */
    pbit=&bit;    /* 把位域变量 bit 的地址送给指针变量 pbit */
    pbit->a=0;    /* 用指针方式给位域 a 重新赋值，赋为 0 */
    pbit->b&=3;    /* 使用了复合的位运算符 "&="，相当于：pbit->b=pbit->b&3，位域 b 中原有值为 7，与 3 作按位与运算的结果为 3（111&011=011，十进制值为 3） */
    pbit->c|=1;    /* 使用了复合位运算符"|="，相当于：pbit->c=pbit->c|1，其结果为 15 */
    printf("%d,%d,%d\n",pbit->a,pbit->b,pbit->c);    /* 用指针方式输出了这三个域的值 */
}

```

## 共用体
共用体是一种特殊的数据类型，允许您在相同的内存位置存储不同的数据类型  
```
union [union tag]
{
   member definition;
   member definition;
   ...
   member definition;
} [one or more union variables];

union Data
{
   int i;
   float f;
   char  str[20];
} data;

```

```
#include <stdio.h>
#include <string.h>
 
union Data
{
   int i;
   float f;
   char  str[20];
};
 
int main( )
{
   union Data data;        
 
   printf( "Memory size occupied by data : %d\n", sizeof(data));
 
   return 0;
}

```
访问  
```
#include <stdio.h>
#include <string.h>
 
union Data
{
   int i;
   float f;
   char  str[20];
};
 
int main( )
{
   union Data data;        
 
   data.i = 10;
   data.f = 220.5;
   strcpy( data.str, "C Programming");
 
   printf( "data.i : %d\n", data.i);
   printf( "data.f : %f\n", data.f);
   printf( "data.str : %s\n", data.str);
 
   return 0;
}
```
## 位域

```
struct
{
  unsigned int widthValidated;
  unsigned int heightValidated;
} status;

struct
{
  unsigned int widthValidated : 1;
  unsigned int heightValidated : 1;
} status;
```
```
#include <stdio.h>
#include <string.h>

/* 定义简单的结构 */
struct
{
  unsigned int widthValidated;
  unsigned int heightValidated;
} status1;

/* 定义位域结构 */
struct
{
  unsigned int widthValidated : 1;
  unsigned int heightValidated : 1;
} status2;
 
int main( )
{
   printf( "Memory size occupied by status1 : %d\n", sizeof(status1));
   printf( "Memory size occupied by status2 : %d\n", sizeof(status2));

   return 0;
}
```
结构内位域声明
```
struct
{
  type [member_name] : width ;
};

struct
{
  unsigned int age : 3;
} Age;

```
##  typedef

```
typedef unsigned char BYTE;

#include <stdio.h>
#include <string.h>
 
typedef struct Books
{
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
} Book;
 
int main( )
{
   Book book;
 
   strcpy( book.title, "C 教程");
   strcpy( book.author, "Runoob"); 
   strcpy( book.subject, "编程语言");
   book.book_id = 12345;
 
   printf( "书标题 : %s\n", book.title);
   printf( "书作者 : %s\n", book.author);
   printf( "书类目 : %s\n", book.subject);
   printf( "书 ID : %d\n", book.book_id);
 
   return 0;
}
```
typedef vs #define     
#define 是 C 指令，用于为各种数据类型定义别名，与 typedef 类似，但是它们有以下几点不同：    

typedef 仅限于为类型定义符号名称，#define 不仅可以为类型定义别名，也能为数值定义别名，比如您可以定义 1 为 ONE。    
typedef 是由编译器执行解释的，#define 语句是由预编译器进行处理的。   

```
#include <stdio.h>
 
#define TRUE  1
#define FALSE 0
 
int main( )
{
   printf( "TRUE 的值: %d\n", TRUE);
   printf( "FALSE 的值: %d\n", FALSE);
 
   return 0;
}
````
## 预处理器 
C 预处理器（C Preprocessor）简写为 CPP  
#define	定义宏   
#include	包含一个源代码文件   
#undef	取消已定义的宏   
#ifdef	如果宏已经定义，则返回真   
#ifndef	如果宏没有定义，则返回真   
#if	如果给定条件为真，则编译下面代码   
#else	#if 的替代方案   
#elif	如果前面的 #if 给定条件不为真，当前条件为真，则编译下面代码   
#endif	结束一个 #if……#else 条件编译块   
#error	当遇到标准错误时，输出错误消息  
#pragma	使用标准化方法，向编译器发布特殊的命令到编译器中   



## 头文件  
头文件是扩展名为 .h 的文件，包含了 C 函数声明和宏定义，被多个源文件中引用共享。有两种类型的头文件：程序员编写的头文件和编译器自带的头文件。   
```
#include <file>

#include "file"

//有条件引用
#if SYSTEM_1
   # include "system_1.h"
#elif SYSTEM_2
   # include "system_2.h"
#elif SYSTEM_3
   ...
#endif
```
##  强制类型转换

```
#include <stdio.h>

main()
{
   int sum = 17, count = 5;
   double mean;

   mean = (double) sum / count;
   printf("Value of mean : %f\n", mean );

}
```

## 错误处理
C 语言提供了 perror() 和 strerror() 函数来显示与 errno 相关的文本消息。  

perror() 函数显示您传给它的字符串，后跟一个冒号、一个空格和当前 errno 值的文本表示形式。   
strerror() 函数，返回一个指针，指针指向当前 errno 值的文本表示形式    

```
#include <stdio.h>
#include <errno.h>
#include <string.h>

extern int errno ;

int main ()
{
   FILE * pf;
   int errnum;
   pf = fopen ("unexist.txt", "rb");
   if (pf == NULL)
   {
      errnum = errno;
      fprintf(stderr, "错误号: %d\n", errno);
      perror("通过 perror 输出错误");
      fprintf(stderr, "打开文件错误: %s\n", strerror( errnum ));
   }
   else
   {
      fclose (pf);
   }
   return 0;
}
```
## 递归

## 可变参数
```
#include <stdio.h>
#include <stdarg.h>

double average(int num,...)
{

    va_list valist;
    double sum = 0.0;
    int i;

    /* 为 num 个参数初始化 valist */
    va_start(valist, num);

    /* 访问所有赋给 valist 的参数 */
    for (i = 0; i < num; i++)
    {
       sum += va_arg(valist, int);
    }
    /* 清理为 valist 保留的内存 */
    va_end(valist);

    return sum/num;
}

int main()
{
   printf("Average of 2, 3, 4, 5 = %f\n", average(4, 2,3,4,5));
   printf("Average of 5, 10, 15 = %f\n", average(3, 5,10,15));
}
```

## 内存管理
```
void *calloc(int num, int size);

void free(void *address);   

void *malloc(int num); 

void *realloc(void *address, int newsize); 
```

```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
   char name[100];
   char *description;

   strcpy(name, "Zara Ali");

   /* 动态分配内存 */
   description = malloc( 200 * sizeof(char) );
   if( description == NULL )
   {
      fprintf(stderr, "Error - unable to allocate required memory\n");
   }
   else
   {
      strcpy( description, "Zara ali a DPS student in class 10th");
   }
   printf("Name = %s\n", name );
   printf("Description: %s\n", description );
}
```

```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
   char name[100];
   char *description;

   strcpy(name, "Zara Ali");

   /* 动态分配内存 */
   description = malloc( 30 * sizeof(char) );
   if( description == NULL )
   {
      fprintf(stderr, "Error - unable to allocate required memory\n");
   }
   else
   {
      strcpy( description, "Zara ali a DPS student.");
   }
   /* 假设您想要存储更大的描述信息 */
   description = realloc( description, 100 * sizeof(char) );
   if( description == NULL )
   {
      fprintf(stderr, "Error - unable to allocate required memory\n");
   }
   else
   {
      strcat( description, "She is in class 10th");
   }
   
   printf("Name = %s\n", name );
   printf("Description: %s\n", description );

   /* 使用 free() 函数释放内存 */
   free(description);
}
```
