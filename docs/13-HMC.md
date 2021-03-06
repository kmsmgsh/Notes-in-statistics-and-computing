# Hamiltonian Monte Carlo



### Properties of Hamiltonian Dynamics
1. Hamiltonian dynamics is *reversible*. That is, the mapping $T_{s}$ from the state at time t,$(q(t),p(t))$ to the state at time $t+s,(q(t+s),p(t+s))$, is one-to-one, so hence there exists an inverse, $T_{-s}$.

可以从空间能量那一块来理解，由一个最普通的Hamilton的定义$H(q, p)=U(q)+K(p)$,中，动能部分$K(p)=K(-p)$,而由后文的$K(p)==p^{T} M^{-1} p / 2$,则p是速度，K(p)是动能(kinetic energy)，所以和p的方向无关。所以inverse mapping也可以通过对negating p之后再作用$T_s$,然后再negating p。

在一元的例子中，正逆变换都是逆时针转s radians。

而Hamiltonian dynamics的reversibility对MCMC更新非常重要，这样使用dynamics更新的MCMC就能使稳定分布是需要的分布。最简单证明稳定性的方法就是使用Reversible。

### Conservation of the Hamiltonian

A second property of the dynamics is that it keeps the Hamiltonian invariant (i.e. conserved).

$$
\frac{d H}{d t}=\sum_{i=1}^{d}\left[\frac{d q_{i}}{d t} \frac{\partial H}{\partial q_{i}}+\frac{d p_{i}}{d t} \frac{\partial H}{\partial p_{i}}\right]=\sum_{i=1}^{d}\left[\frac{\partial H}{\partial p_{i}} \frac{\partial H}{\partial q_{i}}-\frac{\partial H}{\partial q_{i}} \frac{\partial H}{\partial p_{i}}\right]=0
$$
等式成立来源于Hamilton's equations.

在一元的例子中，相当于是说旋转变换保持了Hamiltonian的值不变，是half the squared distance from the origin.

在Metropolis updates中，如果用 Hamiltonian dynamics作为proposal的话，也就是HMC，接受率是1如果H能保持invariant. 后面可以看到。但是在实践中只能保持H approximately invariant, 所以我们很难达到这个目标。

### Volume preservation

Hamiltonian dynamics的第三个基础性质是在(q,p)空间内他保持volume。（Liouville's theorem的结论）。如果我们队映射$T_s$作用到一个在（q,p）空间的区域R上的一些点，有体积V,则R在$T_s$的像也有体积V。
在一维的例子中的体现就是映射只是旋转变化，明显不改变面基。当然也不改变区域的形状。后者则不总是成立。Hamiltonian dynamics 可能对区域在某个方向进行拉伸，当这个区域因为在其他方向非常集中，为了保证volume，所以进行拉伸。

在MCMC中，保证volume不变的意以不导致对于任意change in volume in the acceptance probability for Metropolis updates. 改变volume不会导致Metropolis updates的接受概率变化。如果我们考虑proposed新的状态，用一些随机的，非Hamiltonian，dynamics,我们可能会需要去计算Jacobian matrix for the mapping the dynamics defines的行列式，这可能做不到。

由之前的定义，divergence of the vector field have

$$
\sum_{i=1}^{d}\left[\frac{\partial}{\partial q_{i}} \frac{d q_{i}}{d t}+\frac{\partial}{\partial p_{i}} \frac{d p_{i}}{d t}\right]=\sum_{i=1}^{d}\left[\frac{\partial}{\partial q_{i}} \frac{\partial H}{\partial p_{i}}-\frac{\partial}{\partial p_{i}} \frac{\partial H}{\partial q_{i}}\right]=\sum_{i=1}^{d}\left[\frac{\partial^{2} H}{\partial q_{i} \partial p_{i}}-\frac{\partial^{2} H}{\partial p_{i} \partial q_{i}}\right]=0
$$

而有一个结论，A vector field with zero divergence can be shown to preserve volume.

如果不通过divergence，可以有一个不严格的证明。从之前提到的行列式的角度进行思考。

The volume preservation is equivalent to the determinant of the Jacobian matrix of $T_s$ having absolute value one, which is related to the well-known role of this determinant in regard to the effect of transformations on definite integrals and on probability density functions.

Jacobian matrix of $T_s$, $2d\times 2d$, as a mapping of $z=(q,p)$, will be written as $B_s$. In general, $B_s$ will depend on the values of $q$ and $p$ before the mapping. When $B_s$ is diagonal, it is easy to see that the absolute values of its diagonal elements are the factors by which $T_s$ wtrtches or compresses a region in each dimesnions, so that the product of these factos, which is equal to the absolute value of $det(B_s)$, is the factor by which the volume of the region changes. Detail and general prove will not be put here, but, note that if rotate the coordinate system used,  $B_s$ would no longer be diagonal, but the determinant of $B_s$ is invariant to such transformations, and so would still give the gactor by which the volume changes.

Consider Volume preservation for Hamiltonian dynamics in one dimension. Approximate $T_\delta$ for $\delta$ near zero as follows:

$$
T_{\delta}(q, p)=\left[ \begin{array}{c}{q} \\ {p}\end{array}\right]+\delta \left[ \begin{array}{l}{d q / d t} \\ {d p / d t}\end{array}\right]+\text { terms of order } \delta^{2} \text { or higher. }
$$
Taking the time derivatives from the Hamiltonian equation, the Jacobian matrix can be written as
$$
B_{\delta}=\left[ \begin{array}{cc}{1+\delta \frac{\partial^{2} H}{\partial q \partial p}} & {\delta \frac{\partial^{2} H}{\partial p^{2}}} \\ {-\delta \frac{\partial^{2} H}{\partial q^{2}}} & {1-\delta \frac{\partial^{2} H}{\partial p \partial q}}\end{array}\right]+\text { terms of order } \delta^{2} \text { or higher. }
$$

Then we can write the determinant of this matrix as

$$
\begin{aligned} \operatorname{det}\left(B_{\delta}\right) &=1+\delta \frac{\partial^{2} H}{\partial q \partial p}-\delta \frac{\partial^{2} H}{\partial p \partial q}+\text { terms of order } \delta^{2} \text { or higher } \\ &=1+\text { terms of order } \delta^{2} \text { or higher. } \end{aligned}
$$

Since $\log (1+x) \approx x$ for x near zero, $log det (B_\delta)$ is zero, except perhaps the terms of order $\delta^2$ or higher.  Now consider $log det (B_s)$ for some time interval s that is not close to zero let $\delta=s/n$ (现在就close to zero了)，then可以把$T_s$分解成作用n次$T_\delta$, so $det (B_s)$ is the n-fold product of $det(B_\delta)$ evaluated at n points along the trajectory. Then we have

$$
\begin{aligned} \log \operatorname{det}\left(B_{S}\right) &=\sum_{i=1}^{n} \log \operatorname{det}\left(B_{\delta}\right) \\ &=\sum_{i=1}^{n}\left\{\text { terms of order } 1 / n^{2} \text { or smaller }\right\} \\ &=\text { terms of order } 1 / n \text { or smaller. } \end{aligned}
$$
所以对于不靠近0的$B_s$, $log det (B_s)$,也有log几乎为0当$n\rightarrow 0$. 当然在sum过程中，$B_\delta$的值可能会依赖于i，也就是轨迹上的点（p,q）的变化会影响$T_s$. Assumeing that trajectories are not singular, the variation in $B_\delta$ must be bounded along any particular trajectory. （这个没懂，轨迹非退化，那么就有界然后就能通过n收敛？）
所以就preserves volume。

当高于一维的情况，Jacobian matrix有如下形式

$$
B_{8}=\left[ \begin{array}{c}{I+\delta\left[\frac{\partial^{2} H}{\partial q_{j} \partial p_{i}}\right]} & {\delta\left[\frac{\partial^{2} H}{\partial p_{j} \partial p_{i}}\right]} \\ {-\delta\left[\frac{\partial^{2} H}{\partial q_{j} \partial q_{i}}\right]} & {I-\delta\left[\frac{\partial^{2} H}{\partial p_{j} \partial q_{i}}\right]}\end{array}\right]+\text { terms of order } \delta^{2} \text { or higher. }
$$
类似的形式，但是变成了分块矩阵。

高阶的项消掉了，剩下的项处理方式和1维的时候类似。

### Symplecticness (辛？)

volume不变性是Hamiltonian dynamics being symplectic的一个结论。假设$z=(q,p)$, 定义J是$J=\left[ \begin{array}{cc}{0_{d \times d}} & {I_{d \times d}} \\ {-I_{d \times d}} & {0_{d \times d}}\end{array}\right]$, symplecticness condition is that the Jacobian matrix, $B_s$, of the mapping $T_s$ satisfies

$$
B_{s}^{T} J^{-1} B_{s}=J^{-1}
$$
This implies volume conservation, since $det(B^T_s)det(J^{-1})det(B_s)=det(J^{-1})$ 则有$det(B_s)^2=1$. 当d>1的时候，symplecticness condition is stronger than volume preservation. Hamiltonian dynamics and the symplecticness condition can be generalized to where J is any matrix for which $J^T=-J$ and $det(j)\neq 0$.

在实践中，Reversibility, preservation of volume, and symplecticness可以确实被保证，也必须被保证。


## Discretizing Hamilton's Equations: The leapfrog method.

为了在计算机中实现，Hamilton's equations must be approximated by discretizing time, using some small stepsize,$\epsilon$. 在0时刻开始，iteratively compute (approximately) the state at times $\epsilon,2\epsilon,3\epsilon,etc.$

In discussing how to do this, assume that the Hamiltonian has the form $H(q,p)=U(q)+K(p)$. 虽然这个方法对各种定义的动能都适用，但是为了简化操作还是假设$K(p)=p^{T} M^{-1} p / 2$. 然后M是diagonal的，对角元是$m_1,...,m_d$, so that
$$
K(p)=\sum_{i=1}^{d} \frac{p_{i}^{2}}{2 m_{i}}
$$
相当于动能是每个方向上的动能之和。

#### Euler's Method

最广为人知的逼近微分方程系统的解的方法是Euler's method. 对于Hamilton's equations, this method performs the following step, for each component of position and momentum, indexed by i=1,...,d:

$$
\begin{array}{l}{p_{i}(t+\varepsilon)=p_{i}(t)+\varepsilon \frac{d p_{i}}{d t}(t)=p_{i}(t)-\varepsilon \frac{\partial U}{\partial q_{i}}(q(t))} \\ {q_{i}(t+\varepsilon)=q_{i}(t)+\varepsilon \frac{d q_{i}}{d t}(t)=q_{i}(t)+\varepsilon \frac{p_{i}(t)}{m_{i}}}\end{array}
$$
对于每个分量的速度和（势能？），下一时刻的等于这一时刻加上一阶导乘以步长，然后通过Hamilton’s equation就等于另外一个量的变化量。（减去的势能等于增加的动能？增加的动能等于减去的势能？）

对于一般的Euler法解的轨迹并不好,轨迹叉到无穷上了，但是真实的轨道是一个圆、

### Modification of Euler's Method

$$
\begin{array}{c}{p_{i}(t+\varepsilon)=p_{i}(t)-\varepsilon \frac{\partial U}{\partial q_{i}}(q(t))} \\ {q_{i}(t+\varepsilon)=q_{i}(t)+\varepsilon \frac{p_{i}(t+\varepsilon)}{m_{i}}}\end{array}
$$

变化是使用$p_i(t+\epsilon)$代替了$p_i(t)$。也就是说使用了“目前的动量”代替了前一时刻的动量。

图中显示了虽然不完美，但是这个方法更靠近了真实的轨迹。 事实上，修改后的方法确实确保了volue，这样帮助避免发散到无穷或者螺旋地回到起点，这样就让volume expand to infinity or contracting to zero.

要探究modification of Euler's method preserve volume, exactly despite the finite discretization of time, 注意这两个变换 from $(q(t), p(t))$ to $q(t),p(t+\epsilon)$ 通过modification的第一个等式，然后第二个等式是从$(q(t), p(t+\varepsilon))$变换到$(q(t+\varepsilon), p(t+\varepsilon))$. 这是"shear" transformation (剪羊毛？没懂)，每次变换只变换一个值，要么$p_i$，要么$q_i$,这样只会变一个参数，而any shear transformation will preserve volume,因为这样变换的Jacobian只有一个元，并且值为1.

### The leapfrog Method
Leapfrog method可以得到更好的结果

$$
\begin{aligned} p_{i}(t+\varepsilon / 2) &=p_{i}(t)-(\varepsilon / 2) \frac{\partial U}{\partial q_{i}}(q(t)) \\ q_{i}(t+\varepsilon) &=q_{i}(t)+\varepsilon \frac{p_{i}(t+\varepsilon / 2)}{m_{i}} \\ p_{i}(t+\varepsilon) &=p_{i}(t+\varepsilon / 2)-(\varepsilon / 2) \frac{\partial U}{\partial q_{i}}(q(t+\varepsilon)) \end{aligned}
$$
从冲量对应的变量开始半步更新，然后再重新开始做全更新。使用新的（更新了半步的）冲量变量，然后最后做剩下半步冲量变量的更新，使用新的位置变量（$q_i(t+\epsilon)$）。一个类似的方法可以对任何的动能函数成立，只需要用$\partial K / \partial p_{i}$替换$p_{i} / m_{i}$.
这个方法当然也保证了volume，因为第一个更新通过第三个更新是shear transformation，由于对称性，这也是reversible的by simply negating p again.

### Local and Global Error of discretization Methods.

How the error from discretizing the dynamics behaves in the limit as the stepsize, $\epsilon$, goes to zero; Leimkuhler and Reich(2004) provide a much more detail discussion.

The error goes to zero as $\epsilon$ goes to zero, so that any upper limit on the error will apply (apart from a usually unknown constant factor) to any differentiable function of state. For example, if the error for (q,p) is no more than order $\epsilon^2$, the error for $H(q,p)$ will also be no more than order $\epsilon^2$.

The *local error* is the error after one step, that moves from time t to time $t+\epsilon$. The global error is the error after simulating for some fixed time interval, s, which will require $s/epsilon$ steps. 

If the local error is order $\epsilon^p$, the global error will be order $\epsilon^{p-1}$. If we instead fix $\epsilon$ and consider increasing the time, s, for which the trajectory is simulated, the error can in general increase exponentially with s. Interesting. However, this is often not what happens when simulating Hamiltonian dynamics with a symplectic method, as can be seen in Figure. The Euler method and its modification above have order $\epsilon^2$ local error and order $\epsilon$ global error. Leapfrog method has order $\epsilon^3$ local error and order $\epsilon^2$ global error. As shown by Leimkuhler and Reich, this difference is a consequence of leapfrog being reversible, since any reversible method must have global error that is of even order in $\epsilon.$


## MCMC from Hamiltonian Dynamics.

要用Hamiltonian dynamics去得到某个分布的sample需要把density function translate to potential energy function and introducing "momentum" variables to go with the original variables of interest (now seen as "position" variables). We can then simulate a Markov chain in which each iteration resamples the momentum and then does a Metropolis update with a proposal found using Hamiltonian dynamics.

### Probability and the Hamiltonian: Canonical Distributions

可以把要抽的分布函数和一个潜在的能量函数通过 *canonical distribution* 联系起来。给定某些能量函数,$E(x)$,对于某些状态,x,x of some physical system, the canonical distribution over states has probability or probability density function

$$
P(x)=\frac{1}{Z}exp(\frac{-E(x)}{T})
$$
Here, T is the temperature of the system (温度！这是要用上原子（量子？）领域的玩意了吗╮(╯_╰)╭)，比如弄个热力学定律啥的。。。。。或者说温度和动能有某种对应关系？
Z is normalizing constant needed for this function to sum or integrate to one. Viewing this the opposite way, if we are interested in some distribution with density function $P(x)$, we can obtain it as a canonical distribution with $T=1$ by setting $E(x)=-\log P(x)-\log Z$.

为什么这么写是因为，P（x）的值域是(0,1),那么logP(x)则是 $(-\infty,0)$,
$-\log P(x)-\log Z$ 则是$(-\log Z,\infty)$, as long as Z is any convenient positive constant, $-\log Z$可以达到$-\infty$,所以能量函数的值域就是$(-\infty,\infty)$. 或者反过来说就是对能量函数来个log link function让他落到概率区间$(-1,1)$.

A Hamiltonian is an energy function for the joint state of "position", q, and "momentum",p, and so defines a joint distribution for them as follows:

$$
P(q,p)=\frac{1}{Z}exp(\frac{-H(q,p)}{T})
$$

所以一个Hamiltonian就是对当前位置的能量函数q，加上动量函数，p组合起来。所以可以定义一个联合分布如上。
Note that the invariance of H under Hamiltonian dynamics means that a Hamiltonian trajectory will (if simulated exactly) move within a hypersurface of cosntant probability density.
所以这里的Hamiltonian dynamics的不变形就表现在一个Hamiltonian 轨道将会在等常数概率的超平面上移动。
If $H(q,p)=U(q)+K(p)$, the joint density is 
$$
P(q,p)=\frac{1}{Z}exp(\frac{-U(q)}{T})exp(\frac{-K(p)}{T})
$$
and we see that q and p are independent, and each have canonical distributions, with energy functions $U(q)$ and $K(p)$. We will use $q$ to represent the variables of interest, and introduce p just to allow Hamiltonian dynamics to operate.

所以在加情况下的Hamiltonian，就能分成两个分布，把要抽的分布丢进q，然后找一个能形成Hamiltonian dynamics的q就行了。

在Bayesian统计中，模型参数的后验分布是一般比较关心的，所以这些参数会作为位置，q。把后验分布转化成canonical distribution (with T=1) using a potential energy function defined as 
$$
U(q)=-\log [\pi(q) L(q | D)],
$$
where $\pi(q)$ is the prior density, and $L(q|D)$ is the likelihood function given data D.

### The Hamiltonian Monte Carlo Algorithm

下一步就进入HMC。
HMC仅限于$\mathbb R^d$上的连续分布，并且density function can be evaluated(perhaps up to an unknown normalizing constant). For the moment, It will also assume that the density is nonzero everywhere (but this is relaxed in following section). We must also be able to compute the partial derivatives of the log of the density function. These derivatives must therefore exist, except perhaps on a set of point with probability zero, for shich some arbitrary value could be returned.
条件，要求还行？连续，可以算density，可以算log density的偏导。不可导的点的概率测度应为0.
HMC samples from the canonical distribution （就是上式P(q,p)。）q是the distribution of interest, as specified using the potential energy function $U(q)$. 选择distribution of momentum variable,p, 独立于q,然后给定动能函数,K(p). 目前应用在HMC上的主要是二次能量函数，就之前提起来那个，可以让p是0均值的多元正态分布。最经常的设置是the components of p are specified to be independent, with component i having variance $m_i$. The kinetic energy function producing this distribution (Setting T=1) is 
$$
K(p)=\sum_{i=1}^{d} \frac{p_{i}^{2}}{2 m_{i}}.
$$
在5.4会讲$m_i$的选取对表现的影响。

#### The two steps of the HMC algorithm

每次HMC算法的迭代有两部。第一步only the momentum; the second may change both position and momentum. 第二步 may change both position and momentum. Both steps leave the canonical joint distribution of $(q,p)$ invariant, and hence their combination also leaves this distribution invariant.

In the first step, new values for the momentum variables are randomly drawn from their Gaussian distribution, independently of the current values of the position variables. 由上一步的假设，有
$$
p_i\sim N(0,m_i)
$$
因为q没变，p来自于正确的条件分布(conditional on q,但是独立，所以无所谓)。所以这一步明显让canonical joint distribution invariant.
第二步则用Metropolis update,using Hamiltonian dynamics to propose a new state. Starting at current state (q,p), Hamiltonian dynamics is simulated for L steps using the leapfrog method (or other reversible method that preserves volume，所以基础的Euler法不行？因为没有preserve reversible), with stepsize of $\epsilon$. 这里，L和$\epsilon$是模型参数，需要找一个能有好表现的。The momentum variables at the end of this L-step trajectory are then negated, giving a proposed state$(q^*,p^*)$. This proposed state is accepted at the next state of the Markov chain with probability
$$
\min \left[1, \exp \left(-H\left(q^{*}, p^{*}\right)+H(q, p)\right)\right]=\min \left[1, \exp \left(-U\left(q^{*}\right)+U(q)-K\left(p^{*}\right)+K(p)\right)\right]
$$

The negation of the momentum variables at the end of the trajectory makes the Metropolis proposal symmetrical, as needed for the acceptance probability above to be valid. This negation need not be done in practice, since $K(p)=K(-p)$, and the momentum will be replaced before it is used again.(第一步得重新抽。)

所以HMC可以是看做从q和p的联合分布中抽，Metropolis步用了Hamiltonian dynamics的proposal，使得（q,p）的概率分布保持不变，或者几乎不变。移动到（q,p）这一点只靠第一步的随机抽。对于q，Hamiltonian dynamics for $(q,p)$可以产生q的值来自于不同的概率分布，或者等价于一个很不一样的potential energy，$U(q)$.但是，重抽样动量变量依然很难得到q的一个合适的分布，不用重抽样，$H(q, p)=U(q)+K(p)$会是（几乎）常数，而$K(p)$ and $U(q)$是非负的，那么U(q)将不会超出H(q,p)的初始值，如果没有对p的resampling。

> 所以这里的resampling就是指对p的正态抽样？
从他的代码来看，negate momentum的意思就是让p=-p,所以为什么要这样好像提了好几次但是没懂，硕士要让proposal symmetric? 为啥要这样啊


```r
HMC = function (U, grad_U, epsilon, L, current_q)
  {
    q = current_q
    p = rnorm(length(q),0,1)  # independent standard normal variates
    current_p = p
    # Make a half step for momentum at the beginning
    p = p - epsilon * grad_U(q) / 2
    # Alternate full steps for position and momentum
    for (i in 1:L)
    {
      # Make a full step for the position
      q = q + epsilon * p
      # Make a full step for the momentum, except at end of trajectory
      if (i!=L) p = p - epsilon * grad_U(q)
}
    # Make a half step for momentum at the end.
    p = p - epsilon * grad_U(q) / 2
    # Negate momentum at end of trajectory to make the proposal symmetric
    p = -p
    # Evaluate potential and kinetic energies at start and end of trajectory
    current_U = U(current_q)
    current_K = sum(current_pˆ2) / 2
    proposed_U = U(q)
    proposed_K = sum(pˆ2) / 2
    # Accept or reject the state at end of trajectory, returning either
    # the position at the end of the trajectory or the initial position
    if (runif(1) < exp(current_U-proposed_U+current_K-proposed_K))
    {
      return (q)  # accept
    }
else {
      return (current_q)  # reject
    }
}
```

#### Proof that HMC leaves the canonical distribution Invariant.

首先是证Metropolis update是reversible的，并且收敛到canonical distribution function for q and p.这是detail balance condition
思路是$A_k$ 是$(q,p)$ 空间的一个分割，那么用Hamilton dynamic的Metropolis update就能把$A_k$映到$B_k$,由于leapfrog steps的reversibility，所以$B_k$也是$(q,p)$空间的一个分割，并且由于保volume,所以$A_k$的volume和$B_k$的相等。则有下式


$$
P\left(A_{i}\right) T\left(B_{j} | A_{i}\right)=P\left(B_{j}\right) T\left(A_{i} | B_{j}\right)
$$

由于当$i\neq j$时有，$T\left(A_{i} | B_{j}\right)=T\left(B_{j} | A_{i}\right)=0$,而当$i=j$时，由于reversibility，所以成立。故满足detail-balance condition.
当$A_k$和$B_k$越来越小的时候，Hamiltonian变成在每个区域几乎是常数。令这个数是$H_X$在区域$X$中。同安G的，那么canonical probability density and the transition probabilities become effectively constant within each region as well.
那么上式就能变成
$$
\frac{V}{Z} \exp \left(-H_{A_{k}}\right) \min \left[1, \exp \left(-H_{B_{k}}+H_{A_{k}}\right)\right]=\frac{V}{Z} \exp \left(-H_{B_{k}}\right) \min \left[1, \exp \left(-H_{A_{k}}+H_{B_{k}}\right)\right]
$$

这个式子更直接，因为保Volme，所以H不会变，都相等。

Detail-balance implies Metropolis update leaves the canonical distribution for q and p invariant.

下一步是说每一步的概率$P({B_k})$都相等，

$$
\begin{aligned} P\left(B_{k}\right) R\left(B_{k}\right)+\sum_{i} P\left(A_{i}\right) T\left(B_{k} | A_{i}\right) &=P\left(B_{k}\right) R\left(B_{k}\right)+\sum_{i} P\left(B_{k}\right) T\left(A_{i} | B_{k}\right) \\ &=P\left(B_{k}\right) R\left(B_{k}\right)+P\left(B_{k}\right) \sum_{i} T\left(A_{i} | B_{k}\right) \\ &=P\left(B_{k}\right) R\left(B_{k}\right)+P\left(B_{k}\right)\left(1-R\left(B_{k}\right)\right) \\ &=P\left(B_{k}\right) \end{aligned}
$$
The Metropolis update within HMC therefore leaves the canonical distribution invariant.

#### Ergodicity of HMC

Typically, HMC will also be "ergodic". Any value can be sampled for the momentum variables, which can then affect the position variables in arbitrary ways.
However, ergodicity can fail if the L leapfrog steps in a trajectory produce an exact periodicity for some function of state. The one-dimensional example solutions are periodic with period $2\pi$. When $L\epsilon$ is exactly $2\pi$, HMC may return to the same possition coordinate.
For nearby values of $L$ and $\epsilon$, HMC may theoretically ergodic, but take very long time to move about the full state space.

The potential nonergodicity problem can be solved by random choosing $\epsilon$ or L in a fairly small interval. Although in real problems interactions between variables typically prevent any exact periodicities from occurring, near periodicities might still slow HMC considerably.

### Illustrations of HMC and Its Benefits

Now illustrate some practical issues with HMC.

#### Trajectories for a Two-Dimensional Problem

Example 1: Sampling from two variables which is bivariate Gaussian, mean of zero, standard deviations of one, and correlation 0.95. Regard this as "position" variables, and introduce two corresponding "momentum" variables which is also Gaussian (as previous demonstrate), with mean 0 and 1 sd, and 0 correlation. Then the Hamiltonian can be define as 

$$
H(q, p)=q^{T} \Sigma^{-1} q / 2+p^{T} p / 2, \quad \text { with } \Sigma=\left[ \begin{array}{cc}{1} & {0.95} \\ {0.95} & {1}\end{array}\right]
$$


### The benefit of avoiding random walks
最大的好处，HMC会几乎固定的朝一个方向走

### Sampling from a 100-Dimensional Distribution




## HMC in Practice and Theory

Requires proper tuning of $L$ and $\epsilon$. Then the tuning will be discussed below. How performance can be improved by using whatever knowledge is available regarding the scales of variables and their correlations. An additional benefit of HMC- its better scaling with dimensionality than simple Metropolis methods.



### Effect of Linear Transformation

If the variables beging sampled are transformed by multiplication by some nonsingular matrix, A. However, performance stays the same (except perhaps in terms of computation time per iteration), if at the same time the corresponding momentum variables are multiplied by $(A^T)^{-1}$. These facts provide insight into the operation of HMC. Also can help us improve performance when we have some knowledge of the scales and correlations of the variables.

Let new variables be $q'=Aq$. Then $P'(q')=P(A^{-1}q')/|det(A)|$, where $P(q)$ is the density for q. If the distribution for q is the canonical distribution for a potential energy function $U(q)$, we can obtain the distribution for $q'$ as the canonical distribution for $U'(q')=U(A^{-1}q')$. 因为$|det(A)|$ 是一个常数，我们需要不把log|deta(A)| 放到potential energy里面。

用之前的动能函数，但是把动量变量变成$p'=(A^T)^{-1}p$,然后新的动能方程是$K'(p')=K(A^Tp')$. 如果使用二次型的动能,$K(p)=p^{T} M^{-1} p / 2$,则新的动能是


$$
K^{\prime}\left(p^{\prime}\right)=\left(A^{T} p^{\prime}\right)^{T} M^{-1}\left(A^{T} p^{\prime}\right) / 2=\left(p^{\prime}\right)^{T}\left(A M^{-1} A^{T}\right) p^{\prime} / 2=\left(p^{\prime}\right)^{T}\left(M^{\prime}\right)^{-1} p^{\prime} / 2
$$
其中，$M^{\prime}=\left(A M^{-1} A^{T}\right)^{-1}=\left(A^{-1}\right)^{T} M A^{-1}$.

如果我哦们用动能变量的变形，则Hamiltonian Dynamics对于新的变量,$(q',p')$,足够重复原始的dynamics（对于(q,p)）的，所以HMC的表现应该是一样的。为了证明这个，假设我们有对于$(q',p')$的Hamiltonian dynamics,结果对于原来的变量则是

$$
\begin{aligned} \frac{d q}{d t} &=A^{-1} \frac{d q^{\prime}}{d t}=A^{-1}\left(M^{\prime}\right)^{-1} p^{\prime}=A^{-1}\left(A M^{-1} A^{T}\right)\left(A^{T}\right)^{-1} p=M^{-1} p \\ \frac{d p}{d t} &=A^{T} \frac{d p^{\prime}}{d t}=-A^{T} \nabla U^{\prime}\left(q^{\prime}\right)=-A^{T}\left(A^{-1}\right)^{T} \nabla U\left(A^{-1} q^{\prime}\right)=-\nabla U(q) \end{aligned}
$$
结果和原始的Hamiltonian dynamics for (q,p)一样。

如果A是正交矩阵，$A^{-1}=A^{T}$,则HMC的performance不会变，如果对q 和 p 乘以A。
如果我们给动量选择了一个旋转对称分布，with $M=mI$.(momentum variables are independent, each having variance m).这些变换不会对能量函数造成变化，所以也不会对momentum的distribution造成变化。因为我们有$M^{\prime}=\left(A(m I)^{-1} A^{T}\right)^{-1}=m I$.

如果RWM的proposal也有rotation symmetric的性质（比如Gaussian with covariance matrix mI）. Gibbs 则没有rotationally invariant. 但是，Gibbs对某个变量的rescaling是不变的。 Gibbs sampling is not rotationally invariant, nor is a scheme in which the Metropolis algorithm is used to update each variable in turn. However, Gibbs sampling is invariant to rescaling of the variables(transformation by a diagonal matrix), which is not true for HMC or random-walk Metropolis, unless the kinetic energy or proposal distribution is transformed in a corresponding way.

Suppose that we have estimate, $\Sigma$, of the covariance matrix for q, and suppose also that q has at least a roughly Gaussian distribution. How can we use this information to improve the performance of HMC? One way is to transform the variables so that their covariance matrix is close to the identity, by finding the Cholesky decomposition, $\Sigma=LL^T$, which L being lower-triangular, and letting $q'=L^{-1}q$. We then let our kinetic energy function be $K(p)=p^Tp/2$.

Since the momentum variables are independent, and the position variables are close to independent with variances close to one, HMC should perform well using trajectories with a small number of leapfrog steps, which will move all variables to a nearly independent point More realistically, the estimate $\Sigma$ may not be very good, but this transformation could still improve performance compared to using the same kinetic energy with the original q variables.

An equivalent way to make use of the estimated covariance $\Sigma$ is to keep the original $q$ variables, but use the kinetic energy function $K(p)=p^{T} \Sigma p / 2$, that is, we let the momentum variables have covariance $\Sigma^{-1}$. The equivalence can be seen by transforming this kinetic energy to correspond to a transformation to $q'=L^{-1}q$, which gives $K(p')=(p')^TM'^{-1}p'$ with $M^{\prime}=\left(L^{-1}\left(L L^{T}\right)\left(L^{-1}\right)^{T}\right)^{-1}=I$.

也就是说，如果我们知道position的covariance，那么通过线性变换把这个相关性除掉，然后再有动量变量设为独立的，那么就是两个独立变量的抽，这样HMC的trajectories就只用很小的leapfrog step就能遍历附近的独立的点。就算$\Sigma$的估计不好，但是这个变换也能提高HMC的表现效果。

这个方法的限制是当矩阵很大的时候，矩阵运算很花时间。
所以对于高维问题一般用对角的covariance matrix $\Sigma$ ,相当于只考虑variable的scale而不考虑之间的相关性。

### Tuning HMC

一个HMC应用的阻碍是需要选择合适的Leapfrog step, $\epsilon$, 以及Leapfrog steps的迭代次数，L。这两个参数共同决定了轨道的虚时间。大部分mcmc方法都有参数需要tuned，除了Gibbs，推出来全条件分布以后就能直接抽了。但是，tuning HMC比起其他简单的Metropolis会更难。

#### Preliminary Runs and Trace Plots

要Tuning HMC一般需要先尝试性的run几次去寻找$\epsilon$和L。为了判断这几次run的效果如何， trace plots of quantities that are thought to be indicative of overall convergence should be examined. 但是尝试性的run也可能会造成misleading。因为$\epsilon$和$L$的最佳选择不一定是第一次达到平稳的时候的选择。如果必要的话，HMC的每一步迭代中，$\epsilon$和 $L$都进行随机选取。
建议多跑跑几次基于不同的随机性设置，这样比较隔绝的极大值点就更容易被探测到。和其他所有MCMC方法相比，HMC不会更少（或者更多）容易被隔离的极值点所影响。如果找到了有隔离的极值点存在，需要做一些事情去处理这个问题。只是把约束在单个极值点的链组合起来是不可取的，可以尝试使用沿着解集轨道“tempering”回火结合的HMC进行处理多个极值点问题。

#### What Stepsize?

选取一个合适的leapfrog stepsize $\epsilon$也是很重要的。 太大的stepsize会导致很低的接受率，太小的stepsize会浪费很多计算时间。

幸运的是，stepsize的选择几乎与要走多少步(L)独立。Hamiltonian的误差，基本上不会因为多走几步而增加，所以stepsize如果足够小的话，这个dynamics会很稳定。

Stability的问题可以从一个一维的问题中看出
$$
H(q, p)=\frac{q^{2}}{2 \sigma^{2}}+\frac{p^{2}}{2}
$$
q的分布是$N(0,\sigma^2)$ ,对这个系统的leapfrog step是一个线性映射从$(q(t),p(t))$到$(q(t+\epsilon),p(t+\epsilon))$. 从之前Leapfrog方法的定义式中可以dehumidifier，这个线性变换可以表述成如下的矩阵形式：

$$
\left[ \begin{array}{c}{q(t+\varepsilon)} \\ {p(t+\varepsilon)}\end{array}\right]=\left[ \begin{array}{cc}{1-\varepsilon^{2} / 2 \sigma^{2}} & {\varepsilon} \\ {-\varepsilon / \sigma^{2}+\varepsilon^{3} / 4 \sigma^{4}} & {1-\varepsilon^{2} / 2 \sigma^{2}}\end{array}\right] \left[ \begin{array}{l}{q(t)} \\ {p(t)}\end{array}\right]
$$
所以这个映射到底是会有一个稳定的轨道呢，还是会发散到无穷，由这个线性变换的矩阵的特征值所决定，而这个特征是
$$
\left(1-\frac{\varepsilon^{2}}{2 \sigma^{2}}\right) \pm\left(\frac{\varepsilon}{\sigma}\right) \sqrt{\varepsilon^{2} / 4 \sigma^{2}-1}
$$
当$\frac{\epsilon}{\sigma}>2$时，特征值是实数，所以存在至少一个绝对值大于1的根。此时，解的轨道使用Leapfrod 方法用这个$\epsilon$算就会unstable。当$\epsilon/\sigma<2$时，特征值是复数，然后有如下性质：
$$
\left(1-\frac{\varepsilon^{2}}{2 \sigma^{2}}\right)^{2}+\left(\frac{\varepsilon^{2}}{\sigma^{2}}\right)\left(1-\frac{\varepsilon^{2}}{4 \sigma^{2}}\right)=1
$$
所以Trajectory此时就是stable的。

对于多元的问题，动能函数选择$K(p)=p^Tp/2$，则stability的限制就会由distribution的宽度，在最受限制的方向。比如说对于Gaussian分布，这个东西将会是q的协方差矩阵最小特征值的平方根。而如果使用带质量阵的动能函数$K(p)=p^{T} M^{-1} p / 2$,则可以使用之前提到的线性变换的方法变成上面这种情况再去求特征值。


如果使用一个会产生不稳定轨道的$\epsilon$,那么H的值就会随着L以指数级增大，并且会导致接受概率极端的小。对于低维的问题，使用一个稍微比stability limit小的$\epsilon$也足够能得到一个比较好的接受率。但是对于高维就不一样，stepsize可能需要reduced further than this才能让error in H to a level that produces a good acceptance probability.

如果使用过大的$\epsilon$,那么可能会对HMC的表现产生非常不好的影响。在这种情况下，HMC会对tuning更加的敏感，甚至超过RWM。RWM需要选择一个scaling，作为random walk的deviation，但是表现的变化是相对很光滑的，而不像HMC当$\epsilon$超出stability limit的范围之后，会急剧的下降。（但是高维的情况RWM也会变化的很剧烈，所以这个区别并不是很明显）。

当Stepsize太大导致的HMC表现急剧下降不是一个很重要的问题如果stability limit是一个常数，这个问题很明显来自于实验性的run，所以可以被修复。Real danger是stability limit may differ for several regions of the state space that all have substantial probability. 当preliminary runs开始于一个stability limit很大的区域，那么去一个稍微小一点的$\epsilon$可能会比较合适。但是如果对于其他区域这个$\epsilon$还是超过了stability limit，那么可能HMC永远不会访问这个区域，甚至这个区域有不可忽略的概率也不行，会导致非常严重的错误。为什么这会发生呢，考虑如果run ever does visit the region where the chosen $\epsilon$ would produce instability, it wills tay there for a very long time, since the acceptance probability with that $\epsilon$ will be very small.如果run到了这个区域，会因为接受概率一直很小所以就呆在这里很长时间。尽管HMC产出的是稳定分布，但是基本上不会从一个$\epsilon$是stability的移动的这边。一个例子是如果从一个very light tails的分布进行抽样，（lighter than Gaussian distribution）,for which the log of the density will fall faster than quadratically. In the tails, the gradient of the log density will be large, and a small stepsize will be needed for stability. 这个在Langevin method中有详细描述。


这个问题可以通过选取一个随机的$\epsilon$进行减轻。即便这个分布的均值太大，合适的小的$\epsilon$也有可能偶尔会选到。随机选择步长应该处于计算轨道之前，而不是每次更新轨道leapfrog step的时候。有一个“捷径”方法能够当随机选取的步长不合适的时候节约计算时间。


#### What Trajectory Length?

选取一个合适的轨道长度对于一个要系统的，而不是随机游走的探索状态空间的HMC非常重要。很多分布非常难以取样因为他们紧紧的在某些方向被约束住了，但是在其他方向的约束没那么紧。用足够长的轨道就能探索没那么多限制的方向。

但是轨道也可能过长。

对于更复杂的问题，不能用肉眼观察轨道的长度选取的如何，找到变量的线性组合使得约束最小会非常困难，甚至于不可能，当最小的方向其实是一个非线性曲线或者平面的时候。
所以对tajectory长度的试错在某些情况就很有必要。假设对于某些非常困难的问题，用一个L=100的轨道可能会合适starting point。如果实验性的run（和某些合适的$\epsilon$）,显示HMCHMC达到了几乎独立的点在一次迭代之后，一个更小的L值可能就应该在下一步的时候使用。如果是是L=100还是有很高的自相关的话，可能得在下一次迭代中尝试$L=1000$.

之后会讨论随机变化的轨道长可能很有必要。这样可以避免选到一个靠近周期性的长度。

#### Using Multiple Stepsizes.

所以可以通过找相对的variable的scales去提高HMC的表现。这可以通过两个等价的方法得到。第一个是如果$s_i$是$q_i$合适的scale，我们可以变换q，使得$q_{i}^{\prime}=q_{i} / s_{i}$.或者也可以用另外一个动能函数$K(p)=p^TM^{-1}p$,其中M的对角元是$m_i=1/s_i^2$.
第三种等价方式是最方便的，是使用不同的stepsizes for different pairs of position and momentum variables. 考虑一个leapfrog update with $m_i=1/s_i^2$:
$$
\begin{aligned} p_{i}(t+\varepsilon / 2) &=p_{i}(t)-(\varepsilon / 2) \frac{\partial U}{\partial q_{i}}(q(t)) \\ q_{i}(t+\varepsilon) &=q_{i}(t)+\varepsilon s_{i}^{2} p_{i}(t+\varepsilon / 2) \\ p_{i}(t+\varepsilon) &=p_{i}(t+\varepsilon / 2)-(\varepsilon / 2) \frac{\partial U}{\partial q_{i}}(q(t+\varepsilon)) \end{aligned}
$$
Define $(q^{(0)},p^{(0)})$ 为leapfrog的开始点，然后定义$\left(q^{(1)}, p^{(1)}\right)$ to be the final state (i.e.$(q(t+\varepsilon), p(t+\varepsilon))$),定义$p^{(1/2)}$作为半途的动量。我们现在重新写leapfrog step如下：
$$
\begin{aligned} p_{i}^{(1 / 2)} &=p_{i}^{(0)}-(\varepsilon / 2) \frac{\partial U}{\partial q_{i}}\left(q^{(0)}\right) \\ q_{i}^{(1)} &=q_{i}^{(0)}+\varepsilon s_{i}^{2} p_{i}^{(1 / 2)} \\ p_{i}^{(1)} &=p_{i}^{(1 / 2)}-(\varepsilon / 2) \frac{\partial U}{\partial q_{i}}\left(q^{(1)}\right) \end{aligned}
$$
这是一个标准的leapfrog更新过程，以下就加上rescaled momentum variables: $\tilde{p}_{i}=s_{i} p_{i}$ 并且有步长$\epsilon_i=s_i\epsilon$, 我们可以写leapfrog update如下：

$$
\begin{aligned} \tilde{p}_{i}^{(1 / 2)} &=\tilde{p}_{i}^{(0)}-\left(\varepsilon_{i} / 2\right) \frac{\partial U}{\partial q_{i}}\left(q^{(0)}\right) \\ q_{i}^{(1)} &=q_{i}^{(0)}+\varepsilon_{i} \tilde{p}_{i}^{(1 / 2)} \\ \tilde{p}_{i}^{(1)} &=\tilde{p}_{i}^{(1 / 2)}-\left(\varepsilon_{i} / 2\right) \frac{\partial U}{\partial q_{i}}\left(q^{(1)}\right) \end{aligned}
$$
这就是像一个leapfrog update对于$m_i=1$,但是对于不同的$(q_i,p_i)$对有不同的stepsize。当然，这个连续的$(q,\tilde p)$ 不在被解释为一个Hamiltonian dynamics在一致的时间点，但是没有结论说使用这些HMC的轨道。注意当我们在计算轨道之前抽栋梁的时候，每一个$\tilde p_i$ 是独立的来自于Gaussian分布（$N(0,I)$），而不是$s_i$.
这个多个stepsize的方法一般来说是最便利的，特别是估计的scales，$s_i$不是固定的，然后momentum只是partially refreshed。


### Combining HMC with Other MCMC Updates

对于某些问题，MCMC孤立的使用HMC是不可能或者不受欢迎的。两个情况Non-HMC更新将会很有必要，1当某些变量是离散的，2当log probability density的导数很难计算或者不可能计算的时候。

这种情况的时候，HMC可以只对其他变量生效。另外一个例子是当特殊的MCMC更新过程可以帮助MCMC收敛，同时HMC不会，比如说，从两个孤立的极值点之间移动。但是并不会完全代替HMC。下面将会讨论，比如说Bayesian hierarchical models可能用HMC结合Gibbs最好。
在这些情况里，一个或者多个HMC updates对于所有变量，或者变量的子集可以代替一个或者多个更新，从而使得对于全部变量的联合分布保持稳定invariant. 
没看懂
The HMC updates can be viewed as either leaving this same joint distribution invariant, or as leaving invariant the conditional distribution of the variables that HMC changes, given the current values of the variables that are fixed during the HMC udpate. These are equivalent views.

When both HMC and other updates are used, it may be best to use shorter trajectories for HMC than would be used if only HMC were being done. This allows the other updates to be done more often, which presumably helps sampling. Finding the optimal tradeoff is likely to be difficult, however, A variation on HMC that reduces the need for such a tradeoff is described below.

### Scaling with Dimensionality

Main benefits of HMC was illustrated, its ability to avoid the inefficient exploration of the state space via a random walk.


#### Creating Distributions of Increasing Dimensionality by Replication

How performance scales with dimensionality, assume something about how the distribution changes with dimensionality, $d$.

Dimensionality increases by adding independent replicas of variables- that is, the potential energy function for $q=(q_1,...,q_d)$ has the form $U(q)=\sum u_i(q_i)$, for functions $u_i$ drawn independently from some distribution. 实际情况肯定不是这样，但是这样可以作为一个有道理的模型来看看提高维度对某些问题的影响。

虽然在独立的情况下Gibbs表现的非常好，对每个变量进行Metropolis update 也很好，但是这两个算法都是not invariant to rotation. 所以对于某些特殊问题表现可能就不会太好。

#### Scaling of HMC and Random-Walk Metropolis

Discuss informally how well HMC and random-walk Metropolis scale with dimension, loosely following Creutz.

The following relationship holds when any Metropolis-style algorithm is used to sample a density $P(x)=(1 / Z) \exp (-E(x))$:
$$
1=\mathrm{E}\left[P\left(x^{*}\right) / P(x)\right]=\mathrm{E}\left[\exp \left(-\left(E\left(x^{*}\right)-E(x)\right)\right)\right]=\mathrm{E}[\exp (-\Delta)]
$$
当x是目前的状态，假设分布是$P(x)$,$x^*$ 是proposed state，任意的$\Delta=E\left(x^{*}\right)-E(x)$. Jensen's inequality暗示了能量的区别是非负的
$$
\mathrm{E}[\Delta] \geq 0
$$
不等式一般情况下是严格的。

> 有个问题，怎么通过Jesen不等式得到这个？
Jesen不等式的形式：$\varphi(\mathrm{E}[X]) \leq \mathrm{E}[\varphi(X)]$ 怎么和$\Delta$那个形式联系起来？感觉好奇怪.想复杂了，就是因为那个1的问题，然后用jesen不等式，也就是函数在里面是1，所以函数在外面就大于等于log(1)=0



When $U(q)=\sum u_i(q_i)$ and proposals are produced independently for each i, we can apply these relationship either to a single variable (or pair of variables) or to the entire state. For a single variable(pair), write $\Delta_1$ for $E(x^*)-E(x)$, with $x=q_i$ and $E(x)=u_i(q_i)$

> 中间过程没怎么看懂，看看结论先。

With increasing dimension by replicating variables will lead to increasing energy differences, since $\Delta _d$ is the su of $\Delta_1$ for each variable, each of which has positive mean. This will lead to a decrease in the acceptance probability , which is $min(1,exp(-\Delta_d))$ unless the width of the proposal distribution or the leapfrog stepsize is decreased to compensate.


> 后面的大致意思是对于RWM维度越高，那么对于目前状态和proposal的state，potential energy的差异是每个变量造成的差异之和。如果使用固定的标准差$\zeta$，potential energy difference的mean and variance随着d增大线性增长。这样会导致很低的接受率。所以为了保证能接受的表现，标准差应该随着d增加而降低，iteration次数应该需要保证几乎独立的点。

而和RWM类似，HMC的话，q是独立的，使用能量函数$K(p)=\Sigma p_{i}^{2} / 2$,不同的$(q_i,p_i)$ 组都能服从Hamiltonian dynamics通过potential energy 用q，Kinetic energy用p。而解轨道中的虚拟世界虚拟时间不会随着维度增加而增加(我觉得是指$\epsilon L$不受维度影响？)但是使用leapfrog方法得到的proposal state的接受概率是the sum of the errors pertaining to each $(q_i,p_i)$ pair. 对于固定的步长$\epsilon$,一个固定的轨道长度，$\epsilon L$, mean and variance of the error in H grow linearly with d. This will also lead a progressively lower acceptance rate as dimensionality increases. 

所以为了判断哪个方法更好需要决定我们需要多迅速的改变$\zeta$ 和 $\epsilon$ 当d 增加的时候。当d增加的时候，那么$\eta$和$\epsilon$会趋向于0，同时$\Delta_1$ 将会也趋于0。使用二阶逼近$exp(-\Delta_1)$，则有$1-\Delta_{1}+\Delta_{1}^{2} / 2$ ，则带入上式就有
$$
\mathrm{E}\left[\Delta_{1}\right] \approx \frac{\mathrm{E}\left[\Delta_{1}^{2}\right]}{2}
$$

则对于$\Delta_1$方差,是均值的2倍,那么对于$\Delta_d$的方差也是其2倍均值。（even when $\Delta_d$ is not small）.

为了达到一个好的接受率，我们必须保证$\Delta_d$在1附近，since a large mean will not be saved by a similarly large standard deviation(which would produce fairly frequent acceptances as $\Delta_d$ occasionally takes on a negative value).

It follows that $E[\Delta_d]$ is proportional to $d^2_\zeta$, wo we can maintain a reasonable acceptance rate by letting $\zeta$ be proportional to $d^{-1/2}$. The number of iterations needed to reach a nearly independent point will be proportional to $\zeta^{-1/2}$. The number of iterations needed to reach a nearly independent point will be proportional to $\zeta^{-2}$, which will be proportional to d.



#### Optimal Acceptance Rates


继续扩展以上的理论，我们可决定如果基于最优的tuning parameter$\zeta$或者$\epsilon$,对应的接受率是多少。

为了找到这个接受率，我们先注意Metropolis methods满足Detailed Balance条件，接受概率对于正负$\Delta_d$是一样的。因为所有的proposal对于负的$\Delta_d$ 都接受，所以接受率一般来说是简单的两倍概率对于proposal有一个负的$\Delta_d$.对于一个很大的d，中心极限定理暗示了$\Delta_d$的分布是Gaussian，因为其为d个独立的$\Delta_1$的值。

因为$\Delta_d$的方差是二倍均值，$E[\Delta_d]=\mu$. 则接受概率能写成如下形式：
对于大的d有：

$$
P(\text { accept })=2 \Phi\left(\frac{(0-\mu)}{\sqrt{2 \mu}}\right)=2 \Phi(-\sqrt{\mu / 2})=a(\mu)
$$

$\Phi(z)$ 是标准高斯的累计分布函数。

对于RWM，得到一个独立的点的花销与$1/(a\zeta^2)$成比例。我们可以从上面看出$\mu=E[\Delta_d]$ 与$\zeta^2$成比例，所以花销服从以下比例
$$
C_{\mathrm{rw}} \propto \frac{1}{(a(\mu) \mu)}
$$
数值计算发现这个极小当$\mu=2.8$和$a(\mu)=0.23$

The same optimal $23\%$ acceptance rate for random-walk Metropolis was previously obtained using a more formal analysis by Roberts et al (1997). The optimal 65% acceptance rate for HMC .


#### Exploring the Distribution of Potential Energy

更好的Scaling会让HMC的表现取决于resampling of the momentum variables. 我们可以看到考虑how well the methods explore the distribution of the potential energy, $U(q)=\sum u_i(q_i)$ .用动量的变量去探索能量函数。

>等等，能量不应该是distribution of interest吗？得返回去看看

Because $U(q)$ is a sum of d independent terms, its standard deviation will grow in proportion to $d^{1/2}$.

根据Caracciolo et al.(1994),expected change in potential energy from a single Metropolis update will be no more than order 1- intuitively, large upwards canges are unlikely to be accepted, and since Metropolis updates satisfy detailed balance, large downward changes must also be rare(in equilibrium). Because changes in $U$ will follow a random walk (due again to detailed balance). 因为U中的改变将会服从一次随机游走（也是一万年detailed balance），it will take at least order $(d^{1/2}/1)^2=d$ Metropolis updates to explore the distribution of $U$.

在HMC的第一步中，动量的重抽量一般贵改变潜在能量by an amount that is proportional to $d^{1/2}$,因为kinetic energy is also a sum of d independent terms, and hence has standard deviation that grows as $d^{1/2}$ (more precisely, its standard deviation is $d^{1/2}/2^{1/2}$). If the second step of HMC proposes a distant point this change in kinetic energy (and hence in H) will tend, by the end of the trajectory, to have become equally split between kinetic and potential energy. If the endpoint of this trajectory is accepted, the change in potential energy from a single HMC iteration will be proportional to $d^{1/2}$, comparable to its overall range of variation. So, in contrast to random-walk Metropolis, we may hope that only a few HMC iterations will be sufficient to move to a nearly independent point, even for high-dimensional distributions.
Analyzing how well method explore the distribution of $U$ can also provide insight into their performance on distributions that are not well modeled by replication of variables, as we will see in the next section.

> 这个order又是怎么一回事。。。

### HMC for Hierarchical Models

Many Bayesian models are defined hierarchically. A large set of low-level parameters have prior distributions that are determined by fewer higher-level "hyperparameters," which in turn may have priors determined by fewer higher-level"hyperparameters," which in turn may have priors determined by yet-higher-level hyperparameters.

可以应用HMC于这些模型通过一个很显然的办法： (注意对variance hyperparameters做一个log变换，使得无限制)。然而，最好应用HMC仅仅对lower-level parameters, 原因以下会讨论，（5.4.3一般性的讨论了如何applying HMC对variable的子集。）
Bayesian neural network model会作为一个例子。这些模型一般来讲有几组low-level parameters,每个associated variance hyperparameter. The posterior distribution of these hyperparameters reflects important aspects of the data,比如说哪些变量和目标任务最相关。The efficiency with which values for these hyperparameters are sampled from the posterior distribution can often determine the overall efficiency of the MCMC method.
抽样hyperparameter的efficiency决定了MCMC的全局效率？？
I use HMC only for the low-level parameters in Bayesian neural network models, with the hyperparameters being fixed during an HMC update. These HMC updates alternate with Gibbs sampling updates of the hyperparameters, which (in the simpler versions of the models) are independent given the low-level parameters, and have conditional distributions of standard form.
所以用HMC的只是“低阶”变量，超参数则用Gibbs更新，一个混合的过程。The leapfrog stepsizes used can be set using heuristic that are based on the current hyperparameter values. (I use the multiple stepsize approach described at the end of Section 5.4.2, equivalent to using different mass values, $m_i$, for different parameters.)leapfrog方法的步长用启发式方法进行决定，基于目前的超参数。比如说，the size of the network "weights" on connections out of a "hidden unit" determine how sensitive the likelihood function is to changes in weights on connections into the hidden unit; the variance of the weights on these outgoing connections.  If the hyperparameters were changed by the same HMC updates as change the lower-level parameters, using them to set stepsizes would not be valid， since a reversed trajectory would use different stepsizes, and hence not retrace the original trajectory. Without a good way to set setpsizes, HMC for the low-level parameters would likely be much less efficient.

> 真不是很懂好奇怪，大概emmmm，这样更新会有点问题，所以只用一部分？

Choo(2000) bypassed （跳过了？） this problem by using a modification of HMC in which trajectories are simulated by alternating leapfrog steps tha update only the hyperparameters with leapfrog steps that update only the low-level parameters. This procedure maintains both reversibility and volume preservation. However, performance did not improve as hoped because of a second issue with hierarchical models.

In these Bayesian neural network models, and many other hierarchical models, the joint distribution of both low-level parameters and hyperparameters is highly skewed.

## Extensions of and Variations on HMC

Modify the basic HMC algorithm can be done in many ways. Improve its efficiency, make it useful for a wider range of distribution.

Alternatives to the leapfrog discretization of Hamilton's equation will be discussed. Also how the HMC handle distributions with constraints on the variables. 
Another algorithm that leapfrog step only done once, which may be useful when not all variables are updated by HMC.

Computing a short cut method that avoids computing the whole trajectory when the stepsize is inappropriate.

### Discretization by Splitting: Handling constraints and Other Applications

Leapfrog method 不是解决Hamilton's等式，保证volume和reversible的唯一方法。所以也有其他方法可以用于HMC。 很多"symplectic integration method"被设计出来了，很多用于其他方面的应用而不是HMC（比如模拟太阳系几百万年的运行用于检验稳定性。）设计一个有更高阶的准确度的方法是可能的，比如（McLachlan and Atela,1992）。使用这些方法在HMC上，当维度增加时HMC的会渐进地产出更好的结果。尽管如此，还是值得研究Hamiltonian dynamics如何被模拟，这样才能指出如何处理variable的constrain，也可以提高探索偏分析的结果。

#### Splitting the Hamiltonian

Many symplectic discretization of Hamiltonian dynamics can be derived by "splitting" the Hamiltonian into several terms, and then, for each term in succession, simulating the dynamics defined by that term for some small time step,
很多辛离散化Hamiltonian dynamics可以用“splitting” Hamiltonian 成为几项导出，然后对于每项一连串的模拟dynamics由定义一些小的时间步骤，重复这个过程知道达到要求的总模拟时间。如果每一项的模拟可以解析的得到，那么我们可以得到辛逼近对dynamics如果可以做到的话。

这个更一般的方法可以从Leimkuhler and Reich (2004,section4.2)和(Sexton and Weingarten (1992))找到.

假设Hamiltonian可以写成k个项的和

$$
H(q, p)=H_{1}(q, p)+H_{2}(q, p)+\cdots+H_{k-1}(q, p)+H_{k}(q, p)
$$
假设我们能 *exactly* 实现Hamiltonian dynamics 基于每个$H_i$,for $i=1,...,k$, with $T_{i,\epsilon}$ 作为一个映射定义在应用dynamics基于$H_i$ for time $\epsilon$. As shown by Leimkuhler and Reich, 如果$H_i$ 二阶可微，那么这些映射的组合$T_{1, \varepsilon} \circ T_{2, \varepsilon} \circ \cdots \circ T_{k-1, \varepsilon} \circ T_{k, \varepsilon}$,是一个可行的离散化Hamiltonian dynamics 基于H。 这个会产生exact dynamics in the limit $\epsilon$ goes to zero, with global error of order $\epsilon$ or less.

更多的，这个离散化将会保volume,也是symplectic的，因为这些性质对每个$T_{i,\epsilon}$都成立。这个离散化也是reversible的,如果$H_{i}(q, p)=H_{k-i+1}(q, p)$.就如前文所提到的，所有的reversible的方法都有偶数阶的global error in $\epsilon$,意味着global error must be of order $\epsilon^2$,或者更好。

我们可以推出leapfrog方法来自于对称分解Hamiltonian，如果有$H(q, p)=U(q)+K(p)$,那么我们可以把Hamiltonian写成
$$
H(q, p)=\frac{U(q)}{2}+K(p)+\frac{U(q)}{2}
$$
与之对应的分解是$H_{1}(q, p)=H_{3}(q, p)=U(q) / 2$和 $H_{2}(q, p)=K(p)$,则此时Hamiltonian dynamics基于$H_1$就是
$$
\begin{aligned} \frac{d q_{i}}{d t} &=\frac{\partial H_{1}}{\partial p_{i}}=0 \\ \frac{d p_{i}}{d t} &=-\frac{\partial H_{1}}{\partial q_{i}}=-\frac{1}{2} \frac{\partial U}{\partial q_{i}} \end{aligned}
$$
应用这个dynamics for time $\epsilon$,just adds $-(\epsilon/2)\partial U / \partial q_{i}$ to each $p_i$, which is the first part of a leapfrog step. The dynamics based on $H_2$ is as follows:


$$
\begin{aligned} \frac{d q_{i}}{d t} &=\frac{\partial H_{2}}{\partial p_{i}}=\frac{\partial K}{\partial p_{i}} \\ \frac{d p_{i}}{d t} &=-\frac{\partial H_{2}}{\partial q_{i}}=0 \end{aligned}
$$
If $K(p)=\frac{1}{2}\sum p_i^2/m_i$, applying this dynamics for time $\epsilon$ results in adding $\epsilon p_i/m_i$ to each $q_i$ which is the second part of a leapfrog step. Finally, $H_3$ produces the third part of a leapfrog step (Equation 5.20), which is the same as the first part, since $H_3=H_1$.


> 以下感觉吃力了，需要重新理清楚之前的理论才好深入，所以先泛读一遍吧，笔记就不写了


#### Handling Constraints










































































