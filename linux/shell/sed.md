# sed
sed全名叫stream editor，流编辑器，用程序的方式来编辑文本，相当的hacker啊。  

## hello world
```
sed "s/my/Hao Chen's/g" pets.txt
//输出
sed "s/my/Hao Chen's/g" pets.txt > hao_pets.txt

//直接修改文件内容
sed -i "s/my/Hao Chen's/g" pets.txt

//每一行最前面加点东西
sed 's/^/#/g' pets.txt

//每一行最后面加点东西
sed 's/$/ --- /g' pets.txt

// 3行6行
sed "3,6s/my/your/g" pets.txt
```

## common 

^ 表示一行的开头。如：/^#/ 以#开头的匹配。  
$ 表示一行的结尾。如：/}$/ 以}结尾的匹配。   
\< 表示词首。 如：\<abc 表示以 abc 为首的詞。  
\> 表示词尾。 如：abc\> 表示以 abc 結尾的詞。   
. 表示任何单个字符。   
* 表示某个字符出现了0次或多次。   
[ ] 字符集合。 如：[abc] 表示匹配a或b或c，还有 [a-zA-Z] 表示匹配所有的26个字符。如果其中有^表示反，如 [^a] 表示非a的字符   

## 
[SED 简明教程](https://coolshell.cn/articles/9104.html)
