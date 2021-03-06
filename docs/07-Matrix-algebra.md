# Statistician Tool Box

## Matrix algebra {#matrix}
\BeginKnitrBlock{definition}<div class="definition"><span class="definition" id="def:unnamed-chunk-1"><strong>(\#def:unnamed-chunk-1) </strong></span>定义：矩阵$A(t)$的导数
如果矩阵$A(t)=\left(a_{i j}(t)\right)_{m \times n}$ 的每一个元素$a_{ij}(t)$是变量t的可微函数，则称A(t)可微，其导数（微商）定义为
$$
A^{\prime}(t)=\frac{\mathrm{d}}{\mathrm{d} t} A(t)=\left(\frac{\mathrm{d}}{\mathrm{d} t} a_{i j}(t)\right)_{m \times n}
$$</div>\EndKnitrBlock{definition}

\BeginKnitrBlock{definition}<div class="definition"><span class="definition" id="def:unnamed-chunk-2"><strong>(\#def:unnamed-chunk-2) </strong></span>定义：矩阵对矩阵的导数
设 $\boldsymbol{X}=\left(\xi_{i j}\right)_{m \times n}$, $mn$ 元函数 $f(\boldsymbol{X})=f\left(\xi_{11}, \xi_{12}\cdots, \xi_{1 n}, \xi_{21}, \cdots, \xi_{m n} )\right.$,定义$f(X)$ 对矩阵$X$的导数为

\begin{equation}
\frac{\mathrm{d} f}{\mathrm{d} \boldsymbol{X}}=\left(\frac{\partial f}{\partial \xi_{i j}}\right)_{m \times n}=
\left[
 \begin{array}{ccc}
{\frac{\partial f}{\partial \xi_{11}}} 
& {\dots} & {\frac{\partial f}{\partial \xi_{1 n}}}
 \\ {\vdots} & { } & {\vdots} \\ 
{\frac{\partial f}{\partial \xi_{m 1}}} & {\cdots} & {\frac{\partial f}{\partial \xi_{m n}}}

\end{array}\right]
\end{equation}</div>\EndKnitrBlock{definition}
根据这个定义，能够直接证明以下两个最常见的结论
$$
\frac{\partial x'a}{\partial x}=a=\frac{\partial a'x}{\partial x}
$$

$$
\frac{\partial x'Ax}{\partial x}=(A+A')x
$$

证明：
将矩阵乘法$x^TAx$打开得到
$$
\begin{aligned} f(\boldsymbol{x})=& \sum_{i=1}^{n} \sum_{j=1}^{n} a_{i j} \xi_{i} \xi_{j}=\\ & \xi_{1} \sum_{j=1}^{n} a_{1 j} \xi_{j}+\cdots+\xi_{k} \sum_{j=1}^{n} a_{k j} \xi_{j}+\cdots+\xi_{n} \sum_{j=1}^{n} a_{n j} \xi_{j} \end{aligned}
$$
且有
$$
\begin{align}
\frac{\partial f}{\partial \xi_{k}}=\xi_{1} a_{1 k}+\cdots+\xi_{k-1} a_{k-1, k}+\left(\sum_{j=1}^{n} a_{k j} \xi_{j}+\xi_{k} a_{k k}\right)+\\
\xi_{k+1} a_{k+1, k}+\cdots+\xi_{n} a_{\# k}=\sum_{j=1}^{n} a_{i j} \xi_{j}+\sum_{i=1}^{n} a_{k} \xi_{i}
\end{align}
$$
所以有
$$
\frac{d f}{d x}=\left[ \begin{array}{c}{\frac{\partial f}{\partial \xi_{1}}} \\ {\vdots} \\ {\frac{\partial f}{\partial \xi_{n}}}\end{array}\right]=\left[ \begin{array}{c}{\sum_{j=1}^{n} a_{1 j} \xi_{j}} \\ {\vdots} \\ {\sum_{j=1}^{n} a_{n j} \xi_{j}}\end{array}\right]+\left[ \begin{array}{c}{\sum_{i=1}^{n} a_{i 1} \xi_{i}} \\ {\vdots} \\ {\sum_{i=1}^{n} a_{i n} \xi_{i}}\end{array}\right]=\\ 
\boldsymbol{A x}+\boldsymbol{A}^{\mathrm{T}} \boldsymbol{x}=\left(\boldsymbol{A}+\boldsymbol{A}^{\mathrm{T}}\right) \boldsymbol{x}
$$

### Block diagonal matrices

$$
\mathbf{A}=\left[ \begin{array}{cccc}{\mathbf{A}_{1}} & {0} & {\cdots} & {0} \\ {0} & {\mathbf{A}_{2}} & {\cdots} & {0} \\ {\vdots} & {\vdots} & {\ddots} & {\vdots} \\ {0} & {0} & {\cdots} & {\mathbf{A}_{n}}\end{array}\right]
$$

property:
$$
\begin{aligned} \operatorname{det} \mathbf{A} &=\operatorname{det} \mathbf{A}_{1} \times \cdots \times \operatorname{det} \mathbf{A}_{n} \\ \operatorname{tr} \mathbf{A} &=\operatorname{tr} \mathbf{A}_{1}+\cdots+\operatorname{tr} \mathbf{A}_{n} \end{aligned}
$$

It's inverse:

$$
\left( \begin{array}{cccc}{\mathbf{A}_{1}} & {0} & {\cdots} & {0} \\ {0} & {\mathbf{A}_{2}} & {\cdots} & {0} \\ {\vdots} & {\vdots} & {\ddots} & {\vdots} \\ {0} & {0} & {\cdots} & {\mathbf{A}_{n}}\end{array}\right)=\left( \begin{array}{cccc}{\mathbf{A}_{1}^{-1}} & {0} & {\cdots} & {0} \\ {0} & {\mathbf{A}_{2}^{-1}} & {\cdots} & {0} \\ {\vdots} & {\vdots} & {\ddots} & {\vdots} \\ {0} & {0} & {\cdots} & {\mathbf{A}_{n}^{-1}}\end{array}\right)
$$


## 两个二次型相加 {#sumSquare}

In vector formulation(Assuming $\Sigma_1$,$\Sigma_2$ are symmetric)
有：
$$
\begin{array}{c}{-\frac{1}{2}\left(\mathbf{x}-\mathbf{m}_{1}\right)^{T} \mathbf{\Sigma}_{1}^{-1}\left(\mathbf{x}-\mathbf{m}_{1}\right)} \\ {-\frac{1}{2}\left(\mathbf{x}-\mathbf{m}_{2}\right)^{T} \mathbf{\Sigma}_{2}^{-1}\left(\mathbf{x}-\mathbf{m}_{2}\right)} \\ {=-\frac{1}{2}\left(\mathbf{x}-\mathbf{m}_{c}\right)^{T} \mathbf{\Sigma}_{c}^{-1}\left(\mathbf{x}-\mathbf{m}_{c}\right)+C}\end{array}
$$
其中：
$$
\begin{aligned} \mathbf{\Sigma}_{c}^{-1}=& \mathbf{\Sigma}_{1}^{-1}+\mathbf{\Sigma}_{2}^{-1} \\ \mathbf{m}_{c} &=\left(\mathbf{\Sigma}_{1}^{-1}+\mathbf{\Sigma}_{2}^{-1}\right)^{-1}\left(\mathbf{\Sigma}_{1}^{-1} \mathbf{m}_{1}+\mathbf{\Sigma}_{2}^{-1} \mathbf{m}_{2}\right) \\ C &=\frac{1}{2}\left(\mathbf{m}_{1}^{T} \mathbf{\Sigma}_{1}^{-1}+\mathbf{m}_{2}^{T} \mathbf{\Sigma}_{2}^{-1}\right)\left(\mathbf{\Sigma}_{1}^{-1}+\mathbf{\Sigma}_{2}^{-1}\right)^{-1}\left(\mathbf{\Sigma}_{1}^{-1} \mathbf{m}_{1}+\mathbf{\Sigma}_{2}^{-1} \mathbf{m}_{2}\right) \\ &-\frac{1}{2}\left(\mathbf{m}_{1}^{T} \mathbf{\Sigma}_{1}^{-1} \mathbf{m}_{1}+\mathbf{m}_{2}^{T} \mathbf{\Sigma}_{2}^{-1} \mathbf{m}_{2}\right) \end{aligned}
$$


而对于我需要的情况，简化$m_1=0$,$m_2=0$

那么就有，只需要$\mathbf{\Sigma}_{c}^{-1}=\mathbf{\Sigma}_{1}^{-1}+\mathbf{\Sigma}_{2}^{-1}$,同时$m_c=0$.






