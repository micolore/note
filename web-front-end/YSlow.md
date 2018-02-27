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
  
  ## 常见处理方案 按照等级划分
 *  Parallelize downloads across hostnames
 *  Leverage browser caching
 *  Combine external JavaScript
 *  Serve static content from a cookieless domain
 *  Minimize redirects
 *  Minimize/reduce DNS lookups
 *  Remove query strings from static resources
 *  Specify a Vary: Accept-Encoding header
 *  Specify a cache validator
 *  Avoid bad requests
 *  Combine external CSS
 *  Minimize request size
 *  Make javascript and css external
 *  Avoid CSS expressions
 *  Put CSS at top
 *  Make fewer HTTP requests
 *  Add Expires headers
 *  Compress components with gzip
 *  Put JavaScript at bottom
 *  Minify JavaScript and CSS
 *  Remove duplicate JavaScript and CSS
 *  Configure entity tags (ETags)
 *  Make AJAX cacheable
 *  Use GET for AJAX requests
 *  Reduce the number of DOM elements
 *  Avoid HTTP 404 (Not Found) error
 *  Reduce cookie size
 *  Use cookie-free domains
 *  Avoid AlphaImageLoader filter
 *  Do not scale images in HTML
 *  Make favicon small and cacheable
 *  Flush the Buffer Early
 *  Post-load Components
 *  Preload Components
 *  Split Components Across Domains
 *  Minimize the Number of iframes
 *  No 404s
 *  Use Cookie-free Domains for Components
 *  Minimize DOM Access
 *  Develop Smart Event Handlers
 *  Choose <link> over @import
 *  Avoid Filters
 *  Optimize Images
 *  Optimize CSS Sprites
 *  Don't Scale Images in HTML
 *  Keep Components under 25K
 *  Pack Components into a Multipart Document
 *  Avoid Empty Image src
 *  Use a Content Delivery Network
 *  Add an Expires or a Cache-Control Header
 *  Gzip Components
 

 [20 种提升网页速度的技巧](https://www.ibm.com/developerworks/cn/web/wa-speedweb/index.html)    

 [如何提高优化网站性能的30条规则方法](http://houshidai.com/internet/yahoo-optimize-web-rules.html)  
 
 [yahoo developer performance rules](https://developer.yahoo.com/performance/rules.html)   
