# Css (Cascading Style Sheets)
* CSS 指层叠样式表 (Cascading Style Sheets)
* 样式定义如何显示 HTML 元素
* 样式通常存储在样式表中
* 把样式添加到 HTML 4.0 中，是为了解决内容与表现分离的问题
* 外部样式表可以极大提高工作效率
* 外部样式表通常存储在 CSS 文件中
* 多个样式定义可层叠为一

## CSS优先级
* 浏览器缺省设置
* 外部样式表
* 内部样式表（位于 <head> 标签内部）
* 内联样式（在 HTML 元素内部）

## 语法 
CSS 规则由两个主要的部分构成：选择器，以及一条或多条声明。
```
selector {declaration1; declaration2; ... declarationN }

selector {property: value}

h1 {color:red; font-size:14px;}
```
*  值的不同写法
*  记得写引号
*  多重声明
*  空格和大小写

## 高级语法
* 选择器的分组
* 继承
根据 CSS，子元素从父元素继承属性

## 选择器
###  派生选择器
```
li strong {
    font-style: italic;
    font-weight: normal;
  }

```

````
strong {
     color: red;
     }

h2 {
     color: red;
     }

h2 strong {
     color: blue;
     }
```

###  id 选择器
```
#red {color:red;}
#green {color:green;}
```

```
#sidebar p {
	font-style: italic;
	text-align: right;
	margin-top: 0.5em;
	}
```

### CSS 类选择器
```
.center {text-align: center}
```

```
.fancy td {
	color: #f60;
	background: #666;
	}
```

```
td.fancy {
	color: #f60;
	background: #666;
	}
```

### CSS 属性选择器
```
[title]
{
color:red;
}
```
```
[title=W3School]
{
border:5px solid blue;
}
```



