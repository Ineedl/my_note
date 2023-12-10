## using别名
C++11允许使用关键字using作为别名声明来定义类型的别名，其后紧跟别名和等号。作用是把等号左侧的名字规定成等号右侧类型的别名。
```c++
#include <iostream>
#include <type_traits>
using namespace std;

using uint = unsigned int;
typedef unsigned int UINT;

int main()
{
    cout << is_same<uint, UINT>::value << endl; // 1
}
```

## using模板别名
由于模板不是一个类型，所以不能定义一个typedef引用一个模板，typedef只能定义一个已规定好所有类型的模板别名，但是C++11允许使用using为类模板定义一个别名。
```c++
template <typename T> using twin = pair<T, T>;
twin<string> authors;           // authors是一个pair<string, string>

template <typename T>
using alias_map = std::map < std::string, T > ;
 
alias_map<int>  map_t;
alias_map<std::string> map_str;

```