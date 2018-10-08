hello sqlite

$ sqlite3 database_name.db
$ .databases
$ select.....;
$ update.....;

; export csv to db
; .mode csv memory
; create table memory(database int,type varchar(128),key varchar(128),size_in_bytes int,encoding varchar(128),num_elements int,len_largest_element varchar(128));
; .import memory.csv memory

; redis rdb
; rdb -c memory dump.rdb > memory.csv;
; redis-rdb-tools是一个python的解析rdb文件工具, 主要有一下三个功能：
; 生成内存快照
; 转储成json格式
; 使用标准的diff工具比较两个dump文件
; https://yq.aliyun.com/articles/62899

--select count(*) from memory;
--select * from memory order by size_in_bytes desc limit 15;
--select sum(size_in_bytes) from memory;
--select * from memory where type='hash' and num_elements > 10000 ;
