# Bayes variable selection

The model uncertainty problem with the $2^p$ competing models:
 
$$
M_{\gamma} : \boldsymbol{y}=\alpha \mathbf{1}_{n}+\boldsymbol{X}_{\gamma} \boldsymbol{\beta}_{\gamma}+\boldsymbol{\varepsilon}
$$
 
The Null model:

$$
M_{0} : y=\alpha 1_{n}+\varepsilon
$$


Assuming that one of the models in $\mathcal M$ is the true model, the posterior probability of any model is
$$
\operatorname{Pr}\left(M_{\gamma^{*}} | \boldsymbol{y}\right)=\frac{m_{\gamma *}(\boldsymbol{y}) \operatorname{Pr}\left(M_{\gamma^{*}}\right)}{\sum_{\gamma} m_{\gamma}(\boldsymbol{y}) \operatorname{Pr}\left(M_{\gamma}\right)}
$$
where $Pr(M_\gamma)$ is the prior probability of $M_\gamma$ and $m_\gamma$ is the integrated likelihood with respect to the prior $\pi_\gamma$:
$$
m_{\gamma}(\boldsymbol{y})=\int f_{\gamma}\left(\boldsymbol{y} | \boldsymbol{\beta}_{\gamma}, \alpha, \sigma\right) \pi_{\gamma}\left(\boldsymbol{\beta}_{\gamma}, \alpha, \sigma^{2}\right) d \boldsymbol{\beta}_{\gamma} d \alpha d \sigma^{2}
$$
也就是把所有不确定因素积掉以后，y的分布函数,also called the (prior) marginal likelihood.

For $\gamma=0$ this integrated lkelihood becomes:

$$
m_{0}(\boldsymbol{y})=\int f_{0}(\boldsymbol{y} | \alpha, \sigma) \pi_{0}\left(\alpha, \sigma^{2}\right) d \alpha d \sigma^{2}
$$

可以用Bayes factor替换 integrated likelihood function:

$$
\operatorname{Pr}\left(M_{\gamma^{*}} | \boldsymbol{y}\right)=\frac{B_{\gamma^{*}}(\boldsymbol{y}) \operatorname{Pr}\left(M_{\gamma^{*}}\right)}{\sum_{\gamma} B_{\gamma}(\boldsymbol{y}) \operatorname{Pr}\left(M_{\gamma}\right)}
$$

As stated in the introduction, we are mainly interested in software that implements the formal Bayesian answer which implies that we use the posterior distribution.

Due to the following three aspects  


- The priors that the package accomodates, that is, $\pi_{\gamma}\left(\boldsymbol{\beta}_{\gamma}, \alpha, \sigma^{2}\right)$ and $Pr(M_\gamma)$

- the tools provided to summarize the posterior distribution and obtain model averaged inference

- the numerical methods implemented to compute the posterior distribution

## Prior Specification

The two inputs that are needed to obtain the posterior distribution are $\pi_\gamma$ and $Pr(M_r)$ the $2^p$ prior distributions for the parameters within each model and the prior distribution over the model space, respectively.

不失一般性，先验分布$\pi_\gamma$ 可以写成
$$
\pi_{\gamma}\left(\boldsymbol{\beta}_{\gamma}, \alpha, \sigma^{2}\right)=\pi_{\gamma}\left(\boldsymbol{\beta}_{\gamma} | \alpha, \sigma^{2}\right) \pi_{\gamma}\left(\alpha, \sigma^{2}\right)
$$
，也就是coefficient，intercept，和variance的先验，
基于最方便的方法，基础Jeffreys' prior is used for the parameters that are common to all models:

$$
\pi_{\gamma}\left(\alpha, \sigma^{2}\right)=\sigma^{-2}
$$
对于$\beta$,则要么使用正态，要么使用mixture正态，中心点在0. ("by reasons of similarity",Jeffreys,1961) and scaled by $\sigma^{2}\left(\boldsymbol{X}_{\gamma}^{t} \boldsymbol{X}_{\gamma}\right)^{-1}$, "a matrix suggested by the form of the information matrix." times a factor g, normally called a "g-prior". 目前的研究表明这样的方便的prior拥有一系列的最优的性质可以扩展到对超参数g做特殊的先验。 Among these properties are invariance under affine transformations of the covariates, several types of predictive matching and consistency ( Bayarri et al., 2002).

The specification of g has inspired many interesting studies in the literature. Of these, we have collected the most popular one in Table1.

Relatedd with the conventional priors, which inspired by asymptotically reproducing the popular Bayesian Information Criterion (Schwarz,1978). Raftery proposes using the same covariance matrix as the Unit Information Prior, but with mean the maximum likelihood estimator $\hat\beta_\gamma$ (instead of the zero mean of the conventional prior).

Other priors specifically used in model uncertainty problems are the *spike and slab priors.*
Assume that the components of $\beta$ are independent, each having a mixture of two distributions: one highly concentrated on zero (the spike) and the other one quite disperse (the slab). There are two different developments of this idea in the literature. 

There are two different developments of this idea. Original version is Mitchell and Beauchamp (1988), the spike is a degenerate distribution at zero so this fits with what we have called the formal approach.

Another proposal by George and McCulloch (1993) which the spike is a continuous distribution with a small variance also received a lot of attention, perhaps for computational advantages.

模型空间的prior,$\mathcal M$, 一个非常受欢迎的起点是

$$
Pr(M_\gamma|\theta)=\theta^{p_\gamma}(1-\theta)^{p-p_\gamma}
$$
where $p_\gamma$ is the number of covariates in $M_\gamma$ and the hyperparameter $\theta\in(0,1)$ has the interpretation of the common probability that a given variable is included (independently of all others).

Among the most popular default choice for $\theta$ are

- Fixed $\theta=1/2$, which assign equal prior probability to each model i.e. $\operatorname{Pr}\left(M_{\gamma}\right)=1 / 2^{p}$

- Random $\theta \sim \operatorname{Unif}(0,1)$, giving euqal probability to each possible number of covariates or model size.

一般来说，固定的$\theta$会在多样性上表现非常差，在测试中，伪造的解释变量经常在结果中出现，然后lead to 更有信息的先验。这套个情况可以用随机的$\theta$进行避免，第二个proposal 见Scott and Berger (2010.) Lay and Steel(2009) 考虑使用$\theta\sim Beta(1,b)$ 可以导出binomial-beta 先验 for the number of covariates in the model or the model size,W:
$$
\operatorname{Pr}(W=w | b) \propto \left( \begin{array}{c}{p} \\ {w}\end{array}\right) \Gamma(1+w) \Gamma(b+p-w), w=0,1, \ldots, p
$$
注意$b=1$ 时退化到uniform prior on $\theta$ and also on $W$. Ley and Steel (2009), this setting is useful to incorporate prior information about the mean model size, say $w^*$. This would translate into $b=(p-w^*)/w^*$.

## Summaries the posterior distribution and model averaged inference

The simplest summary of the posterior model distribution is its mode

$$
\underset{\gamma}{\arg \max } \operatorname{Pr}\left(M_{\gamma} | \boldsymbol{y}\right)
$$

This model is the model most supported by the information (data and prior) 

This is normally called *HPM*(jighest posterior model) or MAP (maximum a posteriori) model.

When p is moderate to large, posterior inclusion probabilities (PIP) are very useful.

$$
\operatorname{Pr}\left(\gamma_{i}=1 | \boldsymbol{y}\right)=\sum_{x_{i} \in M_{\gamma}} \operatorname{Pr}\left(M_{\gamma} | \boldsymbol{y}\right)
$$
这个可以理解成每个变量解释response的重要性。

这个概率也可以用于定义另外一个summary，叫median probability model(MPM) which is the model containing the covariates with inclusion probability larger than 0.5. This model in some case is optimal for prediction.



## Numerical Methods




---

Bayes Lasso:

目前已知问题和需要解决的问题：

预计写作时间：19分钟

首先，解决了一半的问题：$\beta$ 的先验问题。

由[Bayes Lasso的完整版notes(相对于论文)]([http://www.math.chalmers.se/Stat/Grundutb/GU/MSA220/S16/bayeslasso.pdf](http://www.math.chalmers.se/Stat/Grundutb/GU/MSA220/S16/bayeslasso.pdf)) 其中，Hierachical model部分，$\beta|\tau_1^2,…,\tau^2_p\sim N_p(0_p,D_\tau)$ 是成立的(根据原始式子推出来的)，但是和论文suggest的hierarchical representation of the full model:
$$
\begin{aligned} \boldsymbol{y} | \mu, \boldsymbol{X}, \boldsymbol{\beta}, \sigma^{2} & \sim N_{n}\left(\mu \mathbf{1}_{n}+\boldsymbol{X} \boldsymbol{\beta}, \sigma^{2} \boldsymbol{I}_{n}\right) \\ \boldsymbol{\beta} | \tau_{1}^{2}, \ldots, \tau_{p}^{2}, \sigma^{2} & \sim N_{p}\left(\mathbf{0}_{p}, \sigma^{2} \boldsymbol{D}_{\tau}\right), \qquad \boldsymbol{D}_{\tau}=\operatorname{diag}\left(\tau_{1}^{2}, \ldots, \tau_{p}^{2}\right) \\ \tau_{1}^{2}, \ldots, \tau_{p}^{2} & \sim \prod_{j=1}^{p} \frac{\lambda^{2}}{2} e^{-\lambda^{2} \tau_{j}^{2} / 2} d \tau_{j}^{2}, \quad \tau_{1}^{2}, \ldots, \tau_{p}^{2}>0 \\ \sigma^{2} & \sim \pi\left(\sigma^{2}\right) d \sigma^{2} \end{aligned}
$$
有细微的差别：差了一个$\sigma^2$. 在该notes中的描述则是，第一个形式是成立的，但是会有问题： "possibility of a non-unimodal posterior",在Section 4 unimodal 问题里有详细描述，然后对$\tau^2_1,…,\tau^2_p$ 有其他先验的话会形成其他和Lasso有关的方法，在Section 6.

---

> 为什么会有不含$\sigma^2$ 的形式呢？主要是因为来源于最初的方程式

$$
\frac{a}{2} e^{-a|z|}=\int_{0}^{\infty} \frac{1}{\sqrt{2 \pi s}} e^{-z^{2} /(2 s)} \frac{a^{2}}{2} e^{-a^{2} s / 2} d s, \quad a>0
$$

如果把Laplace先验写成$\pi(\boldsymbol{\beta})=\prod_{j=1}^{p} \frac{\lambda}{2} e^{-\lambda\left|\beta_{j}\right|}$ 的话，那么$a$ 就是 $\lambda$ ,  $\beta$ 的密度很自然的与$\sigma$ 无关，是$N(0,\tau_j^2)$

如果把Laplace先验写成$\pi\left(\boldsymbol{\beta} | \sigma^{2}\right)=\prod_{j=1}^{p} \frac{\lambda}{2 \sqrt{\sigma^{2}}} e^{-\lambda\left|\beta_{j}\right| / \sqrt{\sigma^{2}}}$ 的话，那么a就是$\frac{\lambda}{\sqrt{\sigma^2}}$ ，则 $\tau_j$ 的分布会带上 $\sigma^2$ , 因为，这两种情况都和Full model对不上号。。。。

---

> 假设以上先不管，full mode成立，那么就可以写出来joint density

$$
\begin{array}{l}{f\left(\boldsymbol{y} | \mu, \boldsymbol{\beta}, \sigma^{2}\right) \pi\left(\sigma^{2}\right) \pi(\mu) \prod_{j=1}^{p} \pi\left(\beta_{j} | \tau_{j}^{2}, \sigma^{2}\right) \pi\left(\tau_{j}^{2}\right)=} \\ {\qquad \frac{1}{\left(2 \pi \sigma^{2}\right)^{n / 2}} e^{-\frac{1}{2 \sigma^{2}}\left(\boldsymbol{y}-\mu \mathbf{1}_{n}-\boldsymbol{X} \boldsymbol{\beta}\right)^{\top}\left(\boldsymbol{y}-\mu \mathbf{1}_{n}-\boldsymbol{X} \boldsymbol{\beta}\right)}} \\ { \times \frac{\gamma^{a}}{\Gamma(a)}\left(\sigma^{2}\right)^{-a-1} e^{-\gamma / \sigma^{2}} \prod_{j=1}^{p} \frac{1}{\left(2 \pi \sigma^{2} \tau_{j}^{2}\right)^{1 / 2}} e^{-\frac{1}{2 \sigma^{2} \tau_{j}^{2}} \beta_{j}^{2}} \frac{\lambda^{2}}{2} e^{-\lambda^{2} \tau_{j}^{2} / 2}}\end{array}
$$

这个很清晰，第一块是$\boldsymbol y$ 的Normal，第二块是$\sigma^2$ 的inverse-gamma，第三块是$\beta_j$ 的Normal hierachical prior with 超参数$\tau_j$  服从$f(\tau)=\frac{\lambda^{2}}{2} e^{-\lambda^{2} \tau_{j}^{2} / 2} $.

> 19分钟写到这，没写完，再来19分钟

然后就是用$\overline y$ 作为$y$ 的均值，重新写一下Normal里面关于Y和$\mu$ 的二次型如下：
$$
\begin{aligned}\left(\boldsymbol{y}-\mu \mathbf{1}_{n}-\boldsymbol{X} \boldsymbol{\beta}\right)^{\top}\left(\boldsymbol{y}-\mu \mathbf{1}_{n}-\boldsymbol{X} \boldsymbol{\beta}\right) &=\left(\overline{y} \mathbf{1}_{n}-\mu \mathbf{1}_{n}\right)^{\top}\left(\overline{y} \mathbf{1}_{n}-\mu \mathbf{1}_{n}\right)+(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta})^{\top}(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta}) \\ &=n(\overline{y}-\boldsymbol{\mu})^{2}+(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta})^{\top}(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta}) \end{aligned}
$$
所以就把关于$\mu$的部分和关于$y,X,\beta$ 的部分分开了，可以看到，关于$\mu$的部分还是一个二次型，配合前面的系数，可以凑成一个Normal的形式，有均值$\overline y$ 和方差$\sigma^2/n$，然后把$\mu$积掉，因为是正态，还分开了，所以积分就是1，相当于把这项拿走不影响其他项，得到一个新的Marginal only over $\mu$ 的joint density, which is proportional to
$$
\frac{1}{\left(\sigma^{2}\right)^{(n-1) / 2}} e^{-\frac{1}{2 \sigma^{2}}(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta})^{\top}(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta})}\left(\sigma^{2}\right)^{-a-1} e^{-\gamma / \sigma^{2}} \prod_{j=1}^{p} \frac{1}{\left(\sigma^{2} \tau_{j}^{2}\right)^{1 / 2}} e^{-\frac{1}{2 \sigma^{2} \tau_{j}^{2}} \beta_{j}^{2}} e^{-\lambda^{2} \tau_{j}^{2} / 2}
$$
This expression depends on $\boldsymbol y$ only through $\tilde{\boldsymbol{y}}$  . The conjugacy of the other parameters remains unaffected.

---

> 然后就能构建Gibbs

- $\beta$ 

$$
-\frac{1}{2 \sigma^{2}}(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta})^{\top}(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta})-\frac{1}{2 \sigma^{2}} \boldsymbol{\beta}^{\top} \boldsymbol{D}_{\tau}^{-1} \boldsymbol{\beta}=-\frac{1}{2 \sigma^{2}}\left\{\boldsymbol{\beta}^{\top}\left(\boldsymbol{X}^{\top} \boldsymbol{X}+\boldsymbol{D}_{\tau}^{-1}\right) \boldsymbol{\beta}-2 \tilde{\boldsymbol{y}}^{\top} \boldsymbol{X} \boldsymbol{\beta}+\tilde{\boldsymbol{y}}^{\top} \tilde{\boldsymbol{y}}\right\}
$$

$\beta$ involve part is quadratic form with a linear form, which is proportional to Normal density.

Letting $\boldsymbol{A}=\boldsymbol{X}^{\top} \boldsymbol{X}+\boldsymbol{D}_{\tau}^{-1}$ , Then the equation upon can be transformed to 
$$
\boldsymbol{\beta}^{\top} \boldsymbol{A} \boldsymbol{\beta}-2 \tilde{\boldsymbol{y}}^{\top} \boldsymbol{X} \boldsymbol{\beta}+\tilde{\boldsymbol{y}}^{\top} \tilde{\boldsymbol{y}}=\left(\boldsymbol{\beta}-\boldsymbol{A}^{-1} \boldsymbol{X}^{\top} \tilde{\boldsymbol{y}}\right)^{\top} \boldsymbol{A}\left(\boldsymbol{\beta}-\boldsymbol{A}^{-1} \boldsymbol{X}^{\top} \tilde{\boldsymbol{y}}\right)+\tilde{\boldsymbol{y}}^{\mathrm{T}}\left(\boldsymbol{I}_{n}-\boldsymbol{X} \boldsymbol{A}^{-1} \boldsymbol{X}^{\top}\right) \tilde{\boldsymbol{y}}
$$
That is, $\boldsymbol \beta$ is conditionally multivariate normal with mean $A^{-1} \boldsymbol{X}^{\top} \tilde{\boldsymbol{y}}$ and variance $\sigma^{2} \boldsymbol{A}^{-1}$.

这块应该可以照常用，只要把$\sigma^2$ 那块的东西处理掉，

- $\sigma^2$

因为要建模，所以这块应该全部要换成Normal和建模的形式
$$
\left(\sigma^{2}\right)^{-(n-1) / 2-p / 2-a-1} \exp \left\{-\frac{1}{\sigma^{2}}\left((\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta})^{\mathrm{T}}(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta}) / 2+\boldsymbol{\beta}^{\top} \boldsymbol{D}_{\tau}^{-1} \boldsymbol{\beta} / 2+\gamma\right)\right\}
$$
这个是conditionally inverse gamma的形式，with shape $(n-1) / 2+p / 2+a$ and scale parameter $(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta})^{\mathrm{T}}(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta}) / 2+\boldsymbol{\beta}^{\top} \boldsymbol{D}_{\tau}^{-1} \boldsymbol{\beta} / 2+\gamma$ .

- $\tau_j^2$ for $j=1,…,p$

Density is:
$$
\left(\tau_{j}^{2}\right)^{-1 / 2} \exp \left\{-\frac{1}{2}\left(\frac{\beta_{j}^{2} / \sigma^{2}}{\tau_{j}^{2}}+\lambda^{2} \tau_{j}^{2}\right)\right\}
$$
Proportional to the density of the reciprocal of an inverse Gaussian random variable.



---

> 第四节，等等，怎么变成日常笔记了， The posterior distribution



The joint posterior distribution of $\boldsymbol \beta $ and $\sigma^2$ is proportional to
$$
\left(\sigma^{2}\right)^{-(n+p-1) / 2-a-1} \exp \left\{-\frac{1}{\sigma^{2}}\left((\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta})^{\top}(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta}) / 2+\gamma\right)-\frac{\lambda}{\sqrt{\sigma^{2}}} \sum_{j=1}^{p}\left|\beta_{j}\right|\right\}
$$
从这里面来看，至少很像最小二乘+罚函数的形式。

We may safety let $a=0$ .

> 这句话没太懂：

Assuming that the data do not admit a perfect linear fit (i.e. $\tilde y$ is not in the column space of $\boldsymbol X$ ), also let $\gamma=0$ .This corresponds to using the non-informative scale-invariant prior $1/\sigma^2$ on $\sigma^2$ .

$\boldsymbol X$ matrix is, of course, unitless because of its scaling.

For comparison, the joint posterior distribution of $\boldsymbol \beta $ and $\sigma^2$ under prior (1), 也就是不涉及$\sigma^2$ 的prior，with some independent prior $\pi(\sigma^2)$ on $\sigma^2$, is proportional to 
$$
\pi\left(\sigma^{2}\right)\left(\sigma^{2}\right)^{-(n-1) / 2} \exp \left\{-\frac{1}{2 \sigma^{2}}(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta})^{\mathrm{T}}(\tilde{\boldsymbol{y}}-\boldsymbol{X} \boldsymbol{\beta})-\lambda \sum_{j=1}^{p}\left|\beta_{j}\right|\right\}
$$

> 所以果然是为了合并同类项吗

In this case, $\lambda$ has units that are the reciprocal of the units of the response, and any change in units will require a corresponding change in $\lambda$ to produce the equivalent Bayesian solution. 

这段话应该很重要，关于unit change的，类似于给$\beta$ 加了一个 rescaling ? 标记一下，这里值得重点研究一下:

> 这个unit，和scaling究竟是什么情况？如果要挪用的话得用什么？因为毕竟没有我的模型里面没有$\sigma^2$，能不能不管这个问题，得付出什么代价？要管的话应该用什么？

然后第二个问题就是multi-modal的问题，下次来继续说。

> 重新开始

第二个模型可能会有多于一个极值点。 Taking $p=1,n=10,X^TX=1,X^T\tilde y=5,\tilde y^Ty=26,\lambda=3$. The mode on the lower right is near the least-squares solution $\beta=5,\sigma^2=1/8$, while the mode on the upper left is near the values $\beta=0,\sigma^2=26/9$ that would be estimated for the selected model in which $\beta$ is set to zero.  The crease in the upper left mode along the line $\beta=0$ is a feature produced by the "sharp corners" of the $L_1$ penalty. Not surprisingly, the marginal density of $\beta$ is also bimodal. When $p>1$, it may be possible to have more than two modes, though we have not investigated this.

所以这两个峰不是莫名其妙的两个峰，是分别是OLS的结果和，不取该$\beta$ 的结果。



> 所以好像直接用Bayes Lasso会出问题，得改，但是设计$\sigma^2$ 感觉会变得很麻烦。。。

多个峰值会导致计算和概念上的问题，这种情况下，单点的后验均值，中位数，或者最大值点是否能总结一个双峰后验的要素是有疑问的。一个更好的summary将会是分别测量每个峰值点



> 下一步是选取$\lambda$ ，original的lasso是通过cross-validation,generalised cross-validation, and ideas based on Stein's unbiased risk estimate. Bayesian Lasso offers some  uniquely Bayesian alternatives: empirical Bayes via marginal (Type 2) maximum likelihood, and use of an appropriate hyperprior. 这是啥，不懂得看看

### Empirical Bayes by Marginal Maximum Likelihood

> Finish





## Bayesian asymptotically analysis

第一个内容是来自于 Bayesian Model Selection and Statistical Modeling.
但是没完全看懂。
第二个看懂的是来自于[这个课件](https://www.stat.unipd.it/sites/default/files/bayesian-mod2.pdf) 对log density Taylor展开以后二次项就是一个Normal的形式


## Bayes factor

$$
\begin{array}{c}{\frac{\text { TABLE } 5.1: \text { Jeffreys' scale of evidence for Bayes factor }\left(M_{k}, M_{j}\right)}{\text { Interpretation }}} \\ {\text { Bayes factor }} {\text { Interpretation }} \\ {\begin{array}{cc}{B_{k j}<1} & {\text { Negative support for } M_{k}} \\ {1<B_{k j}<3} & {\text { Barely worth mentioning evidence for } M_{k}} \\ {3<B_{k j}<10} & {\text { Substantial evidence for } M_{k}} \\ {10<B_{k j}<100} & {\text { Jrong evidence for } M_{k}} \\ {30<B_{k j}<100} & {\text { Verisive evidence for } M_{k}} \\ {100<B_{k j}} & {\text { Decisive evidence for } M_{k}}\end{array}}\end{array}
$$

### Marginal density 居然可以这么来使

$$
P\left(\boldsymbol{X}_{n}\right)=\frac{f\left(\boldsymbol{X}_{n} | \lambda\right) \pi(\lambda)}{\pi\left(\lambda | \boldsymbol{X}_{n}\right)}
$$
这个来源于Bayes公式：
$$
P(A | B)=\frac{P(B | A) P(A)}{P(B)}
$$
等价于
$$
P(B)=\frac{P(B | A) P(A)}{P(A | B)}
$$
所以就可以直接得到marginal density。。。。
因为在实践中，likelihood乘以先验，和后验本身，就差一个normalising constant，而这个normalising constant的形式就是marginal density本身。所以对于任意的conjugate 的分布组，这个积分反过来就会很容易。

### 几个需要可能研究的玩意

Gaussian radial basis with a hyperparameter
$$
b_{j}(\boldsymbol{x})=\exp \left(-\frac{\left\|\boldsymbol{x}-\boldsymbol{\mu}_{j}\right\|^{2}}{2 \nu \sigma_{j}^{2}}\right), \quad j=1,2, \ldots, m
$$
with 
$$
\boldsymbol{c}_{k}=\frac{1}{n_{k}} \sum_{\alpha \in A_{k}} \boldsymbol{x}_{\alpha}, \quad s_{k}^{2}=\frac{1}{n_{k}} \sum_{\alpha \in A_{k}}\left\|\boldsymbol{x}_{\alpha}-\boldsymbol{c}_{k}\right\|^{2}
$$
indicate the basis function
$$
b_{k}(\boldsymbol{x})=\exp \left(-\frac{\left\|\boldsymbol{x}-\boldsymbol{c}_{k}\right\|^{2}}{2 \nu s_{k}^{2}}\right), \quad k=1, \ldots, m
$$

然后这个singular multivariate normal prior density是啥情况
$$
\pi(\boldsymbol{\theta})=\left(\frac{n \lambda}{2 \pi}\right)^{(m-d) / 2}|R|_{+}^{1 / 2} \exp \left\{-n \lambda \frac{\boldsymbol{\theta}^{T} R \boldsymbol{\theta}}{2}\right\}
$$














