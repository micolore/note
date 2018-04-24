# html
## jsoup 
```
//把jsoup转义的html替换成原来的标签
Entities.EscapeMode.base.getMap().clear(); //转义前清除jsoup 转义表
Document doc = Jsoup.parseBodyFragment(sourceData);
doc.outputSettings().prettyPrint(false);//设置document 输出属性，设置是否压缩打印为false；

```
