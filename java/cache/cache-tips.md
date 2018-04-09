# cache tips

## 常见问题

### 缓存穿透
概念:   
一般的缓存系统，都是按照key去缓存查询，如果不存在对应的value，就应该去后端系统查找（比如DB）。
如果key对应的value是一定不存在的，并且对该key并发请求量很大，就会对后端系统造成很大的压力。这就叫做缓存穿透。    
解决思路：
1. 对查询结果为空的情况也进行缓存，缓存时间设置短一点，或者该key对应的数据insert了之后清理缓存。
2. 对一定不存在的key进行过滤。可以把所有的可能存在的key放到一个大的Bitmap中，查询时通过该bitmap过滤。

```
public object GetProductListNew()
        {
            const int cacheTime = 30;
            const string cacheKey = "product_list";

            var cacheValue = CacheHelper.Get(cacheKey);
            if (cacheValue != null)
                return cacheValue;
                
            cacheValue = CacheHelper.Get(cacheKey);
            if (cacheValue != null)
            {
                return cacheValue;
            }
            else
            {
                cacheValue = GetProductListFromDB(); //数据库查询不到，为空。
                
                if (cacheValue == null)
                {
                    cacheValue = string.Empty; //如果发现为空，设置个默认值，也缓存起来。                
                }
                CacheHelper.Add(cacheKey, cacheValue, cacheTime);//设置缓存时间，可以很短
                
                return cacheValue;
            }
        }  

```
> 这里还要考虑一点就是，缓存何时进行更新还是没有逻辑进行触发更新。

### 缓存雪崩
概念：  
    当缓存服务器重启或者大量缓存集中在某一个时间段失效，这样在失效的时候，也会给后端系统(比如DB)带来很大压力。   
再详细点就是:   
1. 服务提供者不可用
2. 重试加大流量
3. 服务调用者不可用
造成不可用的原因可能有多个:  
1. 硬件故障
2. 程序Bug
3. 缓存击穿
4. 用户大量请求

重试加大流量的有两个原因：  
1. 用户重试
2. 代码逻辑重试

服务调用者不可用的原因：   
同步等待造成的资源耗尽

具体的解决策略:  
1. 流量控制
* 网关限流
* 用户交互限流
* 关闭重试
2. 改进缓存模式
* 缓存预加载
* 同步改为异步刷新
3. 服务自动扩容
* AWS的auto scaling
4. 服务调用者降级服务
* 资源隔离
* 对依赖服务进行分类
* 不可用服务的调用快速失败

解决思路:
1. 在缓存失效后，通过加锁或者队列来控制读数据库写缓存的线程数量。比如对某个key只允许一个线程查询数据和写缓存，其他线程等待。
   相应的会减少系统的吞吐量为代价
2. 不同的key，设置不同的过期时间，让缓存失效的时间点尽量均匀。
3. 做二级缓存，A1为原始缓存，A2为拷贝缓存，A1失效时，可以访问A2，A1缓存失效时间设置为短期，A2设置为长期（此点为补充）

```
 public object GetProductListNew()
        {
            const int cacheTime = 30;
            const string cacheKey = "product_list";
            //缓存标记。
            const string cacheSign = cacheKey + "_sign";
            
            var sign = CacheHelper.Get(cacheSign);
            //获取缓存值
            var cacheValue = CacheHelper.Get(cacheKey);
            if (sign != null)
            {
                return cacheValue; //未过期，直接返回。
            }
            else
            {
                CacheHelper.Add(cacheSign, "1", cacheTime);
                ThreadPool.QueueUserWorkItem((arg) =>
                {
                    cacheValue = GetProductListFromDB(); //这里一般是 sql查询数据。
                    CacheHelper.Add(cacheKey, cacheValue, cacheTime*2); //日期设缓存时间的2倍，用于脏读。                
                });
                
                return cacheValue;
            }
        } 
```
使用互斥锁:   
业界比较常用的做法，是使用mutex。简单地来说，就是在缓存失效的时候（判断拿出来的值为空），不是立即去load db，而是先使用缓存工具的某些带成功操作返回值的操作（比如Redis的SETNX或者Memcache的ADD）去set一个mutex key，当操作返回成功时，再进行load db的操作并回设缓存；否则，就重试整个get缓存的方法。
SETNX，是「SET if Not eXists」的缩写，也就是只有不存在的时候才设置，可以利用它来实现锁的效果。在redis2.6.1之前版本未实现setnx的过期时间
```
//2.6.1前单机版本锁  
String get(String key) {    
   String value = redis.get(key);    
   if (value  == null) {    
    if (redis.setnx(key_mutex, "1")) {    
        // 3 min timeout to avoid mutex holder crash    
        redis.expire(key_mutex, 3 * 60)    
        value = db.get(key);    
        redis.set(key, value);    
        redis.delete(key_mutex);    
    } else {    
        //其他线程休息50毫秒后重试    
        Thread.sleep(50);    
        get(key);    
    }    
  }    
}  

public String get(key) {  
      String value = redis.get(key);  
      if (value == null) { //代表缓存值过期  
          //设置3min的超时，防止del操作失败的时候，下次缓存过期一直不能load db  
          if (redis.setnx(key_mutex, 1, 3 * 60) == 1) {  //代表设置成功  
               value = db.get(key);  
                      redis.set(key, value, expire_secs);  
                      redis.del(key_mutex);  
              } else {  //这个时候代表同时候的其他线程已经load db并回设到缓存了，这时候重试获取缓存值即可  
                      sleep(50);  
                      get(key);  //重试  
              }  
          } else {  
              return value;        
          }  
 }  

```

### 缓存预热
缓存预热就是系统上线后，将相关的缓存数据直接加载到缓存系统。这样避免，用户请求的时候，再去加载相关的数据   
解决思路：  
1. 直接写个缓存刷新页面，上线时手工操作下。 
2. 数据量不大，可以在WEB系统启动的时候加载。
3. 定时刷新缓存，

### 缓存更新
缓存淘汰的策略有两种：   
1. 定时去清理过期的缓存。
2. 当有用户请求过来时，再判断这个请求所用到的缓存是否过期，过期的话就去底层系统得到新数据并更新缓存。
