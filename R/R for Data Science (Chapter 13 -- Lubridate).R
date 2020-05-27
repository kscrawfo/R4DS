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
# option 1: i think a way to think about this would be to show a box plot of month (or week?) <- bad idea
#  This did not work...
# option 2: show a dot plot that shows how many flights occurred each month by month
#  It does not appear that there is significant difference here

flights_dt %>%
  mutate(
    yday = month(dep_time),
    tday = hour(dep_time)
  ) %>%
  group_by(yday, tday) %>%
  tally %>%
  ggplot(aes(yday, tday, size = n)) +
  geom_point()

# option 3: show a smoothed curve of the mean + CI (geom_smooth)
#  This shows that there is no real pattern - maybe a slightly later average around March-April, and slightly earlier Sep-Oct, but very minor
flights_dt %>%
  mutate(
    yday = month(dep_time),
    tday = hour(dep_time)
  ) %>%
  ggplot(aes(yday, tday)) +
  geom_smooth() +
  ylim(0,24)


## 2
flights_dt %>%
  select(sched_dep_time, dep_time, dep_delay) %>%
  mutate(delta = sched_dep_time + minutes(dep_delay) - dep_time) %>%
  filter(delta != 0)


# there are 1205 flights that have either incorrect scheduled or actual depature dates - they are off by exactly 1 day. There are no other anomolies

## 3
# join in time zones for the destination airports from the airports dataframe
# for the airports missing a timezone, they are all in the America/Puerto_Rico tz...so can use that
# convert all times to UTC time

make_datetime_tz <- function(df=NULL, tz_var=NULL){
  df %>%
    mutate(arr_tim_n = lubridate::make_datetime(year=year, month=month, day=day, arr_time %/% 100, arr_time %% 100, tz = {{tz_var}}))
}

temp <- flights %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  mutate(tzone = if_else(is.na(tzone), "America/Puerto_Rico", tzone))

temp$tzone[1] = "America/New_York"

temp <- temp %>%
  mutate(dep_time_n = make_datetime(year, month, day, dep_time %/% 100, dep_time %% 100, tz = "America/New_York"),
         hour = arr_time %/% 100,
         min = arr_time %% 100,
         dep_time_2 = with_tz(dep_time_n, "UTC"),
         arr_time_n = make_datetime(year, month, day, arr_time %/% 100, arr_time %% 100, tz = tzone),
         arr_time_2 = with_tz(arr_time_n, "UTC"),
         flight_duration = difftime(arr_time_n, dep_time_n, units = "mins"),
         delta = flight_duration - air_time
  )

temp$arr_time_n[2]
temp$arr_time_n[3]


new_times <- purrr::pmap(.l = list(year=temp$year, month=temp$month, day=temp$day, hour=temp$hour, min=temp$min, tzone = temp$tzone),
            function(year=year,month=month,day=day,hour=hour,min=min,tzone=tzone)
              lubridate::make_datetime(year=year, month=month, day=day, hour=hour, min=min, tz = tzone))

## try this with purr::pmap_dfr

temp$arr_time_n <- as_datetime(unlist(new_times))

temp$arr_time_2 <- with_tz(temp$arr_time_n, "UTC")



temp <- flights %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  mutate(tzone = if_else(is.na(tzone), "America/Puerto_Rico", tzone)) %>%
  mutate(dep_time_n = make_datetime(year, month, day, dep_time %/% 100, dep_time %% 100, tz = "America/New_York"),
         arr_time_n = make_datetime(year, month, day, arr_time %/% 100, arr_time %% 100, tz = tzone),
         flight_duration = difftime(arr_time_n, dep_time_n, units = "mins"),
         delta = flight_duration - air_time
  )



make_datetime_tz(temp, tz = "tzone")





make_datetime(temp$year[3],
              temp$month[3],
              temp$day[3],
              temp$arr_time[3] %/% 100,
              temp$arr_time[3] %% 100,
              tz_ny = temp$tzone[3]
)



make_datetime(temp$year[1],
              temp$month[1],
              temp$day[1],
              temp$arr_time[1] %/% 100,
              temp$arr_time[1] %% 100,
              tz = temp$tzone[1]
)

with_tz(chi_time, "UTC")
with_tz(ny_time, "UTC")

airports
?flights
?make_datetime
