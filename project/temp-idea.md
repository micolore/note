# temp idea for project


## 系统缓存使用管理
   * 缓存key管理，后台动态维护  
      更新、删除  
  
   * 缓存的监控  
      cache-key的数量、cache-value在内存中占比多少   
      以及cache-key的访问数量统计(程序异步写到消息队列里面即可,入库统计)、定时clean不常用的key   
      以及请求缓存失败次数，大key的统计   
     
   * 缓存的实时预警  
      缓存内存的监控   


### 具体设计:    
      1 统计结果写入数据库  
         cache-key、is_success  
      2 代码异步写入消息队列   
      3 后台展示数据统计  
