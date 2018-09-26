client list 
client kill 
slowlog get 10  结果为查询ID、发生时间、运行时长和原命令 默认10毫秒
log
  redis.log 为主
  sentinel.log 监控日志
info
  total_connections_received 连接数
服务可用 ping  -> pong
正在执行的命令 monitor  生产慎用

延迟检查
  INFO commandstats   执行多少次命令

RDB 分析内存相关