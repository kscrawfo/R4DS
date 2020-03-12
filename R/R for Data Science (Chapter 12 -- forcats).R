### Chapter 12 - Forcats

library(tidyverse)
library(forcats)

x1 <- c("Dec", "Apr", "Jan", "Mar")

x2 <- c("Dec", "Apr", "Jam", "Mar")

month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

y1 <- factor(x1, levels = month_levels)
y1

y2 <- factor(x2, levels = month_levels)
y2

y2 <- parse_factor(x2, levels = month_levels)

factor(x1)
f1 <- factor(x1, levels = unique(x1))
f1

f2 <- x1 %>%  factor() %>%  fct_inorder()
f2

levels(f2)

gss_cat

gss_cat %>%
  count(race)

gss_cat %>%
  ggplot(aes(race)) +
  geom_bar()

gss_cat %>%
  ggplot(aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

