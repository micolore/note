# Concurrent
概念
* CAS
* 公平锁   
      本来就没人持有锁，根本没必要进队列等待(又是挂起，又是等待被唤醒的)   
* 自旋   
      CAS设置tail过程中，竞争一次竞争不到，我就多次竞争，总会排到的

## AbstractQueuedSynchronizer

### field 
*  private transient volatile Node head;
*  private transient volatile Node tail;
*  private volatile int state;
*  private transient Thread exclusiveOwnerThread;

### class
* java.util.concurrent.locks.ReentrantLock   
* java.util.concurrent.locks.ReentrantLock.FairSync  公平锁
* java.util.concurrent.locks.ReentrantLock.NonfairSync 非公平锁

### fucntion
* java.util.concurrent.locks.ReentrantLock.FairSync.lock() 获取锁
* java.util.concurrent.locks.AbstractQueuedSynchronizer.acquire(int) 争锁     
* java.util.concurrent.locks.AbstractQueuedSynchronizer.tryAcquire(int)   尝试获取锁
* java.util.concurrent.locks.AbstractQueuedSynchronizer.acquireQueued(Node, int) 放阻塞队列
* java.util.concurrent.locks.AbstractQueuedSynchronizer.addWaiter(Node)
* java.util.concurrent.locks.AbstractQueuedSynchronizer.enq(Node) 自旋入队





