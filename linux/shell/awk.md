# AWK

# hello work 
```
 //不换行
 awk '{printf $1, $4}' 0306.txt  
 awk '{print  $1, $4}' 0306.txt 
```
## 添加条件
```
//其他条件 !=, >, <, >=, <=
awk '$3==0 && $6=="LISTEN" ' 0306.txt

//输出
awk ' $3>0 {print $0}' 0306.txt
```

## 内建变量  

$0	当前记录（这个变量中存放着整个行的内容）  
$1~$n	当前记录的第n个字段，字段间由FS分隔   
FS	输入字段分隔符 默认是空格或Tab   
NF	当前记录中的字段个数，就是有多少列   
NR	已经读出的记录数，就是行号，从1开始，如果有多个文件话，这个值也是不断累加中。   
FNR	当前记录数，与NR不同的是，这个值会是各个文件自己的行号   
RS	输入的记录分隔符， 默认为换行符   
OFS	输出字段分隔符， 默认也是空格   
ORS	输出的记录分隔符，默认为换行符   
FILENAME	当前输入文件的名字   
### example
```

awk '$3==0 && $6=="ESTABLISHED" || NR==1 {printf "%02s %s %-20s %-20s %s\n",NR, FNR, $4,$5,$6}' netstat.txt
//指定分隔符
awk  'BEGIN{FS=":"} {print $1,$3,$6}' /etc/passwd  

awk  -F: '{print $1,$3,$6}' /etc/passwd  

awk  -F: '{print $1,$3,$6}' OFS="\t" /etc/passwd   

```


## 字符串匹配 
```
awk '$6 ~ /FIN/ || NR==1 {print NR,$4,$5,$6}' OFS="\t" 0306.txt

 awk '$6 ~ /WAIT/ || NR==1 {print NR,$4,$5,$6}' OFS="\t" 0306.txt
 
 // ~ 表示模式开始。/ /中是模式
 
 awk '/LISTEN/' 0306.txt
 
 awk '/&type=1&imsi=410018257763675/' 0306.txt 
 
 awk '$6 ~ /FIN|TIME/ || NR==1 {print NR,$4,$5,$6}' OFS="\t" netstat.txt
 
```

## 折分文件  

```
awk 'NR!=1{print > $6}' netstat.txt   

awk 'NR!=1{print $4,$5 > $6}' netstat.txt   

awk 'NR!=1{if($6 ~ /TIME|ESTABLISHED/) print > "1.txt";
else if($6 ~ /LISTEN/) print > "2.txt";
else print > "3.txt" }' netstat.txt  
//脚本解释器

```

## 统计  
```
awk 'NR!=1{a[$6]++;} END {for (i in a) print i ", " a[i];}' netstat.txt

//统计每个用户的进程的占了多少内存
ps aux | awk 'NR!=1{a[$1]+=$6;} END { for(i in a) print i ", " a[i]"KB";}'

```

# awk脚本





 
