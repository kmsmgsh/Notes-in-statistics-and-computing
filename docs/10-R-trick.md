# R trick

科学计数法：

- 取消科学计数法

```r
options(scipen = 200)
```
scipen 表示在200个数字以内都不使用科学计数法


- 显示位数：
```
options(digits=3)
```
- Rmarkdown 不运行
``` eval=FALSE ```

- 清除环境变量

```rm(list=ls())```

- 拼接字符串
```paste()```


- Try catch


```r
for (i in 1:10) {
tryCatch({log(4-i)},warning=function(a){print("warning!");browser();stop()},finally = {print(i);})
}
```
Try后面expr中的式子，如果一切无事，则run finally里面的expr，如果有warning，就run warning里面的function，如果有error，就run error 里面的function。

- Call browser when error

```
options(error=browser)
options(warn=2)
options(error=recover)
```


- R 取余:%%

```r
2300%%100 
```

```
## [1] 0
```

```r
230%%100
```

```
## [1] 30
```

- 一个进度条的包，这个是外跳一个进度条窗口


```r
library(tcltk2)

u <- 1:2000

plot.new()

pb <- tkProgressBar("进度","已完成 %",  0, 100)

for(i in u) {

x<-rnorm(u)

points(x,x^2,col=i)

info <- sprintf("已完成 %d%%", round(i*100/length(u)))

setTkProgressBar(pb, i*100/length(u), sprintf("进度 (%s)", info), info)

}
```


- [进度条](https://github.com/r-lib/progress)
我觉得这个更好用


```r
library(progress)
pb <- progress_bar$new(total = 100)
for (i in 1:100) {
  pb$tick()
  Sys.sleep(1 / 100)
}
```


一个比较完整应用:
```
 pb <- progress::progress_bar$new(
    format = "MCMC running [:bar] :percent in :elapsed eta: :eta",
    total = iter, clear = FALSE)

```


-[Benchmark](https://www.alexejgossmann.com/benchmarking_r/)

其中的试例代码：
```
benchmark("lm" = {
            X <- matrix(rnorm(1000), 100, 10)
            y <- X %*% sample(1:10, 10) + rnorm(100)
            b <- lm(y ~ X + 0)$coef
          },
          "pseudoinverse" = {
            X <- matrix(rnorm(1000), 100, 10)
            y <- X %*% sample(1:10, 10) + rnorm(100)
            b <- solve(t(X) %*% X) %*% t(X) %*% y
          },
          "linear system" = {
            X <- matrix(rnorm(1000), 100, 10)
            y <- X %*% sample(1:10, 10) + rnorm(100)
            b <- solve(t(X) %*% X, t(X) %*% y)
          },
          replications = 1000,
          columns = c("test", "replications", "elapsed",
                      "relative", "user.self", "sys.self"))

```

可以很简单的改成我的代码：
```
benchmark("Rvec2tril"=BayesJMCM::vec2tril(phiiVec)
          "Rcppvec2tril"=vec2trilcpp(phiiVec)
         )
```

