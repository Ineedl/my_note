## nlohmaan

nlohmann JSON库是一个开源C++库，用于解析和生成JSON数据。它提供了简单易用的API，支持标准的JSON语法，包括数组、对象、字符串、数字和布尔值等。这个库被广泛应用于C++项目中处理JSON数据。

nlohmaan可以让c++开发者像在python中一样使用json格式数据。它具有以下特点

* 简单易用的API，方便开发人员使用
* 高性能的JSON解析和生成，适用于处理大量数据
* 支持C++11及以上版本的标准，并提供多种编译器支持
* 跨平台，可在多个操作系统和编译器上使用(其整个项目可以就一个hpp头文件，广泛使用了C++标准库和范型)

## 常用方法

> 将json对象转换为字符串

```c++
string_t dump(const int indent = -1,				//string_t是个范型类型，表示不同平台上的字符串类型
              const char indent_char = ' ',
              const bool ensure_ascii = false,
              const error_handler_t error_handler = error_handler_t::strict) const;
```



* `indent`：是否缩进，-1表示没有缩进，大于等于0表示n个缩进。
* `indent_char`：缩进字符，一般为`空格`
* `ensure_ascii`：如果ensure_ascii为true，输出中的所有非ASCII字符都将使用\uXXXX序列转义，并且结果仅由ASCII字符组成。
* `error_handler`：如何对解码错误作出反应;有三个可能的值，默认在发生解码错误时抛出异常。

`三种错误反应`

```c++
enum class error_handler_t {
    strict,			//在UTF-8无效的情况下抛出type_error异常
    replace,		//用U+FFFD替换无效的UTF-8序列,�即这个字符
    ignore			//忽略无效的UTF-8序列;所有字节都原封不动地复制到输出
};
```

`简单例子`

```c++
nlohmann::json root;
root["code"] = 200;
root["msg"] = "hello";
return root.dump(4);

//
//{
//    "code": 200,
//    "msg": "hello"
//}
```



> 序列化json

```c++
nlohmann::json operator "" _json(const char* s, std::size_t n);		//使用了字面量
```

`简单例子`

```c++
nlohmann::json j = "{\"happy\":true,\"pi\":3.141}"_json;
nlohmann::json j2 = R"({"happy":true,"pi":3.141})"_json;
```



> 序列化json

```c++
//using json = basic_json<>;
template<typename InputType>
static basic_json parse(InputType&& i,
                            const parser_callback_t cb = nullptr,
                            const bool allow_exceptions = true,
                            const bool ignore_comments = false)
  
template<typename IteratorType>
static basic_json parse(IteratorType first, IteratorType last,
                        const parser_callback_t cb = nullptr,
                        const bool allow_exceptions = true,
                        const bool ignore_comments = false);

//过滤回调函数
template<typename BasicJsonType>
using parser_callback_t =
    std::function<bool(int depth, parse_event_t event, BasicJsonType& parsed)>;
```

`参数解释`

* `i` ：兼容的输入类型

* `cb` ：一个回调函数，用于过滤不需要的内容。

* `allow_exceptions` ：是否在解析错误时抛出异常(可选，默认为' true ')

* `ignore_comments` ：注释是否应该被忽略并像空格一样处理(true)或产生解析错误(默认为false)

* `first` ：开始的迭代器

* `last` ：结束的迭代器

`类型解释`

* InputType类型：一个兼容的输入，例如:

  * istream对象

  * FILE指针(不能为空)

  * c风格的字符数组

  * 指向以空结束的单字节字符串的指针

  * std:: string

  * 一个对象obj，其begin(obj)和end(obj)产生一对有效的迭代器。

* IteratorType类型：一个兼容的迭代器类型，例如

  * 一对std::string::iterator或std::vector&lt;std::uint8_t&gt;::iterator

  * 一对指针，如PTR和PTR + len

`回调函数参数`

* `depth` ：json层级
* `event`：解析器当前事件
* `parsed`：当前的中间解析结果
* `返回值`：true表示过滤，false表示不过滤

```
enum class parse_event_t : std::uint8_t {
    object_start,			//解析器读取`{`并开始处理一个 JSON 对象
    object_end,				//解析器读取`}`并完成处理一个 JSON 对象
    array_start,			//解析器读取`[`并开始处理一个 JSON 数组
    array_end,				//解析器读取`]`并完成处理一个 JSON 数组
    key,							//解析器读取对象中值的键
    value							//解析器完成读取 JSON 值
};
```

* 回调调用时6种情况

| 当前`event`范围               | 描述                                  | `depth`此时意义            | `parsed`此时意义       |
| :---------------------------- | :------------------------------------ | :------------------------- | :--------------------- |
| `parse_event_t::object_start` | 解析器读取`{`并开始处理 JSON 对象     | JSON 对象父对象的层级      | 类型被丢弃的 JSON 值   |
| `parse_event_t::key`          | 解析器读取对象中值的键                | 当前解析的 JSON 对象的层级 | 包含密钥的 JSON 字符串 |
| `parse_event_t::object_end`   | 解析器读取`}`并完成处理一个 JSON 对象 | JSON 对象父对象的层级      | 解析的 JSON 对象       |
| `parse_event_t::array_start`  | 解析器读取`[`并开始处理 JSON 数组     | JSON 数组父级的层级        | 类型被丢弃的 JSON 值   |
| `parse_event_t::array_end`    | 解析器读取`]`并完成处理一个 JSON 数组 | JSON 数组父级的层级        | 解析后的 JSON 数组     |
| `parse_event_t::value`        | 解析器完成读取 JSON 值                | 该值的层级                 | 解析的 JSON 值         |



`简单例子`

```c++
//反序列化
std::string s = "{\"happy\":true,\"pi\":3.141}";
auto j = json::parse(s.toStdString().c_str());
std::cout << j.at("pi") << std::endl; // 输出：3.141



//回调的使用
#include <iostream>
#include <iomanip>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

int main()
{
    // a JSON text
    auto text = R"(
    {
        "Image": {
            "Width":  800,
            "Height": 600,
            "Title":  "View from 15th Floor",
            "Thumbnail": {
                "Url":    "http://www.example.com/image/481989943",
                "Height": 125,
                "Width":  100
            },
            "Animated" : false,
            "IDs": [116, 943, 234, 38793]
        }
    }
    )";

    // parse and serialize JSON
    json j_complete = json::parse(text);
    std::cout << std::setw(4) << j_complete << "\n\n";


    // define parser callback
    json::parser_callback_t cb = [](int depth, json::parse_event_t event, json & parsed)
    {
        // skip object elements with key "Thumbnail"
        if (event == json::parse_event_t::key and parsed == json("Thumbnail"))
        {
            return false;
        }
        else
        {
            return true;
        }
    };

    // parse (with callback) and serialize JSON
    json j_filtered = json::parse(text, cb);
  	std::cout<<j_filtered.dump(4);
}

//解析后
{
    "Image": {
        "Animated": false,
        "Height": 600,
        "IDs": [
            116,
            943,
            234,
            38793
        ],
        "Title": "View from 15th Floor",
        "Width": 800
    }
}
```



> 获取json中的值

```c++
reference at(const typename object_t::key_type& key);		//reference表示一个引用类型
```

* 该函数可以循环调用
* 该函数将会根据原json中value的类型来自动转型类型

`例子`

```c++
//{
//  "pi": 3.141,
//  "happy": true,
//  "name": "Niels",
//  "nothing": null,
//  "answer": {
//    	"everything": 42
//  },
//  "list": [1, 0, 2],
//  "object": {
//	    "currency": "USD",
// 	    "value": 42.99
//  }
//}


float pi = j.at("pi");
std::string name = j.at("name");
int everything = j.at("answer").at("everything");
std::cout << pi << std::endl; // 输出: 3.141
std::cout << name << std::endl; // 输出: Niels
std::cout << everything << std::endl; // 输出: 42
// 打印"list"数组
for(int i=0; i<3; i++)
	std::cout << j.at("list").at(i) << std::endl;
// 打印"object"对象中的元素
std::cout << j.at("object").at("currency") << std::endl; // 输出: USD
std::cout << j.at("object").at("value") << std::endl; // 输出: 42.99
```



> \>\>和\<\<重载

* 两种重载可以让json对象序列化后以流的方式写入某个流或者从某个流读入字符串后反序列化为json
* 这种方式也可以直接将json对象转为文件

`例子`

```c++
//标准io相关
json j;
std::cin >> j; // 从标准输入中反序列化json对象
std::cout << j; // 将json对象序列化到标准输出中

// 读取一个json文件，nlohmann会自动解析其中数据
std::ifstream i("file.json");
json j;
i >> j;

// 以易于查看的方式将json对象写入到本地文件
std::ofstream o("pretty.json");
o << std::setw(4) << j << std::endl;
```



> []重载

```c++
template<typename T>
reference operator[](T* key)			//reference表示一个引用类型
```

该函数可以让nlohmann任意容易的构造json

`例子`

```c++
//nlohmann可以按照以下的方式随心所欲的构造json
json j; // 首先创建一个空的json对象
j["pi"] = 3.141;
j["happy"] = true;
j["name"] = "Niels";
j["nothing"] = nullptr;
j["answer"]["everything"] = 42; // 初始化answer对象
j["list"] = { 1, 0, 2 }; // 使用列表初始化的方法对"list"数组初始化
j["object"] = { {"currency", "USD"}, {"value", 42.99} }; // 初始化object对象

json t6;
t6["t8"]=1
t6["t9"]=2
j["t6"]=t6

{
  "pi": 3.141,
  "happy": true,
  "name": "Niels",
  "nothing": null,
  "answer": {
    	"everything": 42
  },
  "list": [1, 0, 2],
  "object": {
	    "currency": "USD",
 	    "value": 42.99
  },
  "t6":{
  		"t8":1,
  		"t9":2
  }
}
```



> 任意类型的转换

```c++
//原函数太复杂就不列举了
//简单易懂形式
<wantType> get<wantType>();
```

`例子`

```c++
namespace ns {
    // 首先定义一个结构体
    struct person {
        std::string name;
        std::string address;
        int age;
    };
}

ns::person p = {"Ned Flanders", "744 Evergreen Terrace", 60}; // 定义初始化p

// 从结构体转换到json对象
json j;
j["name"] = p.name;
j["address"] = p.address;
j["age"] = p.age;

// 从json对象转换到结构体
ns::person p {
    j["name"].get<std::string>(),
    j["address"].get<std::string>(),
    j["age"].get<int>()
};
```

`结构体类型json转换`

* 只需要在要序列化和反序列化的结构体所在的命名空间下，定义函数`to_json()`和`from_json()`就可以轻松的完成任意类型到 json 对象的转换，以及 json 转换为任意对象。

```c++
using nlohmann::json;

namespace ns {
    // 首先定义一个结构体
    struct person {
        std::string name;
        std::string address;
        int age;
    };
}

namespace ns {
    void to_json(json& j, const person& p) {
        j = json{{"name", p.name}, {"address", p.address}, {"age", p.age}};
    }

    void from_json(const json& j, person& p) {
        p.name = j.at("name");
        p.address = j.at("address");
        p.age = j.at("age");
    }
} // namespace ns

ns::person p {"Ned Flanders", "744 Evergreen Terrace", 60};
json j = p;
std::cout << j << std::endl;
// {"address":"744 Evergreen Terrace","age":60,"name":"Ned Flanders"}

// conversion: json -> person
auto p2 = j.get<ns::person>();
```

