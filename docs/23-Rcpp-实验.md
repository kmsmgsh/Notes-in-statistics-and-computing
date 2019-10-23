# Rcpp

根据实验，见jmcmBoost项目里面的试验，代码是：
```
// [[Rcpp::export]]
void ReceiveAlist(Rcpp::List theta0)
{
  double beta0=Rcpp::as<double>(theta0["beta"]);
  double gamma0=Rcpp::as<double>(theta0["gamma"]);
  double xi0=Rcpp::as<double>(theta0["xi"]);
  cout<<beta0<<endl;
    cout<<gamma0<<endl;
      cout<<xi0<<endl;
}


/*** R
ReceiveAlist(list(beta=c(0,1),gamma=c(1,1),xi=c(1,2)))
ReceiveAlist(list(beta=1,gamma=1,xi=1))
*/
```
第一个报错，第二个可以正确输出。
因为as<double>的数据类型必须是一个scala，不能给一个Numeric Vector
所以问题是如何把这个转换成一个c++的变量

```
Sys.setenv("PKG_CXXFLAGS"="-std=c++11")
```
要用auto打印std::vector的话得这样，是c++11标准

理论上应该是用一个c++的STL的vector容器来搞
为啥那本书里面没有，好奇怪
所以进过谷歌,stackexchange的[问题](https://stackoverflow.com/questions/37328978/convert-rvector-to-stdvector) 所以解决方案是::
```
 std::vector<double> b = as<std::vector<double> >(a)
```
于是代码就改成如下：
```
void ReceiveAlist(Rcpp::List theta0)
{
  std::vector<double> beta= Rcpp::as<std::vector<double> >(theta0["beta"]);
  //double beta0=Rcpp::as<double>(theta0["beta"]);
  std::vector<double> gamma= Rcpp::as<std::vector<double> >(theta0["gamma"]);
  //double gamma0=Rcpp::as<double>(theta0["gamma"]);
  std::vector<double> xi= Rcpp::as<std::vector<double> >(theta0["xi"]);
  //double xi0=Rcpp::as<double>(theta0["xi"]);
  //cout<<beta0<<endl;
    //cout<<gamma0<<endl;
    //  cout<<xi0<<endl;
      for (auto i: beta)
        std::cout << i << ' ';
      std::cout<<endl;
      for (auto i: gamma)
        std::cout << i << ' ';
      std::cout<<endl;
      for (auto i: xi)
        std::cout << i << ' ';
      std::cout<<endl;
}
```
然后结合之前的

```
Rcpp::List Jmcmoutput2(NumericVector x){
    Rcpp::List a=Rcpp::List::create( // with static names
    Rcpp::CharacterVector::create("cc", "dd"),
    Rcpp::CharacterVector::create("ee", "ff")
  );
  
  double cc=0;
  Rcpp::NumericVector a0=x[1];
  double a2= Rcpp::as<double>(a0);
  return Rcpp::List::create(Rcpp::Named("beta")   = Rcpp::wrap(cc),
                            Rcpp::Named("gamma")   = Rcpp::wrap(a2),
                            Rcpp::Named("lambda")   = x
                            );
}
```

这就能返回一个R的数据结构list，接口的问题就基本上解决了。

## 一个R操作对应的armadillo操作的文档：

https://github.com/petewerner/misc/wiki/RcppArmadillo-cheatsheet#cbind_mat

- rbind/cbind，由vector组成matrix：

cbind:

```
//[[Rcpp::export]]
arma::mat armadillo_joint_rows_test(arma::vec x1,arma::vec x2)
{
  return arma::join_rows(x1,x2);
}
```

rbind
```
//[[Rcpp::export]]
arma::mat armadillo_joint_cols_test(arma::vec x1,arma::vec x2)
{
  return arma::join_cols(x1,x2);
}
```
值得注意的是这两个函数的r和c是反的，大概是bind函数是把"row"bind或者把"column"bind,而join函数是把内容以"row"或者"column"方向进行join。


- c++中用引用的一个坑

---------------

引用在定义时必须初始化，否则编译时便会报错。如果类（自定义类型）的成员是引用类型，需要注意一些问题。

不能有默认构造函数，必须提供构造函数
凡是有引用类型的成员变量的类，不能有缺省构造函数。默认构造函数没有对引用成员提供默认的初始化机制，也因此造成引用未初始化的编译错误。

构造函数的形参必须为引用类型
暂时还不知道该怎么解释，牵涉到引用的机制。

初始化必须在成员初始化链表内完成
不能直接在构造函数里初始化，必须用到初始化列表，且形参也必须是引用类型。构造函数分为初始化和计算两个阶段，前者对应成员初始化链表，后者对应构造函数函数体。引用必须在初始化阶段，也即在成员初始化链表中完成，否则编译时会报错（引用未初始化）。

--------------------- 
上面那段话来自：
版权声明：本文为CSDN博主「lazyq7」的原创文章，遵循CC 4.0 by-sa版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/lazyq7/article/details/48186291




-----------------

开发记录之抽象类和子类实现。
对c++版的BayesJMCM的解析
类jmcm_evaluator里面对抽象类prior的引用是写成
```
class prior& prior_beta
```
是一个引用。
在测试文档中，如果使用统一的初始化函数，则会出现class prior的子类的实现mvn_prior的作用域只是在初始化函数内部，所以，返回jmcm_mcd_evaluator的实例中，就不包括prior的实例。
则这个引用绑定的类实例，在当初始化函数返回以后就被释放了，所以引用就失效了。这时候再调用这个引用，r就崩溃了。
所以在接口函数里面，得手动初始化prior然后保留实例。



