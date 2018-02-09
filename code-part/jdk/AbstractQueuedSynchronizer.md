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

# java.util.concurrent.locks.ReentrantLock

1. 锁默认实现方式为非公平锁,除非你在构造方法中传入参数 true 。
```
public ReentrantLock() {
    sync = new NonfairSync();
}
public ReentrantLock(boolean fair) {
    sync = fair ? new FairSync() : new NonfairSync();
}
```

2. 公平锁与非公平锁的区别
   * 公平锁和非公平锁相比，这里多了一个判断：是否有线程在等待
```
  protected final boolean tryAcquire(int acquires) {
        final Thread current = Thread.currentThread();
        int c = getState();
        if (c == 0) {
            // 1. 和非公平锁相比，这里多了一个判断：是否有线程在等待
            if (!hasQueuedPredecessors() &&
                compareAndSetState(0, acquires)) {
                setExclusiveOwnerThread(current);
                return true;
            }
        }
        else if (current == getExclusiveOwnerThread()) {
            int nextc = c + acquires;
            if (nextc < 0)
                throw new Error("Maximum lock count exceeded");
            setState(nextc);
            return true;
        }
        return false;
    }
```
* 非公平锁   
```
final void lock() {
        // 2. 和公平锁相比，这里会直接先进行一次CAS，成功就返回了
        if (compareAndSetState(0, 1))
            setExclusiveOwnerThread(Thread.currentThread());
        else
            acquire(1);
    }
```
> 总结：公平锁和非公平锁只有两处不同：
非公平锁在调用 lock 后，首先就会调用 CAS 进行一次抢锁，如果这个时候恰巧锁没有被占用，那么直接就获取到锁返回了。  
非公平锁在 CAS 失败后，和公平锁一样都会进入到 tryAcquire 方法，在 tryAcquire 方法中，如果发现锁这个时候被释放了（state == 0），非公平锁会直接 CAS 抢锁，但是公平锁会判断等待队列是否有线程处于等待状态，如果有则不去抢锁，乖乖排到后面。   

公平锁和非公平锁就这两点区别，如果这两次 CAS 都不成功，那么后面非公平锁和公平锁是一样的，都要进入到阻塞队列等待唤醒。   

相对来说，非公平锁会有更好的性能，因为它的吞吐量比较大。当然，非公平锁让获取锁的时间变得更加不确定，可能会导致在阻塞队列中的线程长期处于饥饿状态。


# java.util.concurrent.locks.Condition
>条件队列

* java.util.concurrent.locks.AbstractQueuedSynchronizer.ConditionObject
* java.util.concurrent.locks.AbstractQueuedSynchronizer.ConditionObject.await()
* java.util.concurrent.locks.AbstractQueuedSynchronizer.ConditionObject.awaitUninterruptibly() 不可被中断
* java.util.concurrent.locks.AbstractQueuedSynchronizer.ConditionObject.addConditionWaiter()
* java.util.concurrent.locks.AbstractQueuedSynchronizer.ConditionObject.unlinkCancelledWaiters()
* java.util.concurrent.locks.AbstractQueuedSynchronizer.fullyRelease(Node)
* java.util.concurrent.locks.AbstractQueuedSynchronizer.isOnSyncQueue(Node)
* java.util.concurrent.locks.AbstractQueuedSynchronizer.ConditionObject.signal()
* java.util.concurrent.locks.AbstractQueuedSynchronizer.ConditionObject.doSignal(Node)
* java.util.concurrent.locks.AbstractQueuedSynchronizer.transferForSignal(Node)
* java.util.concurrent.locks.AbstractQueuedSynchronizer.ConditionObject.checkInterruptWhileWaiting(Node)
* java.util.concurrent.locks.AbstractQueuedSynchronizer.transferAfterCancelledWait(Node)

```
        public final void await() throws InterruptedException {
            if (Thread.interrupted())
                throw new InterruptedException();
            Node node = addConditionWaiter();
            int savedState = fullyRelease(node);
            int interruptMode = 0;
            while (!isOnSyncQueue(node)) {
                LockSupport.park(this);
                if ((interruptMode = checkInterruptWhileWaiting(node)) != 0)
                    break;
            }
            if (acquireQueued(node, savedState) && interruptMode != THROW_IE)
                interruptMode = REINTERRUPT;
            if (node.nextWaiter != null) // clean up if cancelled
                unlinkCancelledWaiters();
            if (interruptMode != 0)
                reportInterruptAfterWait(interruptMode);
        }
```

# java.util.concurrent.CountDownLatch

* java.util.concurrent.CountDownLatch.countDown()  
   countDown() 方法每次调用都会将 state 减 1，直到 state 的值为 0 
1. java.util.concurrent.locks.AbstractQueuedSynchronizer.releaseShared(int)
2. java.util.concurrent.locks.AbstractQueuedSynchronizer.tryReleaseShared(int)
3. java.util.concurrent.locks.AbstractQueuedSynchronizer.doReleaseShared()
4. java.util.concurrent.locks.AbstractQueuedSynchronizer.unparkSuccessor(Node) 唤醒
5. java.util.concurrent.locks.AbstractQueuedSynchronizer.setHeadAndPropagate(Node, int)
6. java.util.concurrent.locks.AbstractQueuedSynchronizer.doReleaseShared()

* java.util.concurrent.CountDownLatch.await() 
   而 await 是一个阻塞方法，当 state 减为 0 的时候，await 方法才会返回

1. java.util.concurrent.locks.AbstractQueuedSynchronizer.acquireSharedInterruptibly(int)
2. java.util.concurrent.locks.AbstractQueuedSynchronizer.tryAcquireShared(int)
3. java.util.concurrent.locks.AbstractQueuedSynchronizer.doAcquireSharedInterruptibly(int)





#  java.util.concurrent.CyclicBarrier 
字面意思是“可重复使用的栅栏”，它是 ReentrantLock 和 Condition 的组合使用

# java.util.concurrent.Semaphore 
它类似一个资源池，每个线程需要调用 acquire() 方法获取资源，然后才能执行，执行完后，需要 release 资源，让给其他的线程用


整体看了一下，很有收获，继续磕concurrent包


参考链接：   
[一行一行源码分析清楚 AbstractQueuedSynchronizer (三)](https://javadoop.com/post/AbstractQueuedSynchronizer-3)
