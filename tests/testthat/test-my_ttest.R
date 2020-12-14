test_that("multiplication works", {
  sample1 <- c(-7, -12, -4, 152, -23, -30, -3)
  expect_is(my_ttest(sample, alternative="two.sided", 0), "list")
})
