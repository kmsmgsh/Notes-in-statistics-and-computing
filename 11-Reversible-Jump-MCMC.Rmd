# Reversible Jump MCMC

## Introduction

Provides a general framework for Markov chain Monte Carlo simulation in which the dimension of the parameter space can vary between iterates of the Markov chain. Extension of the Metropolis-Hastings algorithm onto more general state spaces.

Suppose that for observed data $x$ we have a countable collection of candidate models $\mathcal{M}=\left\{\mathcal{M}_{1}, \mathcal{M}_{2}, \ldots\right\}$ indexed by a parameter $k \in \mathcal{K}$. The index k can be considered as an auxiliary model indicator variable, such that $\mathcal{M}_{k^{\prime}}$ denotes the model where $k=k'$. Each model $\mathcal{M}_k$ has an $n_k$-dimensional vector of unknown parameters,$\boldsymbol{\theta}_{k} \in \mathbb{R}^{n_{k}}$, where $n_k$ can take different values for different models $k\in\mathcal K$. The joint posterior distribution of $(k,\boldsymbol{\theta}_k)$ given observed data,x, is obtained as the product of the likelihood, $L\left(\mathbf{x} | k, \boldsymbol{\theta}_{k}\right)$, and the joint prior, $p\left(k, \boldsymbol{\theta}_{k}\right)=p\left(\boldsymbol{\theta}_{k} | k\right) p(k)$, constructed from the prior distribution of $\boldsymbol \theta_k$ under model $\mathcal M_k$, and the prior for the model indicator k(i.e. the prior for model $\mathcal M_k$). Hence, the joint posterior is
$$
\pi\left(k, \boldsymbol{\theta}_{k} | \mathbf{x}\right)=\frac{L\left(\mathbf{x} | k, \boldsymbol{\theta}_{k}\right) p\left(\boldsymbol{\theta}_{k} | k\right) p(k)}{\sum_{k^{\prime} \in \mathcal{K}} \int_{\mathbb{R}^{n} k^{\prime}} L\left(\mathbf{x} | k^{\prime}, \boldsymbol{\theta}_{k^{\prime}}^{\prime}\right) p\left(\boldsymbol{\theta}_{k^{\prime}}^{\prime} | k^{\prime}\right) p\left(k^{\prime}\right) d \boldsymbol{\theta}_{k^{\prime}}^{\prime}}
$$
> 也就是说，这个posterior就是选一个模型（自带$n_k$个参数），然后再这个模型下可以得到一个posterior，而选定了模型以后，对应$n_k$个参数也有一个prior，在已知k的时候的prior，这样就构造了对于k个模型，已知数据x的posterior
因为reversible jump就按前言中所说的，是用来解决参数维度变化的。而对于coefficient维度变化则对应了不同的模型，也就是说在不同模型之间跳来跳去的，

The target of an MCMC sampler over the state space $\boldsymbol{\Theta}=\bigcup_{k \in \mathcal{K}}\left(\{k\} \times \mathbb{R}^{n_{k}}\right)$, where the states of the Markov chain are of the form $(k,\boldsymbol \theta_k)$, the dimension of which can vary over the state space. Accordingly, from the output of a single Markov chain sampler, the user is able to obtain a full probabilistic description of the posterior probabilities of each model having observed the data, x, in addition of the posterior porbabilities of each model having observed the data,x, in addition to the posterior distributions of the individual models.

> 输出是一个单独的Markov chain sampler。可以的到期描述每个模型的全后验概率，关于观测数据。

### From Metropolis-Hastings to Reversible Jump

Stand form of MH relies on the construction of a time-reversible Markov chain via the detailed balance condition. That is, the moves from state $\theta$ to $\theta'$ are made as often as moves from $\theta'$ to $\theta$ with respect to the ratget density. Then extension MH to the setting that the dimension of the parameter vector varies.

The previous part construction of a Markov chain on a general state space $\Theta$ with invariant or stationary distribution $\pi$, the detailed balance condition can be written as
$$
\int_{\left(\theta, \theta^{\prime}\right) \in \mathcal{A} \times \mathcal{B}} \pi(d \theta) P\left(\theta, d \theta^{\prime}\right)=\int_{\left(\theta, \theta^{\prime}\right) \in \mathcal{A} \times \mathcal{B}} \pi\left(d \theta^{\prime}\right) P\left(\theta^{\prime}, d \theta\right)
$$

所以只是换了state space,其他都没变？
Compare to standard MH algorithm, Markov chain transitions from a current state $\boldsymbol{\theta}=\left(k, \boldsymbol{\theta}_{k}^{\prime}\right) \in \mathcal{A}$, in model $\mathcal M_k$ are realized by first proposing a new state $\boldsymbol{\theta}^{\prime}=\left(k^{\prime}, \boldsymbol{\theta}_{k^{\prime}}\right) \in \mathcal{B}$，($A$是$k$的域，比如$\mathbb N$? $B$是$\mathbb R^{n_k}$,也就是正常的$\theta$的域。) by proposal distribution $q(\boldsymbol\theta,\boldsymbol \theta')$. The detailed balance condition is enforced through the acceptance probability, where the move to the candidate state $\boldsymbol \theta'$ is accepted with probability $\alpha\left(\theta, \theta^{\prime}\right)$. If rejected, the chain remains at the current state $\boldsymbol \theta$ in model $\mathcal M_k$. Under this mechanism, detail balance condition equation becomes
$$
\int_{\left(\theta, \theta^{\prime}\right) \in \mathcal{A} \times \mathcal{B}} \pi(\boldsymbol{\theta} | \mathbf{x}) q\left(\boldsymbol{\theta}, \boldsymbol{\theta}^{\prime}\right) \alpha\left(\boldsymbol{\theta}, \boldsymbol{\theta}^{\prime}\right) d \boldsymbol{\theta} d \boldsymbol{\theta}^{\prime}=\int_{\left(\theta, \boldsymbol{\theta}^{\prime}\right) \in \mathcal{A} \times \mathcal{B}} \pi\left(\boldsymbol{\theta}^{\prime} | \mathbf{x}\right) q\left(\boldsymbol{\theta}^{\prime}, \boldsymbol{\theta}\right) \alpha\left(\boldsymbol{\theta}^{\prime}, \boldsymbol{\theta}\right) d \boldsymbol{\theta} d \boldsymbol{\theta}^{\prime}
$$
where $\pi(\theta|x)$ are the posterior we want sample.

One way to enforce this equation is by setting the acceptance probability as 

$$
\alpha\left(\boldsymbol{\theta}, \boldsymbol{\theta}^{\prime}\right)=\min \left\{1, \frac{\pi(\boldsymbol{\theta} | \mathbf{x}) q\left(\boldsymbol{\theta}, \boldsymbol{\theta}^{\prime}\right)}{\pi\left(\boldsymbol{\theta}^{\prime} | \mathbf{x}\right) q\left(\boldsymbol{\theta}^{\prime}, \boldsymbol{\theta}\right)}\right\}
$$

This resembles the usual metropolis-hastings acceptance ratio. Then a reversible jump sampler with N iterations is commonly constructed as follows:

- Initialize k and $\boldsymbol \theta_k$ at iteration $t=1$
- For iteration $t\geq 1$ perform
  - Within-model move: with a fixed model k, update the parameters $\boldsymbol \theta_k$ acoording to any MCMC updating scheme
  - Between-models move: simultaneously update model indicator k and the parameter $\boldsymbol \theta_k$ according to the general reversible proposal/acceptance mechanism  
- Increment iteration t=t+1. If $t<N$, go to step 2.

> 问题：Within-model move是一个传统的MH move，Between-model move是延拓的MH move，关键是，必须要在本model做一个move，然后再抽model吗？还是说其实只做两个一起抽也是可以的？

### Application Area

*Change-point models* One of the original application of the reversible jump sampler was in Bayesian change-point problems.  Green(2005) analyzed mining disaster count data using a Poisson process with the rate parameter described as a step function with an unknown number and location of steps. Fan and Brooks(2000) applies the reversible jump sampler to model the shape of prehistoric tombs, where the curvature of the dome changes an unknown number of times

*Finite mixture models*. Mixture models are widely used where each data observation is generated according to some underlying categorical mechanism, which the mechanism is typically unobserved, so there is uncertainty regarding which component of the resulting mixture distribution each data observation was generated from, and uncertainty ober the nuber of mixture components.
$$
f(x|\theta_k)=\sum_{j=1}^k w_jf_j(x|\phi_j)
$$

*Variable selection* The multi-model setting emerges when attempting to identify the most relevant subsets of predictors, making it a natural candidate for the reversible jump sampler. 

*Nonparametrics* Within Bayesian nonparametrics, many authors have successfully explored the use of the reversible jump sampler as a method to automate the knot selection process when using a pth-order spline model for curve fitting.
$$
f(x)=\alpha_0+\sum_{j=1}^{P}\alpha_j x^j+\sum_{i=1}^k \eta_j(x-\kappa_i)^P_+ 
$$
with $x\in[a,b]$

*Time series models* In the modelling of temporally dependent data, $x_1,...,x_T$, multiple models naturally arise under uncertainty over the degree of dependence. For example, under a kth-order autoregressive process
$$
X_t=\sum^k_{\tau=1}a_\tau X_{t-\tau}+\epsilon_t
$$
with $t=k+1,...,T$

## Implementation
In practice, the construction of proposal moves between different models is achieved via the concept of "dimension matching." Most simply, under a general Bayesian model determination setting, suppose that we are currently in state $(k,\theta_k)$ in model $\mathcal M_k$, and we wish to propose a move to a state $(k',\theta_k')$ in model $\mathcal M_{k'}$, which is of a higher dimension, so that $n_{k^{\prime}}>n_{k}$. In order to "math dimensions" between the two model states, a random vector $\boldsymbol u$ of length $d_{k \rightarrow k^{\prime}}=n_{k^{\prime}}-n_{k}$ is generated from a known density $q_{d_{k \rightarrow k^{\prime}}}(\mathbf{u})$. The current state $\boldsymbol \theta_k$ and the random vector $\boldsymbol u$ are then mapped to the new state $\boldsymbol{\theta}_{k^{\prime}}^{\prime}=g_{k \rightarrow k^{\prime}}\left(\boldsymbol{\theta}_{k}, \mathbf{u}\right)$ through a one-to-one mapping function $g_{k \rightarrow k^{\prime}} : \mathbb{R}^{n_{k}} \times \mathbb{R}^{d_{k}} \rightarrow \mathbb{R}^{n_{k^{\prime}}}$. The acceptance probability of this proposal, combined with the joint posterior expression becomes
$$
\alpha\left[\left(k, \theta_{k}\right),\left(k^{\prime}, \theta_{k^{\prime}}^{\prime}\right)\right]=\min \left\{1, \frac{\pi\left(k^{\prime}, \theta_{k^{\prime}}^{\prime} | \mathbf{x}\right) q\left(k^{\prime} \rightarrow k\right)}{\pi\left(k, \theta_{k} | \mathbf{x}\right) q\left(k \rightarrow k^{\prime}\right) q_{d_{k \rightarrow k^{\prime}}}(\mathbf{u})}\left|\frac{\partial g_{k \rightarrow k^{\prime}}\left(\boldsymbol{\theta}_{k}, \mathbf{u}\right)}{\partial\left(\theta_{k}, \mathbf{u}\right)}\right|\right\}
$$

为了填补缺少的维度，提出一个随机向量$u$，维度是缺少的维度，来源于一个已知的密度函数$q_{d_{k\rightarrow k'}}(u)$.(这个密度怎么取？)。然后目前的状态$\theta_k$和$u$可以映射到新的状态$\boldsymbol{\theta}_{k^{\prime}}^{\prime}=g_{k \rightarrow k^{\prime}}\left(\boldsymbol{\theta}_{k}, \mathbf{u}\right)$,通过g这个一一映射，$g_{k \rightarrow k^{\prime}} : \mathbb{R}^{n_{k}} \times \mathbb{R}^{d_{k}} \rightarrow \mathbb{R}^{n_{k^{\prime}}}$. 然后有接受概率如上。解释，分子就是从新到老的概率，下面是从老到新的概率，因为多了u，所以多一块u的概率，而反过来则没有。
后面那块则是一一映射g的jacobian矩阵。这一块是来自于因为对$\theta$做了变换。在detail-balance condition equation那块做积分的时候会用到。

反过来reverse move的话（从高维move到低维），则有接受概率
$$
\alpha\left[\left(k^{\prime}, \boldsymbol{\theta}_{k^{\prime}}^{\prime}\right),\left(k, \boldsymbol{\theta}_{k}\right)\right]=\alpha\left[\left(k, \boldsymbol{\theta}_{k}\right),\left(k^{\prime}, \boldsymbol{\theta}_{k^{\prime}}^{\prime}\right)\right]^{-1}
$$
。


更一般的，我们可以放宽u长度的条件，也就是让$d_{k \rightarrow k^{\prime}} \geq n_{k^{\prime}}-n_{k}$. 则在这种情况下，不确定的反向移动可以通过一个$d_{k^{\prime} \rightarrow k}$-维的向量，$\mathbf{u}^{\prime} \sim q_{d_{k^{\prime} \rightarrow k}}\left(\mathbf{u}^{\prime}\right)$,使得对应"dimension-match"条件能成立:在同一维度：$n_{k}+d_{k \rightarrow k^{\prime}}=n_{k^{\prime}}+d_{k^{\prime} \rightarrow k}$.

则反过来的映射可以写成$\boldsymbol{\theta}_{k}=g_{k^{\prime} \rightarrow k}\left(\boldsymbol{\theta}_{k^{\prime}}^{\prime} \mathbf{u}^{\prime}\right)$ ,使得有$\boldsymbol{\theta}_{k}=g_{k^{\prime} \rightarrow k}\left(g_{k \rightarrow k^{\prime}}\left(\boldsymbol{\theta}_{k}, \mathbf{u}\right), \mathbf{u}^{\prime}\right)$,以及$\boldsymbol{\theta}_{k^{\prime}}^{\prime}=g_{k \rightarrow k^{\prime}}\left(g_{k^{\prime} \rightarrow k}\left(\boldsymbol{\theta}_{k^{\prime}}^{\prime} \mathbf{u}^{\prime}\right), \mathbf{u}\right)$.接受概率则可以写成:

$$
\alpha\left[\left(k, \theta_{k}\right),\left(k^{\prime}, \theta_{k^{\prime}}^{\prime}\right)\right]=\min \left\{1, \frac{\pi\left(k^{\prime}, \theta_{k^{\prime}} | \mathbf{x}\right) q\left(k^{\prime} \rightarrow k\right) q_{d_{k^{\prime} \rightarrow k}}\left(\mathbf{u}^{\prime}\right)}{\pi\left(k, \theta_{k} | \mathbf{x}\right) q\left(k \rightarrow k^{\prime}\right) q_{d_{k \rightarrow k^{\prime}}}(\mathbf{u})}\left|\frac{\partial g_{k \rightarrow k^{\prime}}\left(\boldsymbol{\theta}_{k}, \mathbf{u}\right)}{\partial\left(\theta_{k}, \mathbf{u}\right)}\right|\right\}
$$

> 相当于，可以找一个更高维的中间变量，然后一个随机向量u，补齐各状态与中间变量之间的差异。这样就可以避免高维到低维，低维到高维的不对等关系，使得算法表达形式能统一。

### Example Dimension Matching

Example in Green(1995) and Brooks(1998). Suppose that model $\mathcal M_1$ has states ($k=1,\theta_1\in \mathbb R^1$) and model $\mathcal M_2$ with states ($k=2,\theta_2\in \mathbb R^2$). So under this setting, $(1,\theta^*)$ denote the current state in $\mathcal M_1$ and $(2,(\theta^{(1)},\theta^{(2)}))$ denote the proposed state in $\mathcal M_2$. 
Under dimension matching, we might generate a random scalar u, and let $\theta^{(1)}=\theta^{*}+u \text { and } \theta^{(2)}=\theta^{*}-u$, with the reverse move given deterministically by $\theta^{*}=\frac{1}{2}\left(\theta^{(1)}+\theta^{(2)}\right)$.

所以就把1维和2维的统一在了一起，并且给定了转换表达式。

### Example: Moment Matching in a Finite Mixture of Univariate Normals

如果模型是有限个单变量正态分布的混合，观测数据,$x$,则服从混合正态分布,每块是$N(\mu_j,\sigma_j)$. 模型之间的移动，Richardson and Green(1997) 实现了一个分割和合并的策略。

当两个正态$j_1$和$j_2$ 合并成一个,$j^*$,有如下确定的映射，同时保持了0，1，2阶的矩。
$$
\begin{aligned} w_{j^{*}} &=w_{j_{1}}+w_{j_{2}} \\ w_{j^{*}} \mu_{j^{*}} &=w_{j_{1}} \mu_{j_{1}}+w_{j_{2}} \mu_{j_{2}} \\ w_{j^{*}}\left(\mu_{j^{*}}^{2}+\sigma_{j^{*}}^{2}\right) &=w_{j_{1}}\left(\mu_{j 1}^{2}+\sigma_{j_{1}}^{2}\right)+w_{j_{2}}\left(\mu_{j_{2}}^{2}+\sigma_{j_{2}}^{2}\right) \end{aligned}
$$
分割则是
$$
\begin{aligned} w_{j_{1}} &=w_{j^{*}} * u_{1}, \quad w_{j_{2}}=w_{j^{*}} *\left(1-u_{1}\right) \\ \mu_{j_{1}} &=\mu_{j^{*}}-u_{2} \sigma_{j^{*}} \sqrt{\frac{w_{j_{2}}}{w_{j_{1}}}} \\ \mu_{j_{2}} &=\mu_{j^{*}}+u_{2} \sigma_{j^{*}} \sqrt{\frac{w_{j_{1}}}{w_{j_{2}}}} \\ \sigma_{j_{1}}^{2} &=u_{3}\left(1-u_{2}^{2}\right) \sigma_{j^{*}}^{2} \frac{w_{j^{*}}}{w_{j_{2}}} \\ \sigma_{j_{2}}^{2} &=\left(1-u_{3}\right)\left(1-u_{2}^{2}\right) \sigma_{j^{*}}^{2} \frac{w_{j^{*}}}{w_{j_{2}}} \end{aligned}
$$
同时随机量$u_{1}, u_{2} \sim \operatorname{Beta}(2,2)$,以及$u_{3} \sim \operatorname{Beta}(1,1)$。这样满足了维度相同，然后能算分割步的接受概率和合并的接受概率。

## Mapping Functions and Proposal Distribution

虽然维度匹配的想法很简单，但是实现却很复杂。因为存在一个任意的映射函数$g_{k \rightarrow k^{\prime}}$ 和proposal distribution $q_{d_{k \rightarrow k^{\prime}}}(\mathbf{u})$。好的映射很自然的能提高采样的效率，体现在模型之间跳的接受率和chain本身的收敛。难点在于即是是很简单的nested model，也很难定义一个好的关系。模型之间的自由度只由$q_{d_{k \rightarrow k^{\prime}}}(\mathbf{u})$决定。然而没有一个很显然的准则选择好的q。对比模型内的选择，随机游走Mh算法可能对应任意的接受概率，一个小的游走对应高的接受概率，大步游走则接受概率会比较低。可以借鉴这个“local”的想法到模型空间$k\in\mathcal K$中。proposal来自于$\theta_k$ 在模型$\mathcal M_k$比起另外一个$\theta_{k'}$来自于$\mathcal M_{k'}$会有更高的接受率，如果数据对应的likelihood差别不大的话。比如说Richardson 和Green(1997)提出的"birth/death" and "split.merge"映射,在切换模型的时候尽量切换likelihood差不多的模型。但是这并不容易实现。
尽管如此，RjMCMC的采样效果还是很差。

> 所以要用的时候还是从最简单的birth-dead proposal和merge-split proposal开始看起吧。

### Marginalization and augmentation:

Reduced- or fixed- dimensional sampler may be substituted because reversible jump MCMC would be heaby-handed.
In lower dimensions, the reversible jump sampler is often easier to implement, as the problems associated with mapping function specification are conceptually simpler to resolve.

Example:Marginalization in Variable Selection.

用辅助变量，则能把parameter变成固定维数的问题。Under certain prior specifications for the regression coefficient $\beta$ and error variance $\sigma^2$，the $\beta$ coefficients can be analytically integrated out of the posterior. A gibbs sampler directly on model space is then available for $\gamma$。也就是说主要关注选取哪个模型的问题的话可以把$\beta$先积掉然后研究模型问题，等选定模型再估$\beta$?


Example:Marginalization in Finite Mixture of Multivariate Normal Models.

在Clusting问题里面，待估参数不是那么重要，所以Tadesse et al. (2005)提出来选取特定的先验，正态的系数可以积掉，然后对分几类做Reversible Jump，这样问题就被大大简化了。

细节等要用这块再说。


### Centering and Order Methods

Brooks et al.(2003c)  introduce a class of methods to achieve the automatic scaling of the proposal density $q_{d_{k\rightarrow k'}}(u)$, based on "local" move proposal distribution, which are centered around the point of equal likelihood values under current and proposed models.

> 这块以后再看好了。。。从目前的文献来看，birth-death 和 split-merge 策略已经足够很多了？等要用再来看后来这个auto-adaptive的方法















  
  
  
  
  
  
  
  
  
  
  
  


