# Exercise 6

library(tidyverse)

dir.create("output", showWarnings = FALSE)

creator_week4 <- read_csv("temp/creator_week4.csv")

creator_week4_top10 <- creator_week4 %>%
    arrange(desc(impressions_total)) %>%
    slice_head(n = 10)

write_csv(creator_week4_top10, "temp/creator_week4_top10.csv")
