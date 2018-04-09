# 工厂方法模式
## 模式动机
## 模式定义
## 模式结构
* Product：抽象产品
* ConcreteProduct：具体产品
* Factory：抽象工厂
* ConcreteFactory：具体工厂
## 时序图
## 代码分析
## 模式分析
## 实例
## 工厂方法模式的优点
## 工厂方法模式的缺点
## 适用环境
## 模式应用
jdbc
```
Connection conn=DriverManager.getConnection("jdbc:microsoft:sqlserver://localhost:1433; DatabaseName=DB;user=sa;password=");
Statement statement=conn.createStatement();
ResultSet rs=statement.executeQuery("select * from UserInfo");
```
## 模式扩展

## 总结
