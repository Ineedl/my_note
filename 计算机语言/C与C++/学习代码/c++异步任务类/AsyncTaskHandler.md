```c++
#ifndef ThreadPool_H
#define ThreadPool_H

#include <vector>
#include <queue>
#include <thread>
#include <mutex>
#include <future>
#include <functional>
#include <condition_variable>
#include <sys/prctl.h>

class AsyncTaskHandler
{
public:
    /**
     *  @param worker_size 工作线程数
     */
    explicit AsyncTaskHandler(size_t worker_size = 1);

    /**
     * @brief Join所有工作线程
     */
    ~AsyncTaskHandler();

    /**
     * @brief
     * @param func  Task执行函数
     * @param args  Task参数列表；注意，当func为类成员函数时，args第一个参数必须为该类对象指针（&object或this）
     */
    template <class Func, class... Args>
    auto add_task(Func &&func, Args &&... args) -> std::future<typename std::result_of<Func(Args...)>::type>;

    inline size_t task_size()
    {
        std::lock_guard<std::mutex> lock_guard(mutex_);
        return tasks_.size();
    }

private:
    // 停止标志为
    bool stop_;

    // 同步锁
    std::mutex mutex_;

    // 条件变量，用于通知空闲线程
    std::condition_variable cv_;

    // 工作线程容器
    std::vector<std::thread> workers_;

    // 任务队列
    std::queue<std::function<void()>> tasks_;
};

inline AsyncTaskHandler::AsyncTaskHandler(size_t worker_size) : stop_(false)
{
    for (size_t i = 0; i < worker_size; ++i)
    {
        std::string name = "worker-" + std::to_string(i);
        prctl(PR_SET_NAME,name.c_str());
        workers_.emplace_back([this]() -> void
                              {
                            
                                  while (true)
                                  {
                                      std::function<void()> task;
                                      {
                                          std::unique_lock<std::mutex> lock(this->mutex_);
                                          this->cv_.wait(lock, [this] { return this->stop_ || !this->tasks_.empty(); });
                                          if (this->stop_)
                                          {
                                              return;
                                          }
                                          task = std::move(this->tasks_.front());
                                          this->tasks_.pop();
                                      }
                                      task();
                                  }
                              });
    }
}

inline AsyncTaskHandler::~AsyncTaskHandler()
{
    {
        std::lock_guard<std::mutex> lock(mutex_);
        stop_ = true;
    }
    cv_.notify_all();
    for (auto &worker: workers_)
    {
        worker.join();
    }
}

template <class Func, class... Args>
auto AsyncTaskHandler::add_task(Func &&func, Args &&... args) -> std::future<typename std::result_of<Func(Args...)>::type>
{
    using return_type = typename std::result_of<Func(Args...)>::type;

    // make_shared可保证args在函数运行时不会失效
    auto task = std::make_shared<std::packaged_task<return_type()> >(std::bind(std::forward<Func>(func), std::forward<Args>(args)...));
    //auto task = std::make_shared<std::packaged_task<return_type()> >([func, args...]() -> return_type { return func(args...); });
    std::future<return_type> result = task->get_future();
    {
        std::unique_lock<std::mutex> lock(mutex_);

        if (stop_)
        {
            // 线程池停止时返回无效的future，可以通过future.valid()判断
            return std::future<return_type>();
        }

        tasks_.emplace([task]() { (*task)(); });
    }
    cv_.notify_one();
    return result;
}

#endif  /* ThreadPool_H */

```

