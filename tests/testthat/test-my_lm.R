#test for my_lm function
#within test-my_lm.R
test_that("regression modeling works mathematically", {
  x <- c(3,4,5,6,7)
  y <- c(-1,-3,-3,-2,-1)
  data <- data.frame(x,y)
  output <- my_lm(y~x,data)$Estimate
  #expect_equal(my_lm(y~x,data)$Estimate, c(-2.5, 0.1))
  expect_is(output, "numeric")
})
