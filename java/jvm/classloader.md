# 类加载器

## 加载器类型
* Bootstrap类加载器
负责加载rt.jar中的JDK类文件,它是所有类加载器的父加载器,也称类初始化加载器
* Extension
从jre/lib/ext目录下或者java.ext.dirs系统属性定义的目录下加载类，sun.misc.Launcher$ExtClassLoader
* System
Application类加载器，classpath环境变量中加载某些应用相关的类，classpath环境变量通常由-classpath或-cp命令行选项来定义，
或者是JAR中的Manifest的classpath属性。Application类加载器是Extension类加载器的子加载器。通过sun.misc.Launcher$AppClassLoader实现 

## 工作机制
* 可见性
* 委托
* 单一性
根据这个机制，父加载器加载过的类不能被子加载器加载第二次

## 如何显示的加载类
Class.forName(classname)和Class.forName(classname, initialized, classloader)。defineClass()字节码转换成类实例
### 类加载的过程
* 加载：类加载过程的一个阶段：通过一个类的完全限定查找此类字节码文件，并利用字节码文件创建一个Class对象

* 验证：目的在于确保Class文件的字节流中包含信息符合当前虚拟机要求，不会危害虚拟机自身安全。主要包括四种验证，文件格式验证，元数据验证，字节码验证，符号引用验证。

* 准备：为类变量(即static修饰的字段变量)分配内存并且设置该类变量的初始值即0(如static int i=5;这里只将i初始化为0，至于5的值将在初始化时赋值)，这里不包含用final修饰的static，因为final在编译的时候就会分配了，注意这里不会为实例变量分配初始化，类变量会分配在方法区中，而实例变量是会随着对象一起分配到Java堆中。

* 解析：主要将常量池中的符号引用替换为直接引用的过程。符号引用就是一组符号来描述目标，可以是任何字面量，而直接引用就是直接指向目标的指针、相对偏移量或一个间接定位到目标的句柄。有类或接口的解析，字段解析，类方法解析，接口方法解析(这里涉及到字节码变量的引用，如需更详细了解，可参考《深入Java虚拟机》)。

* 初始化：类加载最后阶段，若该类具有超类，则对其进行初始化，执行静态初始化器和静态初始化成员变量(如前面只初始化了默认值的static变量将会在这个阶段赋值，成员变量也将被初始化)。

## 双亲委派机制
如果一个类加载器收到了类加载请求，它并不会自己先去加载，而是把这个请求委托给父类的加载器去执行，如果父类加载器还存在其父类加载器，则进一步向上委托，依次递归，请求最终将到达顶层的启动类加载器，如果父类加载器可以完成类加载任务，就成功返回，倘若父类加载器无法完成此加载任务，子加载器才会尝试自己去加载，这就是双亲委派模式

### 双亲委派机制的优势
采用双亲委派模式的是好处是Java类随着它的类加载器一起具备了一种带有优先级的层次关系，通过这种层级关可以避免类的重复加载，当父亲已经加载了该类时，就没有必要子ClassLoader再加载
另外一个是安全（java.lang.Integer）

## ClassLoader
* loadClass(String className)、loadClass(String name, boolean resolve)
```
protected Class<?> loadClass(String name, boolean resolve)
      throws ClassNotFoundException
  {
      synchronized (getClassLoadingLock(name)) {
          // 先从缓存查找该class对象，找到就不用重新加载
          Class<?> c = findLoadedClass(name);
          if (c == null) {
              long t0 = System.nanoTime();
              try {
                  if (parent != null) {
                      //如果找不到，则委托给父类加载器去加载
                      c = parent.loadClass(name, false);
                  } else {
                  //如果没有父类，则委托给启动加载器去加载
                      c = findBootstrapClassOrNull(name);
                  }
              } catch (ClassNotFoundException e) {
                  // ClassNotFoundException thrown if class not found
                  // from the non-null parent class loader
              }

              if (c == null) {
                  // If still not found, then invoke findClass in order
                  // 如果都没有找到，则通过自定义实现的findClass去查找并加载
                  c = findClass(name);

                  // this is the defining class loader; record the stats
                  sun.misc.PerfCounter.getParentDelegationTime().addTime(t1 - t0);
                  sun.misc.PerfCounter.getFindClassTime().addElapsedTimeFrom(t1);
                  sun.misc.PerfCounter.getFindClasses().increment();
              }
          }
          if (resolve) {//是否需要在加载时进行解析
              resolveClass(c);
          }
          return c;
      }
  }
```
*  findClass(String) 
```
protected Class<?> findClass(String name) throws ClassNotFoundException {
        throw new ClassNotFoundException(name);
}
```
