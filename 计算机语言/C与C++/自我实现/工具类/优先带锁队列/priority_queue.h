#ifndef MY_TOOLS_PRIORITY_QUEUE
#define MY_TOOLS_PRIORITY_QUEUE
#include <queue>
#include <list>

namespace my_tools{
template<typename T,bool hava_lock>
class PriorityQueue;

template<typename T>
struct PriorityQueueData{
    T data;
    int8_t priority;
};

template<typename T>
class PriorityQueue<T,false> {
public:
    void insert(T data,int priority=0);
    T front();
    void pop();
    int32_t size();
    bool empty();
    
private:
    std::list<PriorityQueueData<T> > m_list_;
};


template<typename T>
void PriorityQueue<T,false>::insert(T data,int priority){
    PriorityQueueData<T> d;
    d.data = data;
    d.priority = priority;
    if(m_list_.empty()){
        m_list_.push_back(d);
        return;
    }
    for (auto it = m_list_.begin(); it != m_list_.end(); ++it) {
        if (it->priority > priority) {
            m_list_.insert(it, d);
            break;
        }
    }
}

template<typename T>
T PriorityQueue<T,false>::front(){
    return m_list_.front().data;
}

template<typename T>
void PriorityQueue<T,false>::pop(){
    m_list_.pop_front();
}

template<typename T>
int32_t PriorityQueue<T,false>::size(){
    return m_list_.size();
}

template<typename T>
bool PriorityQueue<T,false>::empty(){
    return m_list_.empty();
}


template<typename T>
class PriorityQueue<T,true> {
public:
    void insert(T data,int priority=0);
    T front();
    void pop();
    int32_t size();
    bool empty();
    
private:
    PriorityQueue<T,false> m_list_;
    std::mutex mutex_;
};


template<typename T>
void PriorityQueue<T,true>::insert(T data,int priority){
    std::lock_guard<std::mutex> tmp(mutex_);
    m_list_.insert(data, priority);
    
}

template<typename T>
T PriorityQueue<T,true>::front(){
    std::lock_guard<std::mutex> tmp(mutex_);
    return m_list_.front();
}

template<typename T>
void PriorityQueue<T,true>::pop(){
    std::lock_guard<std::mutex> tmp(mutex_);
    m_list_.pop();
}

template<typename T>
int32_t PriorityQueue<T,true>::size(){
    std::lock_guard<std::mutex> tmp(mutex_);
    return m_list_.size();
}

template<typename T>
bool PriorityQueue<T,true>::empty(){
    std::lock_guard<std::mutex> tmp(mutex_);
    return m_list_.empty();
}
}

#endif