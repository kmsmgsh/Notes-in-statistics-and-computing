# Longitudinal data analysis

## Linear mixed model

The model is $Y_i=X_i\beta+Z_ib_i+\epsilon_i$, with $b_i\sim N(0,G)$ 

Under MVN distribution assumption in LMM, we have the density function and log-likelihood function as


\begin{equation}
f\left(\mathbf{Y}_{i}\right)=(2 \pi)^{-\frac{n_{i}}{2}}\left|\mathbf{\Sigma}_{i}\right|^{-\frac{1}{2}} \exp \left\{-\frac{1}{2}\left(\mathbf{Y}_{i}-\mathbf{X}_{i} \beta\right)^{\prime} \mathbf{\Sigma}_{i}^{-1}\left(\mathbf{Y}_{i}-\mathbf{X}_{i} \beta\right)\right\} 
 (\#eq:Normden)
\end{equation}


with $\Sigma_{i}=Z_{i} G Z_{i}^{\prime}+R_{i}=\Sigma_{i}(\theta)$

\begin{equation}
\ell(\beta, \theta)=-\frac{1}{2}\left[\sum_{i=1}^{m} \log \left|\mathbf{\Sigma}_{i}\right|+\sum_{i=1}^{m}\left(\mathbf{Y}_{i}-\mathbf{X}_{i} \beta\right)^{\prime} \mathbf{\Sigma}_{i}^{-1}\left(\mathbf{Y}_{i}-\mathbf{X}_{i} \beta\right)\right]
(\#eq:loglike)
\end{equation}

对$\beta$ 求一阶导，如\@ref(matrix)中所述，对含有$\beta$的项求导,令导数为0，得到
$$
\tilde{\beta}(\theta)=\left(\sum_{i=1}^{m} \mathbf{x}_{i}^{\prime} \mathbf{\Sigma}_{i}^{-1} \mathbf{X}_{i}\right)^{-1}\left(\sum_{i=1}^{m} \mathbf{X}_{i}^{\prime} \mathbf{\Sigma}_{i}^{-1} \mathbf{Y}_{i}\right)
$$
将其带入\@ref(eq:loglike) 得到关于variance components $\theta$ in $\Sigma$的profile loglikelihood
$$
\ell_p(\theta)=-\frac{1}{2}\left[\sum_{i=1}^{m} \log \left|\mathbf{\Sigma}_{i}\right|+\sum_{i=1}^{m}\left\{\mathbf{Y}_{i}-\mathbf{X}_{i} \tilde{\beta}(\theta)\right\}^{\prime} \mathbf{\Sigma}_{i}^{-1}\left\{\mathbf{Y}_{i}-\mathbf{X}_{i} \tilde{\beta}(\theta)\right\}\right].
$$
有
$$
R S S(\theta)=\sum_{i=1}^{m}\left\{\mathbf{Y}_{i}-\mathbf{X}_{i} \tilde{\beta}(\theta)\right\}^{\prime} \mathbf{\Sigma}_{i}^{-1}\left\{\mathbf{Y}_{i}-\mathbf{X}_{i} \tilde{\beta}(\theta)\right\}\\
=\mathbf{Y}^{\prime}\left[\mathbf{\Sigma}^{-1}-\mathbf{\Sigma}^{-1} \mathbf{X}\left(\mathbf{X}^{\prime} \mathbf{\Sigma}^{-1} \mathbf{X}\right)^{-1} \mathbf{X}^{\prime} \mathbf{\Sigma}^{-1}\right] \mathbf{Y}
$$
所以profile/reduced loglikelihood 就是
$$
\ell_{p}(\theta)=\ell_{p}(\tilde{\beta}(\theta), \theta)=-\frac{1}{2}\{\log |\Sigma(\theta)|+R S S(\theta)\}
$$
MLE of $\hat\theta$ 一般没有解析形式。但是对于简单的情况，比如Random Intercept Model，可以用EM算法进行求解，详见J.Pan,LDA notes, p160(376).

### Condition Mean vs Marginal mean

- Condition mean of $Y_i$ is the mean under the condition that given the subject-specific random effects $b_i$.
$$
E\left(\mathbf{Y}_{i} | \mathbf{b}_{i}\right)=\mathbf{X}_{i} \beta+\mathbf{Z}_{i} \mathbf{b}_{i}
$$
- Marginal mean is integral out the random effects, the same as the marginal general linear model
$$
\begin{aligned} E\left(\mathbf{Y}_{i}\right) &=E_{b_{i}}\left(E_{Y_{i}}\left(\mathbf{Y}_{i} | \mathbf{b}_{i}\right)\right) \\ &=E_{b_{i}}\left(\mathbf{X}_{i} \beta+\mathbf{Z}_{i} \mathbf{b}_{i}\right) \\ &=\mathbf{X}_{i} \beta \end{aligned}
$$
- The conditional variance of $Y_i$ is $R_i$
- The marginal variance of $Y_i$ is $Z_iGZ_i'+R_i$

### Restricted maximum likelihood estimation
  MLEs of variance components $\theta$ may be biased since the estimation proceure does not account for the loss of data information used in estimating the regression coefficients $\beta$, consider restricted maximum likelihood estimation procedure to obtain less biased estimators of variance components $\theta$.
  
Use the REML function instead of original log-likelihood function, (Derive can be found in the 没mixed的部分有详细推导)

$$
\begin{aligned} \ell_{R}(\theta)=&-\frac{1}{2} \sum_{i=1}^{m} \log \left|\boldsymbol{\Sigma}_{i}\right|-\frac{1}{2} \sum_{i=1}^{m} \log \left|\mathbf{X}_{i}^{\prime} \boldsymbol{\Sigma}_{i}^{-1} \mathbf{X}_{i}\right| \\ &-\frac{1}{2} \sum_{i=1}^{m}\left(\mathbf{Y}_{i}-\mathbf{X}_{i} \tilde{\beta}(\theta)\right)^{\prime} \boldsymbol{\Sigma}_{i}^{-1}\left(\mathbf{Y}_{i}-\mathbf{X}_{i} \tilde{\beta}(\theta)\right) \end{aligned}
$$
Once we get the estimation of parameters, the random effects $b_i$ can be predicted by 
$$
\hat{\mathbf{b}}_{i}=\mathrm{E}\left[\mathbf{b}_{i} | \mathbf{Y}_{i}, \hat{\beta}, \hat{\theta}\right]=\hat{\mathbf{G}} \mathbf{Z}_{i} \hat{\mathbf{\Sigma}}_{i}^{-1}\left(\mathbf{Y}_{i}-\mathbf{X}_{i} \hat{\beta}\right)
$$

### Prediction 
Posterior distribution of $b_i$ given the data $Y_i$ is
$$
f\left(b_{i} | Y_{i}\right)=\frac{f\left(Y_{i} | b_{i}\right) f\left(b_{i}\right)}{\int f\left(Y_{i} | b_{i}\right) f\left(b_{i}\right) d b_{i}}
$$
Thus, the posterior mean of $b_i$ can be obtained by
$$
\begin{aligned} \hat{b}_{i} &=E\left(b_{i} | Y_{i}\right) \\ &=\int b_{i} f\left(b_{i} | Y_{i}\right) d b_{i} \\ &=G Z_{i}^{\prime} \Sigma_{i}^{-1}\left(Y_{i}-X_{i} \beta\right) \end{aligned}
$$
This is called empirical Bayes estimator or the empirical best linear unbiased predictors.



## Generalised linear mixed models
- Before only consider the data follows Normal distribution, need extend to binomial, binary, Poisson counts, etc.
- 推广线性模型的normal到其他分部是用GLM方法
- 结合mixed model和GLM，得到GLMMs

### Exponential distribution family {#expFam}
涉及到Generalised linear model就会把正态推广到指数函数族，所以这里简单的提一下
$$
f(y ; \theta, \phi)=\exp \left\{\frac{(y \theta-b(\theta))}{a(\phi)}+c(y, \phi)\right\}
$$
$\theta$ is natural parameter and $\phi$ is called additional scale or nuisance/dispersion parameter.

对于指数分布组，我们有
$$
\begin{aligned} \mathrm{E}(Y) &=b^{\prime}(\theta) \\ \operatorname{Var}(Y) &=\phi b^{\prime \prime}(\theta) \end{aligned}
$$

若要求MLE，有其score function为
$$
\begin{aligned} U &=\frac{\partial}{\partial \theta} \ell(\theta, \phi | y) \\ &=\frac{y-b^{\prime}(\theta)}{\phi} \end{aligned}
$$


$$
g(\mu_i)=x_i'\beta
$$
Y的不同分布通过不同的连接函数g进行刻画。
$$
Normal: \mu_i=\eta_i=x_i'\beta\\
Possion/log: \log \lambda_{i}=\eta_{i}=\boldsymbol{x}_{i}^{\prime} \boldsymbol{\beta}\\
\textit{Bionomial/logistic:}\log \frac{\pi_{i}}{1-\pi_{i}}=\eta_{i}=x_{i}^{\prime} \beta
$$

### Iteratively reweighted Least square algorithm (IWLS)
$$
\boldsymbol{\beta}^{(\boldsymbol{m})}=\left(\boldsymbol{X}^{\prime} \boldsymbol{W}^{(\boldsymbol{m}-\mathbf{1})} \boldsymbol{X}\right)^{-\mathbf{1}} \boldsymbol{X}^{\prime} \boldsymbol{W}^{(\boldsymbol{m}-\mathbf{1})} \boldsymbol{Z}^{(\boldsymbol{m}-\mathbf{1})}
$$
with 
$$
\begin{aligned} W &=\operatorname{diag}\left(W_{1}, W_{2}, \ldots, W_{n}\right) \text { with } W_{i}=\frac{1}{\left[g^{\prime}\left(\mu_{i}\right)\right]^{2} V_{i}} \\ Z &=X \beta+D(Y-\mu) \\ D &=\operatorname{diag}\left(D_{1}, D_{2}, \ldots, D_{n}\right) \text { with } D_{i}=g^{\prime}\left(\mu_{i}\right) \end{aligned}
$$
More detail about the IWRLS can be found in /MasterCourse/GLM/IWLRS



### GLMMs


- Random Components: 
  - Response: 
$$
  \mathbf{Y}_{i j}\left|\mathbf{b}_{i} \sim \exp \left\{\frac{\left(y_{i j} \theta_{i j}-b\left(\theta_{i j}\right)\right)}{a_{i j}(\phi)}+c\left(y_{i j}, \phi\right)\right\}\right.
$$

  - Random effect:
$$
  \mathbf{b}_{i} \sim N_{q}(\mathbf{0}, \mathbf{G})
$$
- Systematic components:
$$
\eta_{i j}=\mathbf{x}_{i j}^{\prime} \beta+\mathbf{z}_{i j}^{\prime} \mathbf{b}_{i}
$$


比如说，response服从Binomial-Normal,那么有
$$
Y_{i j}\left|b_{i} \sim \mathcal{B}\left(K_{i j}, \pi_{i j}\right), i=1,2, \cdots, m ; j=1,2, \dots, n_{i}\right.
$$
然后就有模型如下
$$
\log \frac{\pi_{i j}}{1-\pi_{i j}}=\eta_{i j}=\boldsymbol{x}_{i j}^{\prime} \boldsymbol{\beta}+\boldsymbol{z}_{i j}^{\prime} \boldsymbol{b}_{i}
$$
Binomial-Normal意味着response的条件分布式Binomial，而random-effect 的分布是Normal.

#### Likelihood function
用$\theta$表示随机效应$b_i$方差阵$G$中的参数，则可以很自然的写出似然函数：
$$
L(\beta, \theta)=\prod_{i=1}^{m} \int \prod_{j=1}^{n_{i}} f_{y|b}\left(Y_{i j} | \mathbf{b}_{i}\right) f_{b}\left(\mathbf{b}_{i}\right) \mathrm{d} \mathbf{b}_{i}
$$
似然函数中，$f_{y|b}\left(Y_{i j} | \mathbf{b}_{i}\right)$ condition on random effect $b_i$的generalised的分布，$f_b(b_i)$是随机效应的分布$N(0,G)$.
这块似然函数需要把未知的随机效应进行积分，把他积掉，但是一般而言，这个积分十分困难，所以要基于这个似然函数计算MLE不是很容易。
在GLMM中，如果已知随机效应$b_i$，则有
$$
\mathrm{E}\left[Y_{i j} | \mathbf{b}_{i}\right]=\mu_{i j} \quad \quad \operatorname{Var}\left[Y_{i j} | \mathbf{b}_{i}\right]=\phi a_{i j} v\left(\mu_{i j}\right)
$$
注：$\phi$ 和 $v(\mu_{ij})$ 可以从exponential family那块找到定义。

为了处理似然函数中的积分，可以构造 *integrated quasi-likelihood* 进行处理。

$$
\begin{equation}
\begin{aligned}
& \exp \left\{q \ell_{i}(\beta, \theta)\right\} \\ \propto &|\mathbf{G}|^{-\frac{1}{2}} \int \exp \left[-\frac{1}{2 \phi} \sum_{j=1}^{n_{i}} d_{i j}\left(y_{i j} ; \mu_{i j}\right)-\frac{1}{2} \mathbf{b}_{i}^{\prime} \mathbf{G}^{-1} \mathbf{b}_{i}\right] \mathrm{d} \mathbf{b}_{i} 
\end{aligned}
(\#eq:intQuasi)
\end{equation}
$$
with
$$
d_{i j}(y, \mu)=-2 \int_{y}^{\mu} \frac{y-u}{a_{i j} v(u)} \mathrm{d} u
$$


这里有一个问题，为啥quasi-likelihood长这样，根据(Wedderburn,1974)，quasi-likelihood的定义是

\BeginKnitrBlock{definition}<div class="definition"><span class="definition" id="def:Quasi"><strong>(\#def:Quasi) </strong></span>quasi-likelihood function $K(z_i,\mu_i)$
$$
\frac{\partial K\left(z_{i}, \mu_{i}\right)}{\partial \mu_{i}}=\frac{z_{i}-\mu_{i}}{V\left(\mu_{i}\right)}
$$
or equivelantly
$$
K\left(z_{i}, \mu_{i}\right)=\int^{\mu_{*}} \frac{z_{i}-\mu_{i}^{\prime}}{V\left(\mu_{i}^{\prime}\right)} d \mu_{i}^{\prime}+\text { function of } z_{i}  
$$</div>\EndKnitrBlock{definition}
根据其原因，我觉得大概是这样，回到 \@ref(expFam) 中，我们可以看到，对Exponential family distribution求导得到Score function，其形式就是
$$
U=\frac{y-E(y)}{\phi}
$$
于是乎quasi-likelihood就反过来，用只要满足求导为这个式子的函数就是一个“likelihood”。
而同时，quasi-likelihood有一些类似于MLE，比较好的计算性质可以进行利用。

回到(Breslow and Clayton,1993)的定义式 \@ref(eq:intQuasi),其中第一部分关于fixed-effect的，直接是用以上quasi-likelihood的定义\@ref(def:Quasi) 带进去，然后加上第二部分关于random effect中和$G(\theta)$有关的部分。

因为quasi-likelihood是从exponential family destribution的Score function来的，所以对于$Y\sim exponential family$,quasi-likelihood等价于真正的likelihood，然后$d_{ij}$变成了在积分上下限的loglikelihood 的差值：$2 \phi\{\ell(y ; y, \phi)-\ell(y ; \mu, \phi)\}$.

Integrated quasi-likelihood\@ref(eq:intQuasi) 对于个体i，能写成如下形式
$$
c|\mathbf{G}|^{-\frac{1}{2}} \int e^{-\kappa\left(\mathbf{b}_{i}\right)} \mathrm{d} \mathbf{b}_{i}
$$

这只是把exponential那里一大堆二次型全部塞到$-\kappa(b_i)$里面去。
这个积分无法解析的写出来，于是考虑Laplace逼近。

$$
\int e^{-\kappa\left(\mathbf{b}_{i}\right)} \mathrm{d} \mathbf{b}_{i}=(2 \pi)^{q / 2}\left|\kappa^{\prime \prime}\left(\tilde{\mathbf{b}}_{i}\right)\right|^{-1 / 2} \exp \left\{-\kappa\left(\tilde{\mathbf{b}}_{i}\right)\right\}
$$
$q=\operatorname{dim}(b_i)$.$\tilde b_i$ 是$\kappa'(b_i)=0$的解。
于是有
$$
\begin{equation}
q \ell_{i}(\beta, \theta) \simeq-\frac{1}{2} \log |\mathbf{G}|-\frac{1}{2} \log \left|\kappa^{\prime \prime}\left(\tilde{\mathbf{b}}_{i}\right)\right|-\kappa\left(\tilde{\mathbf{b}}_{i}\right)
(\#eq:quasiLikeKappa)
\end{equation}
$$
以及
$$
\kappa^{\prime}\left(\mathbf{b}_{i}\right)=-\sum_{j=1}^{n_{i}} \frac{\left(Y_{i j}-\mu_{i j}\right) \mathbf{z}_{i j}}{\phi a_{i j} v\left(\mu_{i j}\right) g^{\prime}\left(\mu_{i j}\right)}+\mathbf{G}^{-1} \mathbf{b}_{i}=0
$$
和
$$
\begin{aligned} \kappa^{\prime \prime}\left(\mathbf{b}_{i}\right) &=\sum_{j=1}^{n_{i}} \frac{\mathbf{z}_{i j} \mathbf{z}_{i j}^{\prime}}{\phi a_{i j} v\left(\mu_{i j}\right)\left[g^{\prime}\left(\mu_{i j}\right)\right]^{2}}+\mathbf{G}^{-1}+\mathbf{R}_{i} \\ & \simeq \mathbf{Z}_{i}^{\prime} \mathbf{W}_{i} \mathbf{Z}_{i}+\mathbf{G}^{-1} \end{aligned}
$$
注意这个$W_i$有点像IRWLS中的reweighted matrix。
其中$\boldsymbol R_i$是

$$
\mathbf{R}_{i}=-\sum_{j=1}^{n_{i}}\left(Y_{i j}-\mu_{i j}\right) \mathbf{z}_{i j} \frac{\partial}{\partial \mathbf{b}_{i}}\left[\frac{1}{\phi a_{i j} v\left(\mu_{i j}\right) g^{\prime}\left(\mu_{i j}\right)}\right]
$$

$E(\boldsymbol R_i)=0$,
当使用canonical link function时$\boldsymbol R_i=0$,所以可以忽略掉。把$\kappa''(b_i)$带回 \@ref(eq:quasiLikeKappa)，则有

$$
q \ell_{i}(\beta, \theta) \simeq-\frac{1}{2} \log |\mathbf{G}|-\frac{1}{2} \log \left|\mathbf{Z}_{i}^{\prime} \mathbf{W}_{i} \mathbf{Z}_{i}+\mathbf{G}^{-1}\right|-\kappa\left(\tilde{\mathbf{b}}_{i}\right)
$$
把$\kappa(\cdot)$打开可以得到

$$
\begin{aligned} q \ell(\beta, \theta)=& \sum_{i=1}^{m} q \ell_{i}(\beta, \theta) \\=&-\frac{1}{2} \sum_{i=1}^{m} \log \left|\mathbf{I}_{n_{i}}+\mathbf{Z}_{i}^{\prime} \mathbf{W}_{i} \mathbf{Z}_{i} \mathbf{G}\right| \\ &-\frac{1}{2 \phi} \sum_{i=1}^{m} \sum_{j=1}^{n_{i}} d_{i j}\left(y_{i j} ; \tilde{\mu}_{i j}\right)-\frac{1}{2} \sum_{i=1}^{m} \tilde{\mathbf{b}}_{i}^{\prime} \mathbf{G}^{-1} \tilde{\mathbf{b}}_{i} \end{aligned}
$$
极大化这个式子得到的估计值称为 penalised quasi-likelihood(PQL)。把后面那项$\frac{1}{2} \sum_{i=1}^{m} \tilde{\mathbf{b}}_{i}^{\prime} \mathbf{G}^{-1} \tilde{\mathbf{b}}_{i}$ 视为penalty。

基于某种复杂的和penalized likelihood estimation相同的机制，可以把$\tilde b_i$ 看成一个罚函数的参数单独进行估计，所以有

$$
q \ell(\beta, \mathbf{b}) \simeq-\frac{1}{2 \phi} \sum_{i=1}^{m} \sum_{j=1}^{n_{i}} d_{i j}\left(y_{i j} ; \mu_{i j}\right)-\frac{1}{2} \sum_{i=1}^{m} \mathbf{b}_{i}^{\prime} \mathbf{G}^{-1} \mathbf{b}_{i}
$$
通过分别找�使得上式极大化的$\beta$和$\boldsymbol b$ 得到需要的估计。对上式进行微分，得到
$$
\begin{array}{c}{\sum_{i=1}^{m} \sum_{j=1}^{n_{i}} \frac{\left(y_{i j}-\mu_{i j}\right) \mathbf{x}_{i j}}{\phi a_{i j} v\left(\mu_{i j}\right) g^{\prime}\left(\mu_{i j}\right)}=0} \\ {\sum_{j=1}^{n_{i}} \frac{\left(y_{i j}-\mu_{i j}\right) \mathbf{z}_{i j}}{\phi a_{i j} v\left(\mu_{i j}\right) g^{\prime}\left(\mu_{i j}\right)}=\mathbf{G}^{-1} \mathbf{b}_{i}}\end{array}
$$
.
可以使用Fisher-Scoring algorithm进行求解。

。。。

求解过程很长很麻烦可以去看课件。。

。。。


我们得到了对$b$ 和 $\beta$的估计以后，下一步就是对Random effect 的 covariance matrix $G(\theta)$ 进行估计。

> 这里没太懂。

Ignoring throughout the dependence of $W$ on $\theta$ and replacing the deviance

$$
\sum_{i=1}^{m} \sum_{j=1}^{n_{i}} d_{i j}\left(y_{i j}, \mu_{i j}\right)
$$
by the Pearson Chi-squared statistic
$$
\sum_{i=1}^{m} \sum_{j=1}^{n_{i}} \frac{\left(y_{i j}-\mu_{i j}\right)^{2}}{a_{i j} v\left(\mu_{i j}\right)}
$$
带回之前的PQL，可以得到
$$
\begin{aligned} q \ell(\hat{\beta}(\theta), \hat{\mathbf{b}}(\theta)) \simeq &-\frac{1}{2} \sum_{i=1}^{m} \log \left|\mathbf{V}_{i}(\theta)\right| \\ &-\frac{1}{2} \sum_{i=1}^{m}\left(\mathbf{Y}_{i}^{*}-\mathbf{X}_{i} \hat{\beta}(\theta)\right)^{\prime} \mathbf{V}_{i}^{-1}(\theta)\left(\mathbf{Y}_{i}^{*}-\mathbf{X}_{i} \hat{\beta}(\theta)\right) \end{aligned}
$$
同样的，这个也可以有一个REML的版本避免$\beta$的估计对$\theta$的影响.
$$
\begin{aligned} q \ell^{*}(\hat{\beta}(\theta), \hat{\mathbf{b}}(\theta)) \simeq &-\frac{1}{2} \sum_{i=1}^{m} \log \left|\mathbf{V}_{i}(\theta)\right|-\frac{1}{2} \sum_{i=1}^{m} \log \left|\mathbf{X}_{i}^{\prime} \mathbf{V}_{i}^{-1}(\theta) \mathbf{X}_{i}\right| \\ &-\frac{1}{2} \sum_{i=1}^{m}\left(\mathbf{Y}_{i}^{*}-\mathbf{X}_{i} \hat{\beta}(\theta)\right)^{\prime} \mathbf{V}_{i}^{-1}(\theta)\left(\mathbf{Y}_{i}^{*}-\mathbf{X}_{i} \hat{\beta}(\theta)\right) \end{aligned}
$$
同样的求导也可以导出估计方程，然后用fisher-scoring algorithm求解估计方程。
$$
-\frac{1}{2} \sum_{i=1}^{m}\left[\left(\mathbf{Y}_{i}^{*}-\mathbf{X}_{i} \beta\right)^{\prime} \mathbf{V}_{i}^{-1} \frac{\partial \mathbf{V}_{i}}{\partial \theta_{j}} \mathbf{V}_{i}^{-1}\left(\mathbf{Y}_{i}^{*}-\mathbf{X}_{i} \beta\right)-\operatorname{trace}\left(\mathbf{P}_{i} \frac{\partial \mathbf{V}_{i}}{\partial \theta_{j}}\right)\right]=0
$$
with 
$$
\mathbf{P}_{i}=\mathbf{V}_{i}^{-1}-\mathbf{V}_{i}^{-1} \mathbf{X}_{i}\left(\mathbf{X}_{i}^{\prime} \mathbf{V}_{i}^{-1} \mathbf{X}_{i}\right)^{-1} \mathbf{X}_{i}^{\prime} \mathbf{V}_{i}^{-1}
$$


## The Bayesian analysis approach for covariance modelling

It is obvious that the mean part $X\beta$ is conditional normal distribution under the condition that we know the covariance matrix part $\Sigma=LDL^T$ or $\Sigma=\Lambda\Gamma\Gamma^T\Lambda$







