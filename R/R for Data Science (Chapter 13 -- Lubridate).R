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

