## c
### PO(persistant object) 持久对象
在 o/r 映射的时候出现的概念，如果没有 o/r 映射，没有这个概念存在了。通常对应数据模型 ( 数据库 ), 本身还有部分业务逻辑的处理。可以看成是与数据库中的表相映射的 java 对象。最简单的 PO 就是对应数据库中某个表中的一条记录，多个记录可以用 PO 的集合。 PO 中应该不包含任何对数据库的操作。

### DO（Domain Object）领域对象
就是从现实世界中抽象出来的有形或无形的业务实体。一般和数据中的表结构对应。

### TO(Transfer Object) ，数据传输对象
在应用程序不同 tie( 关系 ) 之间传输的对象

### DTO（Data Transfer Object）数据传输对象
这个概念来源于J2EE的设计模式，原来的目的是为了EJB的分布式应用提供粗粒度的数据实体，以减少分布式调用的次数，从而提高分布式调用的性能和降低网络负载，但在这里，我泛指用于展示层与服务层之间的数据传输对象。

### VO(view object) 值对象
视图对象，用于展示层，它的作用是把某个指定页面（或组件）的所有数据封装起来。

### BO(business object) 业务对象
从业务模型的角度看 , 见 UML 元件领域模型中的领域对象。封装业务逻辑的 java 对象 , 通过调用 DAO 方法 , 结合 PO,VO 进行业务操作。 business object: 业务对象 主要作用是把业务逻辑封装为一个对象。这个对象可以包括一个或多个其它的对象。 比如一个简历，有教育经历、工作经历、社会关系等等。 我们可以把教育经历对应一个 PO ，工作经历对应一个 PO ，社会关系对应一个 PO 。 建立一个对应简历的 BO 对象处理简历，每个 BO 包含这些 PO 。 这样处理业务逻辑时，我们就可以针对 BO 去处理。

### POJO(plain ordinary java object) 简单无规则 java 对象
纯的传统意义的 java 对象。就是说在一些 Object/Relation Mapping 工具中，能够做到维护数据库表记录的 persisent object 完全是一个符合 Java Bean 规范的纯 Java 对象，没有增加别的属性和方法。我的理解就是最基本的 Java Bean ，只有属性字段及 setter 和 getter 方法！。

### DAO(data access object) 数据访问对象
是一个 sun 的一个标准 j2ee 设计模式， 这个模式中有个接口就是 DAO ，它负持久层的操作。为业务层提供接口。此对象用于访问数据库。通常和 PO 结合使用， DAO 中包含了各种数据库的操作方法。通过它的方法 , 结合 PO 对数据库进行相关的操作。夹在业务逻辑与数据库资源中间。配合 VO, 提供数据库的 CRUD 操作 

## E
PO(persistant object) Persistent object 
Concepts that appear in the o/r map, if there is no o/r mapping, this concept does not exist. Usually corresponds to the data model (database), itself part of the business logic processing. Can be mapped to a table in the database Java object. The most simple PO database is corresponding to a record in a table, a plurality of recording can be used PO collection. PO should not contain any operation of the database. 

VO(value object) Value object 
Usually used for data transfer between the business layer, and PO only contains data. But it should be abstracted business object, and table, also can not, this according to the need of business. I think that with the DTO (data transfer object, transfer in Web). 

TO(Transfer Object), The data transfer object
In the application of different tie (relationship) between the object transmission 

BO(business object) Business objects 
From business model perspective, see the domain model of UML element in the field of object. To encapsulate the business logic of the Java object, by calling the DAO method, combined with PO, VO for business operations. 

POJO(plain ordinary java object) No simple rule Java object
The traditional pure Java object. That is to say in some Object/Relation Mapping tools, can maintain the database record persisent object is a completely conforms to the Java specification of Bean pure Java object, without adding other properties and methods. My understanding is the most basic Java Bean, only the attribute fields and setter and getter method！. 

DAO(data access object) Data access object 
Is a standard J2EE design pattern, a sun, a DAO interface is the mode of operation, its negative persistence layer. Provides the interface for the business layer. This object is used to access the database. Usually used in combination with the PO, DAO contains a variety of database operation method. Through its method, combined with PO related operations on the database. Caught in the middle of the business logic and database resources. With the VO, provide the database CRUD operation... 

O/The R Mapper object / Relational Mapping 
After the definition of all the mapping, the O/R Mapper can help us to do a lot of work. Through the mappings, the O/R Mapper can generate all about object to save, delete, the SQL statement reads, we no longer need to write so many lines of DAL code. 

Entity Model (solid) 
DAL (a data access layer) 
IDAL (Interface) 
DALFactory (factory) 
BLL (business logic layer) 
BOF Business Object Framework business object framework 
Design of service oriented SOA Service Orient Architecture 
EMF Eclipse Model Framework Eclipse modeling framework

----------------------------------------

PO: The full name is
Persistant object persistent object
A record of the image understanding is a PO that is in the database. 
The benefits can be put a record as an object, it will be convenient to the other objects. 

BO: The full name is
Business object: service object
The main role is to encapsulate business logic as an object. The object may include one or more other objects. 
For example, a resume, education experience, work experience, social relations and so on. 
We can put the education has a corresponding PO, experience a corresponding PO, social relations corresponding to a PO. 
BO object processing resumes to establish a corresponding resume, each BO contains the PO. 
Such processing business logic, we can according to the BO to handle. 

VO : 
The value object object
The ViewObject presentation layer object
The data object corresponding interface display. For a WEB page, an interface or SWT, SWING, with a VO object corresponding to the interface value. 

DTO : 
Data Transfer Object data transfer object
Mainly used for long-distance calls need large transfer object place. 
For example, we have a table has 100 fields, then PO has 100 attributes. 
But we interface as long as the 10 display field, 
The client using WEB service to obtain the data, there is no need to pass the PO object to the client, 
Then we can use only these 10 properties of the DTO to transfer the results to the client, this also not exposed to the client server structure. Later, if you use this object to the corresponding interface display, then its identity to VO

POJO : 
Plain ordinary Java object java simple object
POJO personal feeling is the most common object is the most variable, is an intermediate object, the object is we most often deal with. 

A POJO persistence is PO
It is directly used for transferring, transfer process is DTO
Directly to the corresponding representation layer is VO

DAO: 
Data access object data access objects
The most familiar, and above O the biggest difference, basically no possibility and necessary to transform into each other
Mainly used to encapsulate access to database. It can put the POJO persistence PO, assembled by PO VO, DTO

-----------------------------------------------------------------

PO:persistant object persistent object, can be regarded as the phase maps and tables in the database Java object. The most simple PO database is corresponding to a record in a table, a plurality of recording can be used PO collection. PO should not contain any operation on the database 

The VO:value object object. Usually used for data transfer between the business layer, and PO only contains data. But it should be abstracted business object, and table, also can not, this according to the need of business. I think that with the DTO (data transfer object, transfer) on Web 

DAO:data access object data access object, this object is used to access the database. Usually used in combination with the PO, DAO contains a variety of database operation method. Through its method, combined with PO related operation of the database 

BO:business object business objects, to encapsulate the business logic of Java object, by calling the DAO method, combined with PO, VO for business operations; 

POJO:plain ordinary Java object simple Java objects without rules, I personally think it and the other is not a side of things, VO and PO should belong to it

---------------------------------------------
VO: The value object, view object
PO: Persistent object
QO: The query object
DAO: Data access object
DTO: The data transfer object
----------------------------------------
Struts ActionForm is a VO;
The hibernate entity bean is a PO, also called POJO;
Hibernate Criteria is equivalent to a QO;
When using hibernate we will define some methods of query, the method of writing in the interface, can realize different. This interface can be said to be a DAO
Personally think that the QO and DTO almost
----------------------------------------
PO or BO, and the database is closest to the one layer is ORM, O, basically is an attribute of the database field corresponds to BO, in order to synchronization and safety considerations, only the best for DAO or Service call, and don't use packcode, backingBean, or BO. 
DAO, The data access layer, the VO, backingBean object can be put into. . . . 
DTO, Rarely, basic into DAO, but to play the role of transition. 
QO, Put some and persistent queries and statements into. . 
VO, The V layer use the basic elements and methods put the. If the call to BO, then do BO VO conversion, VO conversion BO operation. The benefit of VO is more than BO of the element properties page, can play a very good role. . . . 
-----------------------------------------
The upstairs is wrong, PO is a persistent object. BO = business object— business object. 
PO can be strictly corresponding database table, a table mapping a PO. 
BO is the business logic processing object, my understanding is that it is full of the business logic processing, useful in the application of complex business logic. 
VO: The value object object, view object view object
PO: Persistent object
QO: The query object
DAO: Data access objects — — and DAO model
DTO: The data transfer object — — and DTO model
