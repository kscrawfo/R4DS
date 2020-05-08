### Lubridate

library(lubridate)
library(tidyverse)
library(nycflights13)


### Creating dates / times

today()
now()

ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31-Jan-2017")

ymd(20170131)

ymd_hms("2017-01-31 20:11:14")
ymd_hm("2017-01-31 20:15")
ymd_hm("2017-01-31 2012")

ymd_hm("2017-01-31 2015", tz = "UTC")

flights %>%
  select(year, month, day, hour, minute)

flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(
    departure = make_datetime(year, month, day, hour, minute)
  )

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights_dt <- flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time),
  ) %>%
  select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt %>%
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth = 86400)

flights_dt %>%
  filter(dep_time < ymd(20130102)) %>%
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth = 600)

as_date(now())

as_datetime(today())

as_date(365*10+2)

as_datetime(60*60*10)

### 13.1 Exercises

## 1
ymd(c("2010-10-10", "bananas"))
# ymd parses as 'NA'

## 2
?today
today(tzone = "NZ")
# this gives the date in the specified TZ (which may be different if they are on a different day!)

## 3
mdy("January 1, 2010")
ymd("2015-Mar-07")
dmy("06-Jun-2017")
mdy(c("August 19 (2015)", "July 1 (2015)"))
mdy("12/30/14")

### Date-time components

datetime <- ymd_hms("2016-07-08 12:34:56")

year(datetime)
month(datetime)
mday(datetime)
day(datetime)
yday(datetime)
wday(datetime)
month(datetime, label = TRUE)
wday(datetime, label = TRUE)

flights_dt %>%
  mutate(wday = wday(dep_time, label = TRUE)) %>%
  ggplot(aes(x = wday)) +
  geom_bar()

flights_dt %>%
  mutate(minute = minute(dep_time)) %>%
  group_by(minute) %>%
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()) %>%
  ggplot(aes(minute, avg_delay)) +
  geom_line()

sched_dep <- flights_dt %>%
  mutate(minute = minute(sched_dep_time)) %>%
  group_by(minute) %>%
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n())

ggplot(sched_dep, aes(minute, avg_delay)) +
  geom_line()

ggplot(sched_dep, aes(minute, n)) +
  geom_line()

flights_dt %>%
  count(week = floor_date(dep_time, "week")) %>%
  ggplot(aes(week, n)) +
  geom_line()

year(datetime) <- 2020
month(datetime) <- 7
hour(datetime) <- 23

update(datetime, year = 2021, month = 4, mday = 7, hour = 17)
ymd("2015-02-01") %>%
  update(mday = 35)

flights_dt %>%
  mutate(dep_hour = update(dep_time, yday = 1)) %>%
  ggplot(aes(dep_hour)) +
  geom_freqpoly(binwidth = 1000)

### 13.2 exercises
## 1
## how does the distribution of flights within a day change over the course of a year?
# i think a way to think about this would be to show a box plot of month (or week?) <- bad idea
# show a smoothed line for the number of flights per time of day by month

flights_dt %>%
  mutate(
    yday = month(dep_time),
    tday = hour(dep_time)
  ) %>%
  group_by(yday, tday) %>%
  tally() %>%
  ggplot() +
  geom_smooth(aes(yday, tday))

# looks like the time of day for the flights is initially decreasing to an average of about 11am, then climbs to about 1215 thought september, to fall back to 11am by the end of the year
# this doesn't feel right, but having trouble cleaning it up / figuring out what I'm missing...

## 2
flights %>%
  mutate(delta = dep_time - sched_dep_time - dep_delay) %>%
  select(delta, sched_dep_time, dep_time, dep_delay) %>%
  arrange(-desc(delta))
