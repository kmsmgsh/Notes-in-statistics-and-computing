# Guide to Scientific Computing in C++


## Basics

- first compile in command line:
`g++ -o HelloWorld HelloWorld.cpp`
也可以直接编译HelloWorld.cpp,默认的输出名字是a.out
```
g++ HelloWorld.cpp
```

- compile flag:
让编译器保留debug信息，然后不优化代码，这样能进行debug，用“-g” flag
```
g++ -g -o HelloWorld HelloWorld.cpp
```

让编译器链接library
```
g++ -lm -o HelloWorld HelloWorld.cpp
```

## Basics in C++

Assert语句进行简单的error抛出：

```
#include <iostream> #include <cassert> #include <cmath>
int main(int argc, char * argv[]) {
  double a; std::cout << "Enter a non-negative number\n"; 
  std::cin >> a; assert(a >= 0.0); 
  std::cout << "The square root of "<< a; 
  std::cout << " is " << sqrt(a) << "\n"; 
  return 0;
}
```


## Redirect Console Output to File

- Require additional header file `fstream`: include
- Declare an output stream variable `write_output` as `std::ofstream` 
- Specify filename `Output.dat` 
- Check the file is opened successfully: use assert
- Use `write_output` instead of `std::cout` : 
- Close the file handle.

In order to finish these job, the code is

```
#include <cassert> 
#include <iostream> 
#include <fstream>
int main(int argc, char * argv[]) {
  double x[3] = {0.0, 1.0, 0.0}; 
  double y[3] = {0.0, 0.0, 1.0}; 
  std::ofstream write_output("Output.dat"); 
  assert(write_output.is_open()); 
  for (int i=0; i<3; i++) { 
  write_output << x[i] << " " << y[i] << "\n"; 
  } 
  write_output.close(); 
  return 0;
}
```

In scientific computing, the precision is crucial, they can be set as:

```
#include <iostream> 
#include <fstream>

int main(int argc, char * argv[])
{
  double x = 1.8364238; std::ofstream write_output("Output.dat"); 
  write_output.precision(3); // 3 sig figs 
  write_output << x << "\n"; 

  write_output.precision(5); // 5 sig figs 
  write_output << x << "\n"; 

  write_output.precision(10); // 10 sig figs 
  write_output << x << "\n"; 

  write_output.close(); 
  return 0;
}
```

It's similar for read file in stream with cout, just change `cout` to `std::ifstream read_file`.

The example code in the book is:
```
#include <cassert> 
#include <iostream> #include <fstream>

int main(int argc, char * argv[]) 
{
  double x[6], y[6]; 
  std::ifstream read_file("Output.dat"); 
  assert(read_file.is_open()); 
  for (int i=0; i<6; i++) 
  { 
    read_file >> x[i] >> y[i]; 
  } 
  read_file.close(); 
  return 0;
}

```

This is the simplest code that just loop the given length as 6, we want read until it is end. Then we need write until get `read_file.oef()`, so we use while instead of for.
```
while(!read_file.oef())
```


### Reading from the Command Line

感觉这是命令行管道的东西的感觉。

User want to set some parameters when executing the code.

Remind of the definition of main function
```
int main(int argc, char * argv[])
```
The argc and argv function will be used to finish this purpose.

- Addition header `filecstdlib` and function `atoi` and `atof` will be sued.

```
#include <iostream> 
#include <cstdlib>
int main(int argc, char *argv[]) 
{
  std::cout << "Number of command line arguments = " << argc << "\n"; 
  for (int i=0; i<argc; i++) 
  {
    std::cout << "Argument " << i << " = " << argv[i];
    std::cout << "\n"; 
  }
  std::string program_name = argv[0];
  int number_of_nodes = atoi(argv[1]); 
  double conductivity = atof(argv[2]); 
  std::cout << "Program name = " << program_name << "\n"; 
  std::cout << "Number of nodes = " << number_of_nodes; 
  std::cout << "\n"; 
  std::cout << "Conductivity = " << conductivity << "\n";
  return 0;
}
```


运行如上程序
```
./CommandLineCode 100 5.0
```
在这个函数里，那一整行命令行的东西都作为参数被参数argv传进去了。而argc是统计有多少个分割的元素

## Pointer

- Pointer Aliasing  注意同一块区域操作，比如A=A*B（都是矩阵）时，如果直接算会出问题，因为算后面的会依赖前面的值。

- Safe Dynamic allocation: 可能会出现没有足够多的内存进行分配，要么是因为数组下标越界或者为负数，要么是因为没有足够多的物理内存。可以通过抛出异常
```
double *p_x;
p_x=new double[10000];
assert(p_x!=NULL)
```
进行检测。

- Every new Has a delete
在动态分配内存的时候要注意，所有分配的内存都需要被释放。当在循环内部使用动态分配内存的时候，这个问题尤其值得注意。比如：
```
for (int i=0; i<10000; i++) 
{ 
  double ** A; 
  A = new double * [50]; 
  for (int j=0; j<50; j++) 
  {
    A[j] = new double [50]; 
  } 
}
```
这样每次运行这样的代码，新的内存就会被分配。但是不会释放。于是每次运行这段程序，就有一块内存不再可用。如果没有垃圾处理机制的话，内存就会很快被占满。

## Functions

### Use of Pointers as function arguments.

100页完成。明天继续100页看完。


## Classess

### Header Files

应该对引入头文件非常小心。如果include了多次会造成问题。特别是在多个cpp文件上工作时，不经意间就会造成一些问题。为了防止多次included，需要如下的代码：
如果没有被定义，则定义。也就是加一个if语句
使用宏`#ifndef`如果没有被定义，然后通过`#endif`结束：
```
#ifndef EXAMPLECLASSHEADERDEF // only if macro
                              // EXAMPLECLASSHEADERDEF not
                              // defined execute lines of 
                              // code until #endif 
                              // statement

#define EXAMPLECLASSHEADERDEF // define the macro 
                              // EXAMPLECLASSHEADERDEF.
                              // Ensures that this code is 
                              // only compiled once, no 
                              // matter how many times it 
                              // is included 
class ExampleClass 
{ 
  lines of code // 
  body of header file 
};
#endif // need one of these for every #ifndef statement

```



## Using Makefiles to Compile Multiple Files
P94 of *Guide to Scientific Computing in C++*

目的：We would rather not compile all of these classes separately every time one file is modified slightly.



```
Class1.o : Class1.cpp Class1.hpp
        g++ -c -O Class1.cpp

Class1.o : Class1.cpp Class1.hpp 
          g++ -c -O Class1.cpp 
Class2.o : Class2.cpp Class2.hpp
          g++ -c -O Class2.cpp 
UseClasses.o : UseClasses.cpp Class1.hpp Class2.hpp
          g++ -c -O UseClasses.cpp 
UseClasses : Class1.o Class2.o UseClasses.o
          g++ -O -o UseClasses Class1.o Class2.o UseClasses.o
```

定义一个类：
```
#ifndef COMPLEXNUMBERHEADERDEF 
#define COMPLEXNUMBERHEADERDEF
//>>>>>如果没定义的话，就定义
#include <iostream>

class ComplexNumber { 
private:
  double mRealPart; 
  //real part
  double mImaginaryPart; 
  //imaginary part大概是虚数部分？
public:
  ComplexNumber(); //初始化函数，让实部和虚部为0
  ComplexNumber(double x, double y); 
  double CalculateModulus() const; // 返回一个双精度浮点数包含了这个复数的模
  double CalculateArgument() const;// 
  ComplexNumber CalculatePower(double n) const; 
  ComplexNumber& operator=(const ComplexNumber& z); //这个是&的要注意，做了运算符重载？
  ComplexNumber operator-() const; 
  ComplexNumber operator+(const ComplexNumber& z) const; 
  ComplexNumber operator-(const ComplexNumber& z) const; 
  friend std::ostream& operator<<(std::ostream& output, 
                                  const ComplexNumber& z);

}; 

#endif
```



一个新的东西：

```
ComplexNumber& ComplexNumber::
               operator=(const ComplexNumber& z)
{
    mRealPart = z.mRealPart; 
    mImaginaryPart = z.mImaginaryPart; 
    return * this;
}
```
这里面出现了两个&，需要看一眼是啥意思：
这里是运算符重载，重载了"="运算符
用了 const 保证这个赋值时是拷贝而不是alter重名
所以返回的是这个类自己的地址。
然后因为是赋值，所以指向了给定值，然后给了一个const，所以不会被改变。
下面的"-"的重载就没用取地址和指针，这个“-”是取符号不是“减”。
```
ComplexNumber ComplexNumber::operator-() const 
{
  ComplexNumber w;
  w.mRealPart = -mRealPart;
  w.mImaginaryPart = -mImaginaryPart;
  return w; 
}
```
然后
是加运算符
```
// Overloading the binary + operator 
ComplexNumber ComplexNumber::operator+(const ComplexNumber& z) const 
{
    ComplexNumber w;
    w.mRealPart = mRealPart + z.mRealPart;
    w.mImaginaryPart = mImaginaryPart + z.mImaginaryPart;
    return w; 
}
```
这里的参数又用了const ComplexNumber& z
Point &pt2=pt1; 定义了pt2为pt1的引用。通过这样的定义，pt1和pt2表示同一对象。
所以大部分都是引用的感觉。。。

所以上面是引用了z，所以是z的正常调用（而且不能更改z），然后把值丢到一个新的w里面。
这叫常引用，可以不开辟新的内存空间，而又不会影响原值。

## 类的继承

```
#ifndef EBOOKHEADERDEF 
#define EBOOKHEADERDEF

#include <string> 
#include "Book.hpp" 
class Ebook: public Book 
{ 
public:
  Ebook();
  std::string hiddenUrl; 
}; 
#endif
```

这是继承的基础语法
新的东西是覆盖了初始构造函数的新构造函数Ebook()，和一个std::string的类成员hiddenUrl.

[三种继承的解释](https://www.cnblogs.com/qlwy/archive/2011/08/25/2153584.html)


### 继承类的实时多态 Run-Time Polymorphism



```
#ifndef GUESTDEF 
#define GUESTDEF

#include <string>

class Guest 
{ 
public:
  std::string name, roomType, arrivalDate;
  int numberOfNights;
  double telephoneBill;
  virtual double CalculateBill(); 
 };

#endif

```

关注点在virtual关键字，是告诉编译器这个方法可能被继承的类覆盖了。
这就是虚函数了。。

## 模板


[函数返回引用和返回值的区别](https://www.cnblogs.com/JMLiu/p/7928425.html)，关键就是有没有多搞一个零时变量。


一个简单的模板的例子:

```
#include <iostream>

template<class T> T GetMaximum(T number1, T number2); 

int main(int argc, char * argv[])
{ 
    std::cout << GetMaximum<int>(10, -2) << "\n"; 
    std::cout << GetMaximum<double>(-4.6, 3.5) << "\n"; return 0; 
}

template<class T> T GetMaximum(T number1, T number2) 
{ 
    T result; 
    if (number1 > number2) 
    { 
        result = number1; 
    } 
    else 
    { 
        //number1 <= number2 
        result = number2; 
    }
    return result;
}
```
相当于T是占位符，然后使用的时候用尖括号<>把类型告诉程序。



### Brief Survey of the Standard Template Library

#### Vector 

## Class for linear algebra

每个new 需要匹配一个 delete.









