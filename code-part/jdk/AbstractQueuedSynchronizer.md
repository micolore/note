# Concurrent
概念
* CAS CompareAndSet

* 公平锁   
      本来就没人持有锁，根本没必要进队列等待(又是挂起，又是等待被唤醒的)   
* 自旋   
      CAS设置tail过程中，竞争一次竞争不到，我就多次竞争，总会排到的

## AbstractQueuedSynchronizer

### field 
*  private transient volatile Node head;

 > 阻塞队列不包含head节点，head一般指的是占有锁的线程，head后面的才称为阻塞队列

*  private transient volatile Node tail;
*  private volatile int state;
*  private transient Thread exclusiveOwnerThread;

### class
* java.util.concurrent.locks.ReentrantLock   
* java.util.concurrent.locks.ReentrantLock.FairSync  公平锁
* java.util.concurrent.locks.ReentrantLock.NonfairSync 非公平锁
* java.util.concurrent.locks.AbstractQueuedSynchronizer.Node
```
        static final Node EXCLUSIVE = null;
        static final Node EXCLUSIVE = null;
        static final int SIGNAL    = -1;
        static final int CANCELLED =  1;
        static final int CONDITION = -2;
        static final int PROPAGATE = -3;
        volatile int waitStatus;
        volatile Node prev;
        volatile Node next;
        volatile Thread thread;
        Node nextWaiter;
```
        
### fucntion
* java.util.concurrent.locks.ReentrantLock.FairSync.lock() 获取锁
* java.util.concurrent.locks.AbstractQueuedSynchronizer.acquire(int) 争锁     
* java.util.concurrent.locks.AbstractQueuedSynchronizer.tryAcquire(int)   尝试获取锁
* java.util.concurrent.locks.AbstractQueuedSynchronizer.acquireQueued(Node, int) 放阻塞队列
* java.util.concurrent.locks.AbstractQueuedSynchronizer.addWaiter(Node)
* java.util.concurrent.locks.AbstractQueuedSynchronizer.enq(Node) 自旋入队
* java.util.concurrent.locks.AbstractQueuedSynchronizer.shouldParkAfterFailedAcquire(Node, Node)
* java.util.concurrent.locks.AbstractQueuedSynchronizer.parkAndCheckInterrupt() 挂起

## 具体的动作
1. 线程抢锁

2. 解锁
  * java.util.concurrent.locks.ReentrantLock.unlock()
  * java.util.concurrent.locks.AbstractQueuedSynchronizer.release(int)
  * java.util.concurrent.locks.AbstractQueuedSynchronizer.tryRelease(int)
  * java.util.concurrent.locks.AbstractQueuedSynchronizer.unparkSuccessor(Node)
  * java.util.concurrent.locks.LockSupport.unpark(Thread)



