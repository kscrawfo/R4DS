###10.1 nycflights
nycflights13::airlines
nycflights13:: airports
nycflights13::planes
nycflights13::weather

###10.1 Exercises
##1
#I would need the lat/long of the origin and the destination airport
#I would need to use the foreign key for both origin and destination (which are both airport codes) in the flights table to reference the airports table

##2
#Weather and Airport are related by the origin (Weather) and faa (Airport)

##3
#origin (weather) and dest (flights)

##4
#I would create another dataframe called 'Calendar' or 'Holidays'
#In that data frame, I would have fields for day, month (maybe year?), <whatever details we want about the date)
#I would relate this new dataframe to the flights data via the day, month

###10.2 Keys
nycflights13::planes %>%
  dplyr::count(tailnum) %>%
  dplyr::filter(n > 1)

nycflights13::weather %>%
  dplyr::count(year, month, day, hour, origin) %>%
  dplyr::filter(n > 1)

#I don't know why, but weather has 3 sets of 2 observations that occur with the same set of primary keys???

nycflights13::weather %>%
  dplyr::filter(year == '2013', month == '11', day == '3', hour == '1', origin == 'EWR')

#Observations are obviously different here (temp, humid, wind_dir, wind_speed)...but why are there two???

nycflights13::flights %>%
  dplyr::count(year, month, day, flight, tailnum) %>%
  dplyr::filter(n > 1)

###10.2 Exercises
##1
nycflights13::flights %>%
  dplyr::mutate(surrogate = dplyr::row_number())

##2a
Lahman::Batting %>%
  dplyr::count(playerID, yearID, stint) %>%
  dplyr::filter(n > 1)

##2b
babynames::babynames %>%
  dplyr::count(year, sex, name) %>%
  dplyr::filter(n > 1)

##2c
nasaweather::atmos %>%
  dplyr::count(lat, long, year, month) %>%
  dplyr::filter(n > 1)

##2d
fueleconomy::vehicles %>%
  dplyr::count(id) %>%
  dplyr::filter(n > 1)

##2e
ggplot2::diamonds %>%
  dplyr::count(carat, cut, color, clarity, depth, table, price, x, y, z) %>%
  dplyr::filter(n > 1)
#no key for diamons - there are many diamonds that are identical by these specifications

##3
##Batting - Master - Salaries
head(Lahman::Batting)
head(Lahman::Master)
head(Lahman::Salaries)
Lahman::Salaries %>%
  dplyr::count(playerID, yearID, teamID) %>%
  dplyr::filter(n > 1)

#Batting (playerID) - Master (playerID)
#Batting (playerID) - Salaries (PlayerID)
#Batting (yearID) - Salaries (yearID)
#Batting (teamID) - Salaries (teamID)

##Master, Manager, Awards Manager
head(Lahman::Master)
head(Lahman::Managers)
head(Lahman::AwardsManagers)

#Master (playerID) - Managers (playerID)
#AwardsManagers (playerID) - Managers (playerID)
#Manager (yearID) - AwardManagers (yearID)

##Batting - Pitching - Fielding
head(Lahman::Batting)
head(Lahman::Pitching)
head(Lahman::Fielding)
#These are three tables providing statistics about players in a specific year during a specific stint, which is how they are related
#You could key across the tables via playerID, YearID, stint

###10.3 Mutating Joins

flights2 <- nycflights13::flights %>%
  dplyr::select(year:day, hour, origin, dest, tailnum, carrier)

utils::View(flights2)

flights2 %>%
  dplyr::select(-origin, -dest) %>%
  dplyr::left_join(nycflights13::airlines, by = 'carrier')

flights2 %>%
  dplyr::select(-origin, -dest) %>%
  dplyr::mutate(name = nycflights13::airlines$name[base::match(carrier, nycflights13::airlines$carrier)])

x <- tibble::tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tibble::tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

x %>%
  dplyr::inner_join(y, by = "key")

x %>%
  dplyr::left_join(y, by = "key")

x %>%
  dplyr::right_join(y, by = "key")

x %>%
  dplyr::full_join(y, by = "key")

x <- tibble::tribble(
  ~key, ~value,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)

y <- tibble::tribble(
  ~key, ~value,
  1, "y1",
  2, "y2"
)

dplyr::left_join(x,y, by = "key")

y <- tibble::tribble(
  ~key, ~value,
  1, "y1",
  2, "y2",
  2, "y3",
  1, "y4"
)

dplyr::left_join(x, y, by = "key")

flights2 %>%
  dplyr::left_join(nycflights13::weather)

flights2 %>%
  dplyr::left_join(nycflights13::planes, by = "tailnum")

flights2 %>%
  dplyr::left_join(nycflights13::airports, by = c("dest" = "faa"))

###10.3 Exercises
##1.

nycflights13::flights %>%
  dplyr::filter(!is.na(arr_delay)) %>%
  dplyr::group_by(dest) %>%
  dplyr::summarise(avg_delay = mean(arr_delay)) %>%
  dplyr::left_join(nycflights13::airports, c("dest" = "faa")) %>%
  ggplot2::ggplot(ggplot2::aes(lon, lat)) +
  ggplot2::borders("state") +
  ggplot2::geom_point(ggplot2::aes(color = avg_delay)) +
  ggplot2::coord_quickmap()

##2
airport_lat_long <- nycflights13::airports %>%
  dplyr::select(faa, lat, lon)

nycflights13::flights %>%
  dplyr::left_join(airport_lat_long, c("origin" = "faa")) %>%
  dplyr::left_join(airport_lat_long, c("dest" = "faa"))

rm(airport_lat_long)

##3
nycflights13::flights %>%
  dplyr::filter(!is.na(arr_delay)) %>%
  dplyr::group_by(tailnum) %>%
  dplyr::summarise(avg_delay = mean(arr_delay)) %>%
  dplyr::left_join(nycflights13::planes, c("tailnum" = "tailnum")) %>%
  ggplot2::ggplot(ggplot2::aes(year, avg_delay)) +
  ggplot2::geom_boxplot(ggplot2::aes(group = year))

#it looks like there are no unreliable older planes (those would likely no longer be in service)
#it looks like there is some variability to middle-aged planes (some major outliers on the average delay)
#it looks like the newest planes are generally on time

##4
#temp
nycflights13::flights %>%
  dplyr::filter(!is.na(arr_delay)) %>%
  dplyr::left_join(nycflights13::weather) %>%
  dplyr::group_by(temp) %>%
  dplyr::summarise(avg_delay = mean(arr_delay)) %>%
  ggplot2::ggplot(ggplot2::aes(temp, avg_delay)) +
  ggplot2::geom_line() +
  ggplot2::geom_point()
#nothing really here

#dewpoint
nycflights13::flights %>%
  dplyr::filter(!is.na(arr_delay)) %>%
  dplyr::left_join(nycflights13::weather) %>%
  dplyr::group_by(dewp) %>%
  dplyr::summarise(avg_delay = mean(arr_delay)) %>%
  ggplot2::ggplot(ggplot2::aes(dewp, avg_delay)) +
  ggplot2::geom_line() +
  ggplot2::geom_point()
#dewpoints between -5,2 look like they have higher delays
#as dewpoint gets much higher (>50), delays trend up

#humidity
nycflights13::flights %>%
  dplyr::filter(!is.na(arr_delay)) %>%
  dplyr::left_join(nycflights13::weather) %>%
  dplyr::group_by(humid) %>%
  dplyr::summarise(avg_delay = mean(arr_delay)) %>%
  ggplot2::ggplot(ggplot2::aes(ggplot2::cut_width(humid,5), avg_delay)) +
  ggplot2::geom_boxplot()
#as humidity rises above about 65%, there is correlation to higher delays

#wind direction
nycflights13::flights %>%
  dplyr::filter(!is.na(arr_delay)) %>%
  dplyr::left_join(nycflights13::weather) %>%
  dplyr::group_by(wind_dir) %>%
  dplyr::summarise(avg_delay = mean(arr_delay)) %>%
  ggplot2::ggplot(ggplot2::aes(wind_dir, avg_delay)) +
  ggplot2::geom_line() +
  ggplot2::geom_point()
#somehow it looks like wind from the east and south results in longest delays
#I postulate that this is 'non-normal' wind (which prevails from the west), and would likely be the result of a storm

#wind speed
nycflights13::flights %>%
  dplyr::filter(!is.na(arr_delay)) %>%
  dplyr::left_join(nycflights13::weather) %>%
  dplyr::group_by(wind_speed) %>%
  dplyr::summarise(avg_delay = mean(arr_delay)) %>%
  ggplot2::ggplot(ggplot2::aes(wind_speed, avg_delay)) +
  ggplot2::geom_line() +
  ggplot2::geom_point()
#higher wind speed seems to be clearly correlated with delays

#wind gust
nycflights13::flights %>%
  dplyr::filter(!is.na(arr_delay)) %>%
  dplyr::left_join(nycflights13::weather) %>%
  dplyr::group_by(wind_gust) %>%
  dplyr::summarise(avg_delay = mean(arr_delay)) %>%
  ggplot2::ggplot(ggplot2::aes(wind_gust, avg_delay)) +
  ggplot2::geom_line() +
  ggplot2::geom_point()
#higher wind gusts = more delays until about 40mph, where it seems to level out

#precip
nycflights13::flights %>%
  dplyr::filter(!is.na(arr_delay)) %>%
  dplyr::left_join(nycflights13::weather) %>%
  dplyr::group_by(precip) %>%
  dplyr::summarise(avg_delay = mean(arr_delay)) %>%
  ggplot2::ggplot(ggplot2::aes(precip, avg_delay)) +
  ggplot2::geom_line() +
  ggplot2::geom_point()
#a small amount of precip results in delays, with some uptrending as more major precip occurs

#pressure
nycflights13::flights %>%
  dplyr::filter(!is.na(arr_delay)) %>%
  dplyr::left_join(nycflights13::weather) %>%
  dplyr::group_by(pressure) %>%
  dplyr::summarise(avg_delay = mean(arr_delay)) %>%
  ggplot2::ggplot(ggplot2::aes(pressure, avg_delay)) +
  ggplot2::geom_line() +
  ggplot2::geom_point()
#as pressure increases, delays trend down

#visib
nycflights13::flights %>%
  dplyr::filter(!is.na(arr_delay)) %>%
  dplyr::left_join(nycflights13::weather) %>%
  dplyr::group_by(visib) %>%
  dplyr::summarise(avg_delay = mean(arr_delay)) %>%
  ggplot2::ggplot(ggplot2::aes(visib, avg_delay)) +
  ggplot2::geom_line() +
  ggplot2::geom_point()
#with any decrease in visibility, delays increase, until they flatten out around 2.5 miles
#I would postulate that when pilots are trying to fly visually, the visibility decrease it a problem...
#but when a pilot is on instruments, all visibility is equally bad

##5
nycflights13::flights %>%
  dplyr::filter(!is.na(arr_delay)) %>%
  dplyr::filter(year == 2013, month == 6, day == 13) %>%
  dplyr::group_by(dest) %>%
  dplyr::summarise(avg_delay = mean(arr_delay)) %>%
  dplyr::left_join(nycflights13::airports, c("dest" = "faa")) %>%
  ggplot2::ggplot(ggplot2::aes(lon, lat)) +
  ggplot2::borders("state") +
  ggplot2::geom_point(ggplot2::aes(color = avg_delay)) +
  ggplot2::coord_quickmap()
#looks like major derechos occurred, which caused high delaysw in the impacted areas (SE USA)

###10.4 - Filtering Joins
top_dest <- nycflights13::flights %>%
  dplyr::count(dest, sort = TRUE) %>%
  utils::head(10)
top_dest

nycflights13::flights %>%
  dplyr::filter(dest %in% top_dest$dest)

nycflights13::flights %>%
  dplyr::semi_join(top_dest)

nycflights13::flights %>%
  dplyr::anti_join(nycflights13::planes, by = "tailnum") %>%
  dplyr::count(tailnum, sort = TRUE)

###10.4 Exercises

##1
nycflights13::flights %>%
  dplyr::filter(is.na(tailnum), !is.na(dep_time))

#if we filter to only flights that have no tailnum, we can see that dep_time looks NA for the first 10 rows
#if we then filter to only flights that have no tailnum and a non-NA depature time, we get no result
#therefore, all flights with no tailnum have no departure time...i.e., they didn't happen

##2
planes_100 <- nycflights13::flights %>%
  dplyr::group_by(tailnum) %>%
  dplyr::summarise(n = dplyr::n()) %>%
  dplyr::filter(n > 100)

nycflights13::flights %>%
  dplyr::semi_join(planes_100)

## 3
fueleconomy::vehicles
fueleconomy::common
fueleconomy::vehicles %>%
  dplyr::semi_join(fueleconomy::common, by = c("make", "model"))

## 4
nycflights13::flights

worst_hours <- nycflights13::flights %>%
  dplyr::group_by(origin, year, month, day, hour) %>%
  dplyr::summarise(delay = mean(dep_delay, na.rm = TRUE)) %>%
  dplyr::arrange(-delay) %>%
  utils::head(48)

nycflights13::weather %>%
  dplyr::semi_join(worst_hours, by = c("year", "month", "day", "hour")) %>%
  dplyr::arrange(year, month, day, hour) %>%
  print(n = 100)

# I don't see anything that quickly jumps out here...
# ----------some room to do some EDA if I felt so inclined!

## 5
dplyr::anti_join(nycflights13::flights, nycflights13::airports, by = c("dest" = "faa"))

nycflights13::airports %>%
  dplyr::filter(faa == "SJU")
# This gives me flights that are to airports that don't have a record in the airports table

dplyr::anti_join(nycflights13::airports, nycflights13::flights, by = c("faa" = "dest"))
# this gives me airports that are in the airports table that no flights have flown to

## 6
nycflights13::flights %>%
  dplyr::filter(!is.na(tailnum)) %>%
  dplyr::group_by(tailnum) %>%
  dplyr::summarise(n = dplyr::n_distinct(carrier)) %>%
  dplyr::filter(n > 1)

# 17 planes flew for more than 1 carrier in this timeframe
