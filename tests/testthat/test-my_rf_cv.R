#tests within test-my_rf_cv file

test_that("cross validation works", {
  #library(palmerpenguins)
  #library(randomForest)
  #library(class)
  #library(dplyr)
  penguins <- data("my_penguins")
  penguins <- na.omit(penguins)

  expect_is(my_rf_cv(5), "double")
})

test_that("non numeric parameter throws error", {
  expect_error(my_rf_cv("I love penguins"))
})
