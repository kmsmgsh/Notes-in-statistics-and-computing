# Simulation approach for computing the marginal likelihood

This is the Chapter 6 of [@ando2010bayesian].
Because the previous part is kind of farmiliar and most of its content can be covered by other paper can be found in Bayesian variable selection and Bayes factor, so not independent summarise. This chapter is mostly out of my knowledge boundary so I will record here.

THe simplest way is using the result of MCMC to calculate the marginal density by numerical integral：
$$
P\left(\boldsymbol{X}_{n} | M\right)=\frac{1}{L} \sum_{j=1}^{L} f\left(\boldsymbol{X}_{n} | \boldsymbol{\theta}^{(j)}\right)
$$

 "Unfortunately, this estimate is usually quite a poor approximation."(McCulloch and Rossi 1992)

- Laplace-Metropolis estimator (Lewos and Raftery,1997), also called candidate formula (Chib,1995)

- Harmonic mean estimator (Newton and Raftery,1994)

- Gelfand and Dey's estimator (Gelfand and Dey,1994)

- bridge sampling estimator (Meng and Wong,1996)

Recent book cana be refer:
Carlin and Louis (2000), Chen et al. (2000), Gamerman and Lopes(2006).

This marginal likelihood will not consider the average for differenciating several models.


## Laplace-Metropolis approximation

First will review the Laplace method for integral.

Let $h(\theta)$ be a smooth, positive function of the p-dimensional vector $\mathbb \theta=(\theta_1,...,\theta_p)^T$








