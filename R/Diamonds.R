library(tidyverse)

diamonds %>%
ggplot2::ggplot(aes(carat, price)) +
  ggplot2::geom_hex()

ggplot2::ggsave("diamonds.pdf")

utils::write.csv(diamonds, "diamonds.csv")
