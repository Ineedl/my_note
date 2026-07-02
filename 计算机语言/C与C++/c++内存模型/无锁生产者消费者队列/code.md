```c++
//适用于单消费者和单生产者
#include <atomic>

template<typename T, size_t N>
class SPSCQueue {
public:
    bool push(const T& value) {
        size_t t = tail.load(std::memory_order_relaxed);
        size_t next = (t + 1) % N;

        // 读取 head，判断是否满
        if (next == head.load(std::memory_order_acquire))
            return false;

        buffer[t] = value;

        // 发布数据
        tail.store(next, std::memory_order_release);

        return true;
    }

    bool pop(T& value) {
        size_t h = head.load(std::memory_order_relaxed);

        // 判断是否为空
        if (h == tail.load(std::memory_order_acquire))
            return false;

        value = buffer[h];

        // 告诉生产者当前位置已经消费
        head.store((h + 1) % N, std::memory_order_release);

        return true;
    }

private:
    T buffer[N];

    std::atomic<size_t> head{0};
    std::atomic<size_t> tail{0};
};
```

* 判空/判满和消费/生产不使用 std::memory_order_acquire/std::memory_order_release 而使用 std::memory_order_relaxed 会造成的后果

  * ```
    value = buffer[h];
    buffer[t] = value;
    这些操作会被重排到 判空/判满和消费/生产 代码的前后，导致另外一个线程在实际逻辑执行前被重排后的逻辑误导
    ```

  * ```
    value = buffer[h];
    这里buffer里的数据可能还是缓存中的脏数据
    ```

* SPSCQueue 不是因为 release/acquire “保护了buffer，而是因为它本身避免了 data race，release/acquire 只是用来建立“可见性顺序”。buffer都是在head和tail两个原子变量判断后进行操作的。