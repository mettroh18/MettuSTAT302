#tests within test-my_rf_cv file

test_that("cross validation works", {
  expect_is(my_rf_cv(5), "numeric")
})

test_that("non numeric parameter throws error", {
  expect_error(my_rf_cv("I love penguins"))
})
