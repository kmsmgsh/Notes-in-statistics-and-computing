# R web scrape

Web scrape用



```r
library(rvest)
```

```
## Warning: package 'rvest' was built under R version 3.5.2
```

```
## Loading required package: xml2
```

```r
lego_movie <- read_html("http://www.imdb.com/title/tt1490017/")

rating <- lego_movie %>% 
  html_nodes("strong span") %>% # 这个"strong span"是指什么意思？
  html_text() %>%
  as.numeric()
rating
```

```
## [1] 7.8
```

```r
#> [1] 7.8
```
上述的问题回答是由于：

```r
knitr::include_graphics(rep("pic/scrape_2.png", 1))
```
含有7.8的html元素就是strong 下面的span的元素。

根据这篇[tutorial](https://www.datacamp.com/community/tutorials/r-web-scraping-rvest)
提取class=""中的元素可以用如下代码
```
 html_nodes('.pagination-page')
```


学这段写一下：

```r
a=read_html("https://d.cosx.org/d/420739-r")
html_nodes(a,".PostMention")
```
就得到分开的有PostMention类的元素

```r
PostMentionUser=html_nodes(a,".PostMention")%>% html_text()
head(PostMentionUser)
```
得到PostMention里面的元素，应该是回复中带@的部分？


```r
html_nodes(a,".Post-body")%>%
  html_text()->body
head(body)
```
就得到回帖的内容，


```r
html_nodes(a,".PostUser")
html_nodes(a,".username")
```
但是这个咋就不对。。。。奇怪。

是因为元素叠起来的缘故吗？应该不是奇奇怪怪的，明天再看。


