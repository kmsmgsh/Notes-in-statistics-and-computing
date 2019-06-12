# Numeric Derivatives

Compute $f'(x)$, definition of the derivative, the limit as $h\rightarrow 0$ of
$$
f^{\prime}(x) \approx \frac{f(x+h)-f(x)}{h}
$$

The above procedure is almost guaranteed to produce inaccurate results. When the function $f$ is **fiercely** expensive to compute.

There are two sources of error  in this approach truncation error and roundoff error.

The truncation error comes from higher terms in the Taylor series expansion:

$$
f(x+h)=f(x)+h f^{\prime}(x)+\frac{1}{2} h^{2} f^{\prime \prime}(x)+\frac{1}{6} h^{3} f^{\prime \prime \prime}(x)+\cdots
$$

whence 

$$
\frac{f(x+h)-f(x)}{h}=f^{\prime}+\frac{1}{2} h f^{\prime \prime}+\cdots
$$

The roundoff error has various contributions. First is in $h$: 
Suppose, by way ofo an example, that you are at a point $x=10.3$ and you blindly choose $h=0.0001$. Neither $x=10.3$ nor $x+h=10.30001$ is a number with an exact representation in binary; each is therefore represented with some fractional error characteristic of the machine's floating-point format, $\epsilon_m$, whose value in single precision may be $\sim 10^{-7}$. The error in the **effective** value of h, namely the difference between $x+h$ and $x$ as represented in the machine, is therefore on the order of $\epsilon_m x$, which implies a fractional error in h of order $\sim \epsilon_mx/h\sim10^{-2}$! By equation, this immediately implies at least the same large fractional error in the derivative.

> roundoff error: 舍入误差。假设点x=10.3,然后选取h=0.0001,但是在计算机里保存的既不是x=10.3也不是x+h=10.30001,每个数都会表示成另外一个有相对误差的，相对误差则由计算机的浮点格式,$\epsilon_m$，所决定，单精度浮点数则在$10^{-7}$. 在h有效值的误差，也就是x+h和x在计算机中表现的值的误差，则其阶为$\epsilon_m x$,这个表明了h的相对误差的阶是$\sim \epsilon_m x/h\sim 10^{-2}$ ,就很高。


这样，第一课就是，总选择h使得x+h和x的差是一个确定的表示数，this can usually be accomplished by the program steps:

```
temp=x+h
h=temp-x
```



