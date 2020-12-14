#tests within test-my_knn_cv file

test_that("cross validation works", {
  library(palmerpenguins)
  library(randomForest)
  library(class)
  library(dplyr)
  data(package = "palmerpenguins")
  penguins <- na.omit(penguins)

  x <- my_knn_cv(train = penguins, cl = 'species', k_nn = 3, k_cv = 5)[[1]]
  expect_is(x, "numeric")
})

test_that("non numeric parameter throws error", {
  expect_error(my_knn_cv(train = penguins, cl = 'species', k_nn = "blue", k_cv = "green"))
})

