library(tidyverse)
library(nycflights13)

##########
#missing quite a bit of stuff before I started putting this in, so this code won't actually run without
#setting up some data frames before this code
##########

##5.6.1

##5.6.2
not_cancelled %>% group_by(dest) %>%  summarise(n())
not_cancelled %>% group_by(tailnum) %>% summarize(sum(distance))

##5.6.3

##5.6.4
flights <- flights %>% mutate(cancelled = (is.na(dep_delay) | is.na(arr_delay)))

flights %>% group_by(year, month, day) %>% summarise(portion = sum(cancelled) / n(), mean = mean(dep_delay, na.rm = TRUE)) %>% 
  +     ggplot(mapping = aes(x = portion, y = mean)) +
  +     geom_point()

##5.6.5
flights %>%
  group_by(carrier) %>%
  summarise(mean = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(mean)) %>%
  ggplot(mapping = aes(carrier, mean)) +
  geom_point()
#F9 has the worst delays

#not sure how i would fully disentangle the destination from the carrier
#potentially go after comparing the mean delay for a carrier vs other carriers on the same route?
flights %>%
  filter(!is.na(arr_delay)) %>% 
  group_by(origin, dest, carrier) %>%
  summarise(
    arr_delay = sum(arr_delay),
    flights = n()
  ) %>%
  group_by(origin, dest) %>%
  mutate(
    arr_delay_total = sum(arr_delay),
    flights_total = sum(flights)
  ) %>% 
  ungroup() %>% 
  mutate(
    arr_delay_others = (arr_delay_total - arr_delay) / (flights_total - flights),
    arr_delay_mean = arr_delay / flights,
    arr_delay_diff = arr_delay_mean - arr_delay_others
  ) %>% 
  filter(is.finite(arr_delay_diff)) %>% 
  group_by(carrier) %>% 
  summarise(avg_delay = mean(arr_delay_diff))
#OO is actually the worst

##5.6.6
#need to do a count while delay < 60, group_by tailnum?
flights %>%
  group_by(tailnum) %>%
  arrange(time_hour) %>% 
  mutate(
    cum = arr_delay > 60,
    cum_any = cumsum(cum)
  ) %>%
  filter(cum_any < 1) %>% 
  tally() %>% 
  arrange(desc(n))

##5.6.7
#sort is a shortcut instead of using arrange(desc(n))

###############################
##Grouped Mutates and Filters##
###############################
flights_sml <- flights %>% 
  select(
    year:day,
    ends_with("delay"),
    distance,
    air_time
  )

flights_sml %>% 
  group_by(year, month, day) %>% 
  filter(rank(desc(arr_delay)) < 10)
#filter here is taking the worst 9 arr_delays per day

popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)
popular_dests
#filters to only the destinations with >365 flights

popular_dests %>%
  filter(arr_delay >0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)
#popular_dests is still grouped by dest...even though it doesnt show as grouped?
#adds a probability of delay...

###5.7
##5.7.1
#Cross-row functions work within the group
#-mean, median, sum, std
#-lead, lag
#-cumulatives
#-ranking
#Row-wise functions ignore the grouping (only works on the specified row anyway)
#-arthimatic, operators
#-logic (==, <, etc)
#Arange ignores grouping (not sure why though...)

##5.7.2
#we should figure out how many flights we need to have to qualify
quantile(count(flights, tailnum)$n)

#summarise the mean arr_delay and then filter out tailnums with < 23 flights
flights %>% 
  group_by(tailnum) %>%
  summarise(arr_delay = mean(arr_delay), n = n()) %>%
  filter(n >= 23) %>% 
  arrange(desc(arr_delay))
#N203FR's average delay is 59.1 mins

##5.7.3
#groupby hour
#find delays
#sort
flights %>% 
  group_by(hour) %>%
  summarise(arr_delay = mean(arr_delay, na.rm = TRUE))

#early morning (before 8) is best

##5.7.4
#Arr_delay by dest
flights %>% 
  filter(!is.na(arr_delay)) %>% 
  group_by(dest) %>%
  summarise(total_delay = sum(arr_delay)) %>% 
  arrange(desc(total_delay))

#Prop of arr_delay for each dest by flight
flights %>% 
  select(dest, arr_delay) %>% 
  filter(!is.na(arr_delay)) %>% 
  group_by(dest) %>%
  mutate(total_delay = sum(arr_delay),
          prop_delay = arr_delay / total_delay)

##5.7.5
flights %>%
  filter(!is.na(dep_delay)) %>% 
  select(origin, flight, dep_delay) %>%
  group_by(origin) %>% 
  mutate(lag_delay = lag(dep_delay)) %>% 
  group_by(lag_delay) %>% 
  summarise(mean = mean(dep_delay)) %>% 
  ggplot(aes(y = mean, x = lag_delay)) +
  geom_point()
#looking pretty highly correlated

##5.7.6
#how do i find a reasonable measure for the shortest flight time on a route?
#need to group by origin and destination so that I get specific flight paths
#need to remove flights that were cancelled
#do i need to check and see if the flight time I calc is the same as the air time? I don't think so for now (requires using time zones...)
flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>%
  select(origin, dest, air_time) %>% 
  group_by(origin, dest) %>% 
  mutate(std = sd(air_time), mean_air = mean(air_time), z = (air_time - mean_air)/std) %>% 
  arrange(z)
#anything negative for rel is suspect, but only the much more negative are likely errors (some are just the bottom 10%)

flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>%
  select(origin, dest, air_time) %>% 
  group_by(origin, dest) %>% 
  mutate(std = sd(air_time), mean_air = mean(air_time), z = (air_time - mean_air)/std) %>% 
  arrange(desc(z))
#The flights that are highest on this list lost the most time in the error relative to how long their flight was
#probably a number of these flights (say anything that is more than twice as long as Q9) are data entry errors


##5.7.7
#group by dest and carrier
#summarise counts
flights %>% 
  group_by(dest) %>% 
  mutate(carriers = n_distinct(carrier)) %>% 
  filter(carriers > 1) %>% 
  group_by(carrier) %>% 
  summarise(dests = n_distinct(dest)) %>% 
  arrange(desc(dests))

airlines %>% 
  filter(carrier == "EV")

#expressjet services the most destinations with at least 2 carriers servicing (51)