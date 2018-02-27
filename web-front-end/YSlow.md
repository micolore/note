# YSlow
 
## 参数
* 性能评级 b
* 加载时长
* 页面大小   
   1 内容分类大小占比   
      image、script、html、css  
   2 按照域名的请求内容大小  
   
* 请求数量   
   1 请求状态返回码    
      200、302   
   2 content type   
      image、script、html、css   
   3 按照域名的请求数量分类
 * 查看请求时长最长的请求以及请求的结果集最大的请求
 * 网络中的耗时查看    
   DNS SSL Connect Send  Wait Receive 这几个也要进行观察
 * Content Types   
 HTML	HTML document  
 Javascript	JavaScript file   
 CSS	CSS file  
 Image	Image file   
 Text/plain	Plain text document  
 Other	Any other content type, for example flash files   
 Warning	The request got a 4XX, 5XX response or couldn’t be loaded   
 Redirect The request got a 3XX response and was redirected   

## 如何优化，使得网站响应速度更加的迅速
* 尽量减少 HTTP请求
* 减少 DNS查找
* 避免跳转
* 缓存 Ajxa
* 推迟加载
* 提前加载
* 减少 DOM元素数量
* 用域名划分页面内容
* 使 frame数量最少
* 避免 404错误
  
 [20 种提升网页速度的技巧](https://www.ibm.com/developerworks/cn/web/wa-speedweb/index.html)   
 [如何提高优化网站性能的30条规则方法](http://houshidai.com/internet/yahoo-optimize-web-rules.html)
