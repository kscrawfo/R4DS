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

### 12.1 Exercises

## 1
gss_cat %>%
  ggplot(aes(rincome)) +
  geom_bar()
# the buckets are not ordered in the perferred way...that is annoying
# also the buckets are lots of text, so they are hard to read and need to turn them angled / vertical?

gss_cat %>%
  ggplot(aes(rincome)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90))
# you could turn rincome into factors probably...

## 2
gss_cat %>%
  count(relig) %>%
  arrange(desc(n))

gss_cat %>%
  count(partyid) %>%
  arrange(desc(n))

## 3
gss_cat %>%
  group_by(relig, denom) %>%
  tally() %>%
  group_by(relig) %>%
  tally() %>%
  arrange(desc(n))

# protestant, christian, other

gss_cat %>%
  ggplot(aes(relig, denom)) +
  geom_point()


### 12.2 modifying factor order

relig <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

relig %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()

relig %>%
  ggplot(aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

relig %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()

rincome <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

rincome %>%
  mutate(rincome = fct_reorder(rincome, age)) %>%
  ggplot(aes(age, rincome)) +
  geom_point()

rincome %>%
  mutate(rincome = fct_relevel(rincome, "Not Applicable")) %>%
  ggplot(aes(age, rincome)) +
  geom_point()

# not applicable is so high because they are likely RETIRED (yay!)

by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  group_by(age, marital) %>%
  count() %>%
  group_by(age) %>%
  mutate(prop = n / sum(n))

by_age %>%
  ggplot(aes(age, prop, color = marital)) +
  geom_line(na.rm = TRUE)

by_age %>%
  ggplot(aes(age, prop, color = fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(color = "marital")
