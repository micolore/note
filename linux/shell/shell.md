# shell

## Shell 环境
hell 编程跟 java、php 编程一样，只要有一个能编写代码的文本编辑器和一个能解释执行的脚本解释器就可以了。
## Shell 分类
Bourne Shell（/usr/bin/sh或/bin/sh） 
Bourne Again Shell（/bin/bash） *** 重点  
C Shell（/usr/bin/csh）  
K Shell（/usr/bin/ksh） 
Shell for Root（/sbin/sh）  

## first shell 
```
#!/bin/bash
echo "Hello World !"

```
## 运行 Shell 脚本有两种方法
1  作为可执行程序
```
chmod +x ./test.sh  #使脚本具有执行权限
./test.sh  #执行脚本

```
2  作为解释器参数

```
/bin/sh test.sh
/bin/php test.php
```
## Shell 变量  
定义变量时，变量名不加美元符号（$，PHP语言中变量需要），如：  
```
your_name="runoob.com"
```
命名规则：  
命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。  
中间不能有空格，可以使用下划线（_）。  
不能使用标点符号。   
不能使用bash里的关键字（可用help命令查看保留关键字）。   

有效的如下：  
```
RUNOOB
LD_LIBRARY_PATH
_var
var2
```
无效的如下：  
```
?var=123
user*name=runoob

```
用语句进行赋值:  
```
for file in `ls /etc`
```
### 使用变量 
 使用一个定义过的变量，只要在变量名前面加美元符号即可，如     
 your_name="qinjx"  
 echo $your_name  
 echo ${your_name}  
 
### 只读变量
```
#!/bin/bash
myUrl="http://www.w3cschool.cc"
readonly myUrl
myUrl="http://www.runoob.com"

```
### 删除变量
```
unset variable_name
```

### 变量类型
* 局部变量 局部变量在脚本或命令中定义，仅在当前shell实例中有效，其他shell启动的程序不能访问局部变量。
* 环境变量 所有的程序，包括shell启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。必要的时候shell脚本也可以定义环境变量。
* shell变量 shell变量是由shell程序设置的特殊变量。shell变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了shell的正常运行

## Shell 字符串
### 单引号
```
str='this is a string'
```
### 双引号
```
your_name='qinjx'
str="Hello, I know your are \"$your_name\"! \n"
```
### 拼接字符串
```
your_name="qinjx"
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting $greeting_1

### 获取字符串长度
```
string="abcd"
echo ${#string} #输出 4
```
### 提取子字符串
```
string="runoob is a great site"
echo ${string:1:4} # 输出 unoo
```
### 查找子字符串
```
string="runoob is a great company"
echo `expr index "$string" is`  # 输出 8
```
## Shell 数组

### 定义数组
```
数组名=(值1 值2 ... 值n)  

array_name=(value0 value1 value2 value3)

array_name=(
value0
value1
value2
value3
)

array_name[0]=value0
array_name[1]=value1
array_name[n]=valuen

```
### 读取数组
```
${数组名[下标]}

valuen=${array_name[n]}

echo ${array_name[@]} 
```
### 获取数组的长度
```
# 取得数组元素的个数
length=${#array_name[@]}
# 或者
length=${#array_name[*]}
# 取得数组单个元素的长度
lengthn=${#array_name[n]}

## Shell 注释
```
#--------------------------------------------
# 这是一个注释
# author：菜鸟教程
# site：www.runoob.com
# slogan：学的不仅是技术，更是梦想！
#--------------------------------------------
##### 用户配置区 开始 #####
#
#
# 这里可以添加脚本描述信息
# 
#
##### 用户配置区 结束  #####

```





