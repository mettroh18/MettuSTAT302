#tests within test-my_knn_cv file

test_that("cross validation works", {
  #library(palmerpenguins)
  #library(randomForest)
  #library(class)
  #library(dplyr)
  penguins <- data("my_penguins")
  penguins <- na.omit(penguins)

  x <- my_knn_cv(train = penguins, cl = 'species', k_nn = 3, k_cv = 5)[[1]]
  expect_is(x, "double")
})

test_that("non numeric parameter throws error", {
  expect_error(my_knn_cv(train = penguins, cl = 'species', k_nn = "blue", k_cv = "green"))
})

