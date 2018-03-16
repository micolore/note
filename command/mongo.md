# mongo 

## hello word 

 db.channel_articles.update({"processed":false},{$set:{"processed":true}},{multi:true})    
 db.channel_articles.update({'processed':false},{$set:{'processed':true}})   
 db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}})   
 db.channel_articles.find({"processed":false}).count();   
 db.channel_articles.find().count();   
 db.channel_articles.remove({});    
 
## links
[MongoDB 教程](http://www.runoob.com/mongodb/mongodb-tutorial.html)
