## sizeof新增
c++11后sizeof可以使用在成员上，而不需要类的对象

```
struct A {
    int data[10];
    int a;
};

int main() {
    cout << "size " << sizeof(A::data) << endl;
    return 0;
}
``