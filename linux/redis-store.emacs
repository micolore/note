hello redis store

; info memory
; used_memory:199439664
; used_memory_human:190.20M 友好显示
; used_memory_rss:151347200 redis 进程占据操作系统的内存
; used_memory_rss_human:144.34M
; used_memory_peak:458454464
; used_memory_peak_human:437.22M
; total_system_memory:33450979328
; total_system_memory_human:31.15G
; used_memory_lua:37888
; used_memory_lua_human:37.00K
; maxmemory:1000000000
; maxmemory_human:953.67M
; maxmemory_policy:allkeys-lru
; mem_fragmentation_ratio:0.76 内存碎片化比率
; mem_allocator:jemalloc-4.0.3 内存分布器

内存占用分下面几个部分
1. 数据
2. 进程本身运行需要的内存
3. 缓冲内存
4. 内存碎片


数据类型
编码方式
    raw  简单动态字符串
    int  整数
    ht   字典
    zipmap 
    linkedlist 双端链表
    ziplist  压缩列表 
    intset 整数集合
    skplist 跳跃表和字典
数据指针
虚拟内存





