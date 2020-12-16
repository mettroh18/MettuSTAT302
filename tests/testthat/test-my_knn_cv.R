#tests within test-my_knn_cv file

test_that("cross validation works", {
  data1 <- my_penguins %>% na.omit() %>%
    dplyr::select(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g, species)
  expect_is(my_knn_cv(train = data1, cl = 'species', k_nn = 3, k_cv = 5), "list")
})

test_that("non numeric parameter throws error", {
  expect_error(my_knn_cv(train = penguins, cl = 'species', k_nn = "blue", k_cv = "green"))
})

