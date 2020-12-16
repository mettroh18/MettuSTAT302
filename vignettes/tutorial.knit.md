---
title: "Project 2: MettuSTAT302 Tutorial"
author: "Rohini Mettu"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{MettuSTAT302 Tutorial}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---




```r
library(MettuSTAT302)
#> Warning: replacing previous import 'dplyr::combine' by 'randomForest::combine'
#> when loading 'MettuSTAT302'
```

This package was completed as a final project for a course at UW: STAT302, Statistical Computing. This project serves as a culmination of all our new knowledge and skills gained over the quarter. This vignette will demonstrate the various statistical methods we have learned during the course. This package contains four different functions as follows:
* ```my_ttest``` : a function that conducts a t-test on the given data.
* ```my_lm``` : a function that outputs a linear regression model based on the given data
* ```my_knn_cv``` : a function that runs a k-nearest neighbors cross validation on the given data
* ```my_rf_cv``` : a function that runs a random forest cross validation on the given data

To install and load the package, one should run the following in their console:

```r
#devtools::install_github("mettroh18/MettuSTAT302")

#do we need to load each of these if they are supposed to be imported into the package itself?
library(MettuSTAT302)
#library(ggplot2)
#library(dplyr)
#library(class)
#library(randomForest)
```

## A tutorial for my_ttest.

First, we will load the lifeExp data from the ```my_gapminder``` file within the package.

```r
data(my_gapminder)
lifeExp <- my_gapminder$lifeExp
```

We will then perform three tests of mu (the true mean value) against an alpha value of 0.05. This means that if any of these tests produce a value less than alpha, we can reject the null hypothesis in favor of the alternate hypothesis. 

The first will test a null hypothesis of mu=60, and an alternate hypothesis of mu≠60. As this test wants to test inequality, a two-sided t-test must be performed against the value 60:


```r
my_ttest(lifeExp, alternative="two.sided", 60)
#> $test_stat
#> [1] -1.679548
#> 
#> $df
#> [1] 1703
#> 
#> $alternative
#> [1] "two.sided"
#> 
#> $p_val
#> [1] 0.09322877
```
This results in a p-value of 0.09322. As this is greater than alpha (0.05), we fail to reject the null hypothesis in favor of the alternate. Therefore we do not have sufficient evidence that mu≠60.

The second will test a null hypothesis of mu=60, and an alternate hypothesis of mu<60. As this test wants to test a less-than comparison, a one-sided t-test must be performed against the value 60:


```r
my_ttest(lifeExp, alternative="less", 60)
#> $test_stat
#> [1] -1.679548
#> 
#> $df
#> [1] 1703
#> 
#> $alternative
#> [1] "less"
#> 
#> $p_val
#> [1] 0.04661438
```
This results in a p-value of 0.04661. As this is less than alpha (0.05), we *can* reject the null hypothesis in favor of the alternate. We have the evidence to reject the claim that mu is equal to 60.

The second will test a null hypothesis of mu=60, and an alternate hypothesis of mu>60. As this test wants to test a greater-than comparison, a one-sided t-test must be performed against the value 60:


```r
my_ttest(lifeExp, alternative="greater", 60)
#> $test_stat
#> [1] -1.679548
#> 
#> $df
#> [1] 1703
#> 
#> $alternative
#> [1] "greater"
#> 
#> $p_val
#> [1] 0.9533856
```
This results in a p-value of 0.95338 As this is more than alpha (0.05), we *fail to* reject the null hypothesis in favor of the alternate. We do not have the evidence to support the claim that mu is greater than 60. Notice that this value has the same result as the second test, and is also the same as 1 - 0.0466 (our p-value from the previous test)


## A tutorial for my_lm.

This will demonstrate how to compute a linear regression model against two covariants. Our response variables will be ```lifeExp```, same as our t-test, and our covariants will be ```gdpPercap``` and ```continent```. As we have already loaded our data in this document, we can continue forward with a demonstration of the function:


```r
gapminder_model <- my_lm(lifeExp ~ gdpPercap + continent, my_gapminder)
print(gapminder_model)
#>                       Estimate   Std. Error   t value      Pr(>|t|)
#> (Intercept)       4.788852e+01 3.398053e-01 140.92927  0.000000e+00
#> gdpPercap         4.452704e-04 2.349795e-05  18.94933  8.552893e-73
#> continentAmericas 1.359272e+01 6.007856e-01  22.62491  2.822476e-99
#> continentAsia     8.657793e+00 5.554859e-01  15.58598  2.719424e-51
#> continentEurope   1.757234e+01 6.257430e-01  28.08236 7.595526e-143
#> continentOceania  1.814604e+01 1.787426e+00  10.15205  1.502557e-23
```
Reminder: The beta coefficient of a covariant represents the increase that occurs for every 1-unit increase in the predictor variable (in this case, gdp and continent), there is a beta increase in the outcome variable (in this case, Life expectancy). Here we can see that the estimated b-coefficient for gdpPercap (given all covariants are controlled) is 0.000445. This means that if lifeExpectancy goes up one year, it is predicted to be a result of a 0.000445 increase in GDP within a country.

If we were to conduct a hypothesis test on this beta value, we would write the hypotheses as follows:
* H0: the true beta = 0.000445
* H1: the true beta is more extreme than 0.000445

Using the results above, we can conduct a two sided t-test using a p-value cutoff of α=0.05 using the test value provided in our lm output (18.949). We can see above that the corresponding p-value is 8.552893e-73, extremely small even when multiplied by two to represent both sides of the t-test. This means we can reject our null hypothesis in favor of the alternate, effectively supporting the hypothesis that the true Beta (coefficient) for gdpPercap is more extreme than 0.000445.


```r
my_coef <- gapminder_model$Estimate
my_matrix <- model.matrix(lifeExp ~ gdpPercap + continent, data = my_gapminder)
y_hat <- my_matrix %*% as.matrix(my_coef)
my_df <- data.frame("actual" = my_gapminder$lifeExp, "fitted" = y_hat, "continent" = my_gapminder$continent)

ggplot2::ggplot(my_df, ggplot2::aes(x=fitted, y=actual)) + 
  ggplot2::geom_point(ggplot2::aes(color=continent)) + ggplot2::facet_wrap(~ continent, scales = "free") 
```

![](C:/Users/romet/AppData/Local/Temp/RtmpOsvqrA/preview-58a873dc7eb2.dir/tutorial_files/figure-html/unnamed-chunk-8-1.png)<!-- -->


Here we can see that there is a strong relationship and fit between fitted and actual values for the Oceanic countries. However, there is less of a relationship for the other 4 continents observed. Notably, these four do have similar plots but nonetheless have a weak correlation between the predicted and actual values. Overall, I would call this model fit weak and therefore there may be better variables through which models can be fitted aside from gdpPercap for the gapminder data.

## A tutorial for my_knn_cv

Let's look at the CV misclassification rate and training misclassification rate based on the output class ```species``` of the ```my_penguins``` data within the package, using the covariants ```bill_length_mm, bill_depth_mm, flipper_length_mm, and body_mass_g```. For this we wil use the k-nearest neighbors cross validation model on up to 10 neighbors (```k_nn```), with a 5-fold cross validation (```k_cv=5```). First, we must load the data, then we can iterate from 1 to 10 knn values:


```r
data1 <- my_penguins %>% na.omit() %>%
  dplyr::select(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, species)

k_values <- c(1:10)
cv_errors <- c()
train_errs <- c()
for (i in c(1:10)) {
  cv_val <- my_knn_cv(train = data1, cl = 'species', k_nn = i, k_cv = 5)$cv_misclass
  train_err_val <- my_knn_cv(train = data1, cl = 'species', k_nn = i, k_cv = 5)$train_misclass
  cv_errors <- append(cv_errors, cv_val)
  train_errs <- append(train_errs, train_err_val)
}
data.frame(k_values, cv_errors, train_errs)
#>    k_values cv_errors train_errs
#> 1         1 0.5616463 0.00000000
#> 2         2 0.5613749 0.06606607
#> 3         3 0.5616463 0.08408408
#> 4         4 0.5616463 0.12612613
#> 5         5 0.5617820 0.14414414
#> 6         6 0.5614654 0.14714715
#> 7         7 0.5615106 0.15615616
#> 8         8 0.5616915 0.15615616
#> 9         9 0.5616915 0.18018018
#> 10       10 0.5614202 0.18618619
```

State which model you would choose based on the training misclassification rates and which model you would choose based on the CV misclassification rates.
Discuss which model you would choose in practice and why.
Your explanation(s) should include a general description of what the process of cross-validation is doing and why it is useful.

## A tutorial for my_rf_cv


```r
k_vals <- c(2,5,10)
cv_sd <- c()
cv_means <- c()
for (i in k_vals) {
  MSE_vals <- c()
  for (j in 1:30) {
    cv_val <- my_rf_cv(i)
    MSE_vals <- append(MSE_vals, cv_val)
  }
  cv_sd <- append(cv_sd, sd(MSE_vals))
  cv_means <- append(cv_means, mean(MSE_vals))
  boxplot(MSE_vals, main=i, ylab="Cross Validation Error")
}
```

![](C:/Users/romet/AppData/Local/Temp/RtmpOsvqrA/preview-58a873dc7eb2.dir/tutorial_files/figure-html/unnamed-chunk-10-1.png)<!-- -->![](C:/Users/romet/AppData/Local/Temp/RtmpOsvqrA/preview-58a873dc7eb2.dir/tutorial_files/figure-html/unnamed-chunk-10-2.png)<!-- -->![](C:/Users/romet/AppData/Local/Temp/RtmpOsvqrA/preview-58a873dc7eb2.dir/tutorial_files/figure-html/unnamed-chunk-10-3.png)<!-- -->

```r
results <- data.frame(k_vals, cv_means, cv_sd)
print(results)
#>   k_vals cv_means    cv_sd
#> 1      2 126599.6 5445.872
#> 2      5 120046.3 3519.577
#> 3     10 118891.8 2591.061
```

Discuss the results you observe in the boxplots and table. Compare the means and standard deviations of the the different values of k and comment on why you think this is the case.
