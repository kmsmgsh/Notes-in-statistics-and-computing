# Statistic term

- over-dispersion
来自于[wikipedia](https://en.wikipedia.org/wiki/Overdispersion), over-dispersion(过散布)的意思是，观测数据的高阶矩（一般指二阶，也就是方差），比模型的高阶矩大。
维基中说的更多更细。回忆如下：
对于任意数据，分析过程经常拿一个参数模型进行拟合，而参数模型需要满足一定的条件。最简单的就是模型的均值要等于观测数据的均值。而对于一些简单的模型，高阶矩不一定和均值一样会相等。而对于观测数据的方差大于模型的方差，那就叫过散布。反过来则是under-dispersion。

比如说对于泊松模型，模型就只有一个参数，均值和方差都用$\lambda$建模。而实际情况中均值很难等于方差。如果使用泊松模型对数据建模，产生了过散布，则这样就需要使用更复杂的模型，比如Poisson mixture model。


- Saturated-model

来自于[stack-exchange](https://stats.stackexchange.com/questions/283/what-is-a-saturated-model)
简单的用一句话来说就是估计参数个数接近观测个数的模型就称之为 saturated-model.


- Inclusion Probability

也叫[Sample probability](https://en.wikipedia.org/wiki/Sampling_probability)
在有限总体中抽样，一个元素的sampling probability(inclusion probability)，被一次抽样抽出来的概率。






