#test for my_ttest function
#within test-my_ttest.R

test_that("t test works mathematically", {
  sample1 <- c(-7, -12, -4, 152, -23, -30, -3)
  expect_is(my_ttest(sample, alternative="two.sided", 0), "list")
})
test_that("non numeric parameter throws error", {
  x <- c("hi", "hello", "good morning")
  expect_error(my_ttest(x, alternative="less", 3))
})
