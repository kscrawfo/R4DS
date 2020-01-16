library(tidyverse)

####5.1 - Variation

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

diamonds %>% 
  count(cut)

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.25)

diamonds %>% 
  count(cut_width(carat, 0.25))

diamonds %>% 
  filter(carat < 3) %>% 
  ggplot +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.1)

diamonds %>% 
  filter(carat < 3) %>% 
  ggplot(mapping = aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)

diamonds %>% 
  filter(carat < 3) %>% 
  ggplot +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.01)

faithful %>% 
  ggplot +
  geom_histogram(mapping = aes(x = eruptions), binwidth = 0.25)

diamonds %>% 
  ggplot +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,50))

unusual_diamonds <- diamonds %>% 
  filter(y <3 | y > 20) %>% 
  arrange(y)

unusual_diamonds

###5.1 Exercises
##1
diamonds %>% 
  ggplot +
  geom_histogram(mapping = aes(x = x), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,100))

diamonds %>% 
  filter(x < 3 | x > 10)

#for x, looks like data entry errors for 8 diamonds (0 for x)

diamonds %>% 
  ggplot +
  geom_histogram(mapping = aes(x = z), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,100))

diamonds %>% 
  filter(z < 1 | z > 10) %>% 
  arrange(z) %>%
  print(n = 50)

#for z, looks like data entry errors for 21 diamonds (20 = 0 for z, 1 = 31.8 instead of 3.18 for z)
#x = longer width, y = narrower width, z = depth

##2
diamonds %>% 
  ggplot +
  geom_histogram(mapping = aes(x = price), binwidth = 50) +
  coord_cartesian(xlim = c(500,1500))
#Looks like peak number is around $700 per diamond -- is this to make overall ring price ~$1000?

diamonds %>% 
  filter(price > 500 & price < 2000) %>% 
  ggplot +
  geom_histogram(mapping = aes(x = price), binwidth = 50) +
  coord_cartesian(ylim = c(0,50))

#no diamonds that cost $1500...why?

##3
diamonds %>% 
  count(cut_width(carat, 0.1, boundary = 0.09))

diamonds %>% 
  filter(carat == 0.99) %>% 
  tally()

diamonds %>% 
  filter(carat == 1.0) %>% 
  tally()

#1558 are 1.0 carat, 23 are 0.99 carat. Likely marketing / filtering...people want a full 1 carat diamond...

##4
diamonds %>% 
  ggplot +
  geom_histogram(mapping = aes(x = carat)) +
  coord_cartesian(xlim = c(0.5,2.5))

diamonds %>% 
  ggplot +
  geom_histogram(mapping = aes(x = carat)) + 
  xlim(0.5, 2.5)

#xlim clips data off (makes it NA), which means that it will only scale to the data in the window
#coord_cartesian does not clip the data, which means that data will still show at the edge of the graph and can impact scaling


####5.2 - Missing Values

diamonds2 <- diamonds %>% 
  filter(between(y,3,20))

diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

diamonds2 %>% 
  ggplot +
  geom_point(mapping = aes(x = x, y = y))

library(nycflights13)

flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) +
  geom_freqpoly(mapping = aes(color = cancelled), binwidth = 1/4)

###5.2 Exercises
##1
diamonds2 %>%
  mutate(cut = ifelse(carat < 0.5, NA_character_, cut)) %>% 
  ggplot(mapping = aes(x = cut)) +
  geom_bar()

diamonds2 %>% 
  ggplot(mapping = aes(x = y)) +
  geom_histogram()

#Bar makes a NA bin, histogram just notifies (can't figure out where to bin on a continuous variable)

##2
mean(diamonds2$y)
mean(diamonds2$y, na.rm = TRUE)
#na.rm in mean and sum removes NA values, which allows means and sums to be calculated

####5.3 - Covariation

diamonds %>% 
  ggplot(mapping = aes (x = price)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

diamonds %>%
  ggplot() +
  geom_bar(mapping = aes(x = cut))

diamonds %>% 
  ggplot(mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

diamonds %>% 
  ggplot(mapping = aes(x = cut, y = price)) +
  geom_boxplot()

mpg %>% 
  ggplot(mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

mpg %>% 
  ggplot +
  geom_boxplot(mapping = aes(
    x = reorder(class, hwy, FUN = median),
    y = hwy
    )
  )

mpg %>% 
  ggplot +
  geom_boxplot(mapping = aes(
    x = reorder(class, hwy, FUN = median),
    y = hwy
    )
  ) +
  coord_flip()


###5.3 Exercises
##1
flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(x = sched_dep_time, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cancelled), binwidth = 1/4)

flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(x = cancelled, y = sched_dep_time)) +
  geom_boxplot()

##2
#carat
diamonds %>% 
  ggplot(mapping = aes(x = carat, y = price)) +
  geom_point()

diamonds %>% 
  ggplot(mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))

#cut -no
diamonds %>% 
  ggplot(mapping = aes(x = cut, y = price)) +
  geom_boxplot()

#color -no
diamonds %>% 
  ggplot(mapping = aes(x = color, y = price)) +
  geom_boxplot()

#clarity -no
diamonds %>% 
  ggplot(mapping = aes(x = clarity, y = price)) +
  geom_boxplot()

#x -yes (but really likely due to carat size)
diamonds %>% 
  ggplot(mapping = aes(x = x, y = price)) +
  geom_point()

#y -no
diamonds %>% 
  ggplot(mapping = aes(x = y, y = price)) +
  geom_point()

#z -no
diamonds %>% 
  ggplot(mapping = aes(x = z, y = price)) +
  geom_point()

#depth -no
diamonds %>% 
  ggplot(mapping = aes(x = depth, y = price)) +
  geom_point()

#table -no
diamonds %>% 
  ggplot(mapping = aes(x = table, y = price)) +
  geom_point()

#cut vs carat
diamonds %>% 
  ggplot(mapping = aes(x = cut, y = carat)) +
  geom_boxplot()

#essentially, bigger diamonds generally have worse cuts (logical in that a good cut is easier on a smaller size / less imperfections in the way)...but bigger = more expensive, so worse cuts = more expensive

##3
mpg %>% 
  ggplot(mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

mpg %>% 
  ggplot(mapping = aes(x = hwy, y = class)) +
  ggstance::geom_boxploth()

#have to flip the x and y with geom_boxploth...as we need the variables to be flipped...whereas with coord_flip it flips the variables for us

##4
diamonds %>% 
  ggplot(mapping = aes(x = cut, y = price)) +
  lvplot::geom_lv()

#Looks like the higher quality cuts are more square distributions with a heavier tail - there are lots of expensive ideal cut diamonds, but also lots of cheap ones
#interpret based on the shape of the 'box' - the fatter the box is farther out, the more obversations exist far out on the scale

##5
diamonds %>% 
  ggplot(mapping = aes(x = cut, y = price)) +
  geom_violin()
#pros: gives a great view of the shape of the distributions for each category
#cons: hard to infer differences if they are similar (good v premium)

diamonds %>% 
  ggplot(mapping = aes(price)) +
  geom_histogram() +
  facet_grid(rows = vars(cut))
#pros: shows absolute counts - gives a better idea of fair diamonds and the fact that their much smaller numbers makes them less interesting
#cons: hard to understand distributions, as this is non-normalized

diamonds %>% 
  ggplot(mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)
#pros: easier to see the overall distributions
#cons: hard to compare due to poor visual + no good idea of comparative distributions

##6
mpg %>% 
  ggplot(mapping = aes(x = class, y = cty)) +
  geom_point()

mpg %>% 
  ggplot(mapping = aes(x = class, y = cty)) +
  ggbeeswarm::geom_beeswarm()
#gives a  violin plot of points with some method for determining offset / jitter

mpg %>% 
  ggplot(mapping = aes(x = class, y = cty)) +
  ggbeeswarm::geom_quasirandom()
#gives a violin plot of points with a random offset / jitter


###5.3.2
diamonds %>% 
  ggplot() +
  geom_count(mapping = aes(x = cut, y = color))

diamonds %>% 
  count(color, cut) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

###Exercises 5.3.2
##1
#color
diamonds %>% 
  count(color, cut) %>% 
  group_by(color) %>% 
  mutate(prop = n / sum(n)) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = prop))

#cut
diamonds %>% 
  count(color, cut) %>% 
  group_by(cut) %>% 
  mutate(prop = n / sum(n)) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = prop))

##2
library(nycflights13)
nycflights13::flights %>% 
  dplyr::group_by(dest, month) %>% 
  dplyr::summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>% 
  ggplot2::ggplot(mapping = aes(x = factor(month), y = dest)) +
  ggplot2::geom_tile(mapping = aes(fill = dep_delay))

#Messy because there is too much data to meaningfully view
#could sort the destinations by something interesting, like overall average delay or average delay for a given month

nycflights13::flights %>% 
  dplyr::group_by(dest, month) %>% 
  dplyr::summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>% 
  dplyr::group_by(dest) %>% 
  dplyr::filter(n() == 12) %>% #removes the airports without flights every month
  dplyr::ungroup() %>% 
  ggplot2::ggplot(mapping = aes(x = factor(month), y = dest)) +
  ggplot2::geom_tile(mapping = aes(fill = dep_delay)) +
  ggplot2::labs(x = "Month", y = "Destination")

##3
diamonds %>% 
  count(color, cut) %>% 
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

diamonds %>% 
  count(color, cut) %>% 
  ggplot(mapping = aes(x = cut, y = color)) +
  geom_tile(mapping = aes(fill = n))

#no good reason. Potentially better for x = color, as the values for color are shorter than the values for cut?


###5.3.3
diamonds %>% 
  ggplot2::ggplot() +
  ggplot2::geom_point(mapping = aes(x = carat, y = price))

diamonds %>% 
  ggplot2::ggplot() +
  ggplot2::geom_point(mapping = aes(x = carat, y = price),
                      alpha = 1/10)

diamonds %>% 
  ggplot2::ggplot() +
  ggplot2::geom_bin2d(mapping = aes(x = carat, y = price))

library(hexbin)
diamonds %>% 
  ggplot2::ggplot() +
  ggplot2::geom_hex(mapping = aes(x = carat, y = price))

diamonds %>% 
  ggplot2::ggplot(mapping = aes(x = carat, y = price)) +
  ggplot2::geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))

diamonds %>% 
  ggplot2::ggplot(mapping = aes(x = carat, y = price)) +
  ggplot2::geom_boxplot(varwidth = TRUE, mapping = aes(group = cut_width(carat, 0.1)))

diamonds %>% 
  ggplot2::ggplot(mapping = aes(x = carat, y = price)) +
  ggplot2::geom_boxplot(mapping = aes(group = cut_number(carat, 15)))

###Exercises 5.3.3
##1
diamonds %>% 
  ggplot2::ggplot(mapping = aes(x = carat)) +
  ggplot2::geom_freqpoly(mapping = aes(color = cut_width(carat, 0.2)))

diamonds %>% 
  ggplot2::ggplot(mapping = aes(x = carat)) +
  ggplot2::geom_freqpoly(mapping = aes(color = cut_number(carat, 10)))
#cut_width evenly distributes bins, so for the large tail of carat sizes, will have lots of empty / uninteresting bins
#cut_number creates as many bins as make sense, unevenly distributed, so makes a higher fidelity plot in the area of interesting data (higher density)

##2
diamonds %>% 
  ggplot2::ggplot(mapping = aes(x = price, y = carat)) +
  ggplot2::geom_boxplot(mapping = aes(group = cut_width(price, 500)))

##3
#Smaller diamonds have a tighter distribution of price...all cost about the same
#Very large diamonds have a much higher variability in price. Potentially due to differences in cut / clarity that more significantly impact price?

##4
diamonds %>% 
  ggplot2::ggplot(mapping = aes(x = cut_width(price,2000), y = carat, color = cut)) +
  ggplot2::geom_boxplot()


##5
diamonds %>% 
  ggplot2::ggplot() +
  ggplot2::geom_point(mapping = aes(x = x, y = y)) +
  coord_cartesian(xlim = c(4,11), ylim = c(4,11))

diamonds %>% 
  ggplot2::ggplot(mapping = aes(x = cut_width(x,1), y = y)) +
  ggplot2::geom_boxplot()

#On a binned plot like a boxplot, these outliers would show very well (and they do when I plotted the boxplots...)
#On another type of binned plot, like a freq poly, these outliers would disappear, as you wouldn't get anything plotted beyond basic summary stats

###5.4 Patters and Models
faithful %>% 
  ggplot2::ggplot(mapping = aes(x = eruptions, y = waiting)) +
  ggplot2::geom_point()

library(modelr)

mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))

diamonds2 %>% 
  ggplot2::ggplot(mapping = aes(x = carat, y = resid)) +
  ggplot2::geom_point()

diamonds2 %>% 
  ggplot2::ggplot(mapping = aes(x = cut, y = resid)) +
  ggplot2::geom_boxplot()

#more efficient way to write this, as we know that mapping is the second variable (somewhat like piping in...)
faithful %>% 
  ggplot2::ggplot(aes(eruptions, waiting)) +
  ggplot2::geom_point()
