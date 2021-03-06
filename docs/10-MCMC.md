# BasicMCMC


## Metropolis-Hastings Update

Specified distribution has *unnormalized density* $h$,that is, $h$ is a positive constant ties a probability density. The MH update does:

- When current state is $x$, propose a move to $y$, having conditional probability density given $x$ denoted $q(x,\cdot)$.
- Calculate the Hastings ratio
$$
r(x, y)=\frac{h(y) q(y, x)}{h(x) q(x, y)}
$$
- Accept the proposed move $y$ with probability 
$$
a(x, y)=\min (1, r(x, y))
$$
That is, the state after the update is $y$ with probability $a(x,y)$, and the state after the update is $x$ with probability $1-a(x,y)$.

> The different between the Metropolis rejection with the "reject sampling" in MC method is that MC rejection samping is done repeatedly until some proposal is accepted. MH rejection is always new state but remains the same.

> Propose a move, how? Care $h$ is the stationary distribution(what we want), the $q(\cdot|\cdot)$ the proposal distribution.

Update session:


```r
if (runif(1)<MH_ratio){
  x=y
}
```

or in log-scale


```r
if (log_MH_raio>=0||runif(1)<exp(log_MH_ratio)){
  x=y
  }
```

The Metropolis-Hastings update is reversible with respect to $h$, 
Assume $X_n$  is the current state and $Y_n$ is the proposal, we have $X_n=X_{n+1}$ whenever the proposal is rejected. The distribution of $(X_n,X_{n+1})$ given rejection is exchangeable. 相当于恒等映射的可逆的，当然没问题。
Hence, it only remains to be shown that  $(X_n,Y_n)$ is exchangeable given acceptance. We need to show that

$$
\mathrm{E}\left\{f\left(X_{n}, Y_{n}\right) a\left(X_{n}, Y_{n}\right)\right\}=\mathrm{E}\left\{f\left(Y_{n}, X_{n}\right) a\left(X_{n}, Y_{n}\right)\right\}
$$
for any function $f$ that has expectation(assuming $X_n$ has desired stationary distribution). That is, we must show we can interchange arguments of $f$ in
$$
\iint f(x, y) h(x) a(x, y) q(x, y) d x d y
$$
integrals can be replaced by sums if the state is discrete. This follows if we can interchange $x$ and $y$ in
$$
h(x) a(x, y) q(x, y)
$$
because we can exchange $x$ and $y$ in the integration. The set of $x$ and $y$ such that $h(x)>0,q(x,y)>0$ and $a(x,y)>0$ contributes to the integral or (in the discrete case) sum. These inequalities further imply that $h(y)>0$ and $q(y,x)>0$.Thus we may assume these inequalities, in which case we have 
$$
r(y, x)=\frac{1}{r(x, y)}
$$
> 这个式子来源于MH-ratio 中$r$的定义

Suppose that $r(x,y)\leq 1$, so $r(x,y)=a(x,y)$ and $a(y,x)=1$
> 来源于$a(x,y)$ 的定义

Then

$$
\begin{aligned} h(x) a(x, y) q(x, y) &=h(x) r(x, y) q(x, y) \\ &=h(y) q(y, x) \\ &=h(y) q(y, x) a(y, x) \end{aligned}
$$
Conversely, suppose that $r(x,y)>1$, so $a(x,y)=1$ and $a(y,x)=r(y,x)$. Then
$$
\begin{aligned} h(x) a(x, y) q(x, y) &=h(x) q(x, y) \\ &=h(y) r(y, x) q(y, x) \\ &=h(y) a(y, x) q(y, x) \end{aligned}
$$
In either case, we cn exchange $x$ and $y$, the proof is done. 因为 reversible 好像是个更强的。原文：Reversibility implies stationarity,but not vice versa.

### Metropolis Update
 
The special case of the Metropolis-Hastings update when $q(x,y)=q(y,x)$ for all $x$ and $y$. Then the MH-ratio has a simpler form:
$$
r(x,y)=\frac{h(y)}{h(x)}
$$

One obvious way is make proposal as the form $y=x+\epsilon$ where e is stochastically independent of $x$ and symmetrically distributed about zero. Then let $q(x,y)=f(y-x)$, where $f$ is the density of $e$. Widely used proposal is $N(0,\sigma)$ or uniformly distributed on a ball or a hypercube centered at zero.

## The Gibbs Update

The proposal is from a conditional distribution of the desired equilibrium distribution. Always accept version of MH algorithm.

The proof of reversible is :
Suppose $X_n$ has the desired stationary distribution. Suppose that the conditional distribution of $X_{n+1}$ given $f(X_n)$ is same as the conditional distribution of $X_n$ given $f(X_n)$. Then the pair $X_n,X_{n+1}$ is conditionally exchangeable given $f(X_n)$, hence unconditionally exchangeable.

A Gibbs update uses the conditional distribution of one component of the state vector given the rest of the components, that is, the special case of the update described above where $f(X_n)$ is $X_n$ with one component omitted. Conditional distribution of this form are called "full conditionals." There is no reason other than tradition why such conditional distributions should be preferred.

Gibbs updates have one curious property not shared by other MH updates: Gibbs are idempotent, meaning is multiple updates is the same as the effect of just one. Because update never changes $f(X_n)$ .

### Variable-at-a-Time Metropolis-Hastings

Gibbs updates alter only part of the state vector; when using "full conditionals" the part is a single component. Metropolis-Hastings updates can be modified todo the same.

> 所以看来，从理论上来说，最初始的MH是全部待估参数一起来的，但是可以做到类似Gibbs的conditional distribution然后一个一个更新。

Divide the state vector into two parts, $x=(u,v)$. Let the proposal alter $u$ but no $v$. Hence, the proposal density has the form $q(x,u)$ instead of $q(x,y)$ we had in Section before. Again let $h(x)=h(u,v)$ be the unnormalized density of the desired equilibrium distribution. The variable-at-a-time MH update does the following:

- When the current state is $x=(u,v)$, propose a move to $y=(u^*,v)$, where $u^*$ has conditional probability density given $x$ denoted $q(x,\cdot)=q(u,v,\cdot)$.
- Calculate the *Hastings ratio*
$$
r(x, y)=\frac{h\left(u^{*}, v\right) q\left(u^{*}, v, u\right)}{h(u, v) q\left(u, v, u^{*}\right)}
$$
- Accept the proposed move $y$ with probability we defined before, that is, the state after the update is y with porbability $a(x,y)$, and the state after the update is $x$ with probability $1-a(x,y)$.

Actually the sampler run in Metropolis et.al(1953) was a "variable-at-a-time" sampler. So name it as "variable-at-a-time MH" is sometimes of a misnomer. 

> 很显然，因为那么高维一起抽接受率堪忧。。

### The Gibbs is a special case of Metropolis-Hastings:

$x=(u,v)$, v is the part of the state on which the Gibbs update conditions. Doing block Gibbs updating $u$ from its conditional distribution given v. Factor the unnormalized density $h(u,v)=g(v)q(v,u)$, where $g(v)$ is an unnormalized marginal of $v$ and q(v,u) is the conditional of $u$ given $v$. Now do a MH update with $q$ as the proposal distribution.
>也就是说，把h，目标密度，分为g和q，g是initi部分，q是condition部分。则用q的部分作为MH的proposal。则在这种情况下可以得到MH ratio.

$$
r(x, y)=\frac{h\left(u^{*}, v\right) q(u, v)}{h(u, v) q\left(v, u^{*}\right)}=\frac{g(v) q\left(v, u^{*}\right) q(u, v)}{g(v) q(v, u) q\left(v, u^{*}\right)}=1
$$


### Gibbs Full conditional distibution  

为了抽Gibbs，所以我们必须得搞到Full conditional distribution. 通常，我们都是把posterior写出来，然后用和每个系数相关的部分挑出来，看看能不能满足什么分布。而一个很自然的问题就是，为什么要那么做？这么做的理论依据是什么。[这篇课件](http://personal.psu.edu/drh20/515/hw/MCMCexample.pdf) 给了一个相对详细的说明，简单来说就是，道理还是用条件概率公式$\frac{f(\theta_1,\theta_2,y)}{f(\theta_1,y)}=f(\theta_1|\theta_2,y)$.但是呢，因为对normalizing constant不感兴趣，所以直接捡分母那块就搞定。

例子如下：

$$
\begin{aligned} Y_{1}, \ldots, Y_{n} & \stackrel{\mathrm{iid}}{\sim}  N\left(\mu, \tau^{-1}\right) \\ \mu & \sim  N(0,1) \\ \tau & \sim  \mathrm{Gamma}(2,1) \end{aligned}
$$
一个标准的hierachical model。

Likelihood如下：
$$
L(\mu, \tau)=\prod_{i=1}^{n} f\left(Y_{i} | \mu, \tau\right)=\prod_{i=1}^{n} \frac{\sqrt{\tau}}{\sqrt{2 \pi}} \exp \left\{-\tau\left(Y_{i}-\mu\right)^{2} / 2\right\}=(2 \pi)^{-n / 2} \tau^{n / 2} \exp \left\{-\tau \sum_{i=1}^{n}\left(Y_{i}-\mu\right)^{2} / 2\right\}
$$
注意这里Likelihood的形式是$f(Y_i|\mu,\tau)$，是因为这样再乘上prior就是joint distribution了。所以乘上prior得到：

$$
p(\mathbf{Y}, \mu, \tau)=(\text { constant }) \times \tau^{n / 2} \exp \left\{-\tau \sum_{i=1}^{n}\left(Y_{i}-\mu\right)^{2} / 2\right\} \exp \left\{-\mu^{2} / 2\right\} \tau \exp ^{-\tau}
$$

如果$\mathbf{Y}$是观测值，那要得到conditional density of $(\mu,\tau)$ given $\mathbf Y$.则通过条件概率公式，需要：
$$
p(\mu, \tau | \mathbf{Y})=\frac{p(\mathbf{Y}, \mu, \tau)}{p(\mathbf{Y})}=\frac{p(\mathbf{Y}, \mu, \tau)}{\iint p\left(\mathbf{Y}, \mu^{*}, \tau^{*}\right) d \mu^{*} d \tau^{*}}
$$
但是呢，分母对于我们的目标来讲并不重要，因为并不涉及我们关心的变量$(\mu,\tau)$，而$\mathbf{Y}$ 又是观测（数），所以分母就是一个normalising constant,不重要，所以就能写成：
$$
p(\mu, \tau | \mathbf{Y}) \propto p(\mathbf{Y}, \mu, \tau).
$$
现在我们去求我们关心的变量各自的full conditionals.

$$
p(\mu | \tau, \mathbf{Y})=\frac{p(\mu, \tau | \mathbf{Y})}{p(\tau | \mathbf{Y})}
$$
，同样的，分母不关心，因为不涉及$\mu$,所以作为一个关于$\mu$的函数
$$
p(\mu | \tau, \mathbf{Y}) \propto p(\mathbf{Y}, \mu, \tau) \propto \exp \left\{-\tau \sum_{i=1}^{n}\left(Y_{i}-\mu\right)^{2} / 2\right\} \exp \left\{-\mu^{2} / 2\right\}
$$
同样的，作为$\tau$的函数，full conditional for $\tau$是：
$$
p(\tau | \mu, \mathbf{Y}) \propto p(\mathbf{Y}, \mu, \tau)=\tau^{n / 2} \exp \left\{-\tau \sum_{i=1}^{n}\left(Y_{i}-\mu\right)^{2} / 2\right\} \tau \exp ^{-\tau}
$$
.
所以可以简单的说，full condition就是joint posterior只关心所求系数的形式。但是难点在于这个形式是什么分布，见 \@ref(NormalForm)
，这个定理就能断定一类函数形式是Normal distribution。


## Combining Updates

### Composition
Let $P_1,...,P_k$ be update mechanism(computer code) and let $P_1P_2...P_k$ denote the composite update that consists of these updates done in that order with $P_1$ first and $P_k$ last. If each $P_i$ preserves a distribution, then obviously so does $P_1P_2...P_k$.

If $P_1,...,P_k$ are the Gibbs updates foro the "full conditionals" ofo the desired equilibrium distribution, then the composition update is often called a fixed scan Gibbs sampler.

### Palindromic Composition

Note that $P_1P_2...P_k$ is not reversible with respect to the distribution it preserves unless the transition probabilities associated with $P_1P_2...P_k$ and $P_kP_{k-1}...P_1$ are the same.

The most obvious way to arrange reversibility is to make $P_i=P_{k-i}$ for $i=1,...,k$. Then we call this composite update *palindromic*. 

### State-Independent Mixing

Let $P_y$ be update mechanism(computer code), and let $E(P_y)$ denote the update that consists of doing a random one of these updates: generate $Y$ from some distribution and do $P_y$.

> 相当于是 比如给出3个更新机制，随机选一个。

如果Y独立于current state，同时$P_y$ 有同样的分布，则$E(P_y)$ 也一样。如果$X_n$ 有同样的稳定分布，则$X_n$关于Y的条件分布也是同一分布，$X_{n+1}$也有同样的条件分布。
也就是说，Markov chain update with $E(P_Y)$ 是可逆的如果$P_y$是可逆的。

这个mixing一般用于mixture model。

### Subsampling

Let P is an update mechanism, write $P^k$ to denote the k-fold composition of P.

This process is take every kth element of a Markov chain $X_1,X_2,..$ forming a new Markov chain $X_1,X_{k+1},X_{2k+1},...$ is called *subsampling* the original Markov chain.

Subsampling cannot improve the accuracy of MCMC approximation; it must make things worse. The original motivation for subsampling appears to have been to reduce autocorrelation in the subsampled chain to a negligible level. This is only done by before Markov chain CLT was well understood. Now the Markov chain CLT is well understood, this cannot be a justification for subsamplig.


所以唯一有用的部分是just to reduce the amount of output of a Markov chain sampler to manageable levels. Billions of iterations may be needed for convergence, but billions of iterations of output may be too much to handle, especially in R. 

然而batches 方法也可以做到，所以唯一能用subsampling的时候就是不能使用batching的时候。

这种情况很少，所以基本不用sub-sampling...

## A Metropolis Example

Frequency logistic regression.


```r
library(mcmc)
```

```
## Warning: package 'mcmc' was built under R version 3.5.2
```

```r
data("logit")
out=glm(y~ x1+x2+x3+x4,data=logit,family=binomial(),x=TRUE)
summary(out)
```

```
## 
## Call:
## glm(formula = y ~ x1 + x2 + x3 + x4, family = binomial(), data = logit, 
##     x = TRUE)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.7461  -0.6907   0.1540   0.7041   2.1943  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)   
## (Intercept)   0.6328     0.3007   2.104  0.03536 * 
## x1            0.7390     0.3616   2.043  0.04100 * 
## x2            1.1137     0.3627   3.071  0.00213 **
## x3            0.4781     0.3538   1.351  0.17663   
## x4            0.6944     0.3989   1.741  0.08172 . 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 137.628  on 99  degrees of freedom
## Residual deviance:  87.668  on 95  degrees of freedom
## AIC: 97.668
## 
## Number of Fisher Scoring iterations: 6
```

Do this in bayesian analysis where the prior for coefficients are $N(0,2)$.


```r
x <- out$x 
y <- out$y
lupost <- function(beta, x, y, ...) { 
  eta <- as.numeric(x %*% beta)
  logp <- ifelse(eta < 0, eta - log1p(exp(eta)),- log1p (exp(- eta))) 
  logq <- ifelse(eta < 0, - log1p(exp(eta)), - eta - log1p (exp(- eta))) 
  logl <- sum(logp[y == 1]) + sum(logq[y == 0]) 
  return(logl - sum(beta^2) / 8)
}
beta.init <- as.numeric(coefficients(out))
out <- metrop(lupost, beta.init, 1e3, x = x, y = y)
out2=metrop(out,x=x,y=y)
```

The functions in the mcmc package are designed so that if given the output of a preceding run as their first argument, they continue the run of the Markov chain where the other run left off.


It is generally accepted that an acceptance rate of about 20% is right.

Although this magic number can fail, but this is good for most cases, and easy to understand and implement for beginners.





