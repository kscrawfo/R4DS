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

gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar()

?fct_rev


### 12.2 Exercises
## 1
gss_cat %>%
  ggplot(aes(tvhours)) +
  geom_bar()

# seems reasonable to me. mean or median would probably both be fine in this instance
mean(gss_cat$tvhours, na.rm = TRUE)
median(gss_cat$tvhours, na.rm = TRUE)

## 2
colnames(gss_cat)

levels(gss_cat$marital)
# arbitrary

levels(gss_cat$race)
# arbitrary

levels(gss_cat$rincome)
# principled

levels(gss_cat$partyid)
# principled

levels(gss_cat$relig)
# arbitrary

levels(gss_cat$denom)
# arbitrary

## 3

rincome <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

rincome %>%
  ggplot(aes(age, rincome)) +
  geom_point()

rincome %>%
  mutate(rincome = fct_relevel(rincome, "Not applicable")) %>%
  ggplot(aes(age, rincome)) +
  geom_point()

?fct_relevel
# because this explicity puts "Not applicable" as the first level in factor

levels(rincome$rincome)
levels(fct_relevel(rincome$rincome, "Not applicable"))

### 12.3 Modifying factor levels

gss_cat %>% count(partyid)


gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat"
  )
         ) %>%
  count(partyid)

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat",
                              "Other"                 = "No answer",
                              "Other"                 = "Don't know",
                              "Other"                 = "Other party"
  )) %>%
  count(partyid)

gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                dem = c("Strong democrat", "Not str democrat"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem")
                                )
         ) %>%
  count(partyid)

gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)

gss_cat %>%
  mutate(relig = fct_lump(relig, n = 5)) %>%
  count(relig)

### 12.3 exercises
## 1
unique(gss_cat$year)

gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                dem = c("Strong democrat", "Not str democrat"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem")
  )
  ) %>%
  count(year, partyid) %>%
  group_by(year) %>%
  mutate(prop = n / sum(n)) %>%
  ggplot(aes(year, prop, color = partyid)) +
  geom_line()

# republicans seem to be downtrending
# dems relatively stable
# indepts (and to some extent others) going up

## 2
levels(gss_cat$rincome)

gss_cat %>%
  mutate(rincome = fct_collapse(rincome,
                                vlow = c("Lt $1000", "$1000 to 2999", "$3000 to 3999", "$4000 to 4999"),
                                low = c("$5000 to 5999", "$6000 to 6999", "$7000 to 7999", "$8000 to 9999"),
                                mid = c("$10000 - 14999", "$15000 - 19999"),
                                high = c("$20000 - 24999", "$25000 or more"),
                                other = c("No answer", "Don't know", "Refused", "Not applicable")
                                )
  ) %>%
  count(rincome)
