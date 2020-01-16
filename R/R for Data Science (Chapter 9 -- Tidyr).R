library(magrittr)

tidyr::table1
tidyr::table2
tidyr::table3
tidyr::table4a
tidyr::table4b

tidyr::table1 %>%
  dplyr::mutate(rate = cases / population *10000)

tidyr::table1 %>%
  dplyr::count(year, wt = cases)

tidyr::table1 %>%
  ggplot2::ggplot(ggplot2::aes(year, cases)) +
  ggplot2::geom_line(ggplot2::aes(group = country), color = "grey50") +
  ggplot2::geom_point(ggplot2::aes(color = country))

###9.1 Exercises
##1
#Table1: each variable in a column, each observation in a row
#table2: each value of the count (each cases or population) for each combination of variables has its own row
#table3: each observation has its own row, but the cases and population are combined in a single value for each observation (how can we extrapolate number of cases if we want to know?)
#table4: one of the variables is in a column head across two tables, one showing values for population and one showing values for cases

##2
cases2 <- tidyr::table2 %>%
  dplyr::filter(type == "cases")
population2 <- tidyr::table2 %>%
  dplyr::filter(type == "population")

new_table2 <- dplyr:::left_join(cases2, population2, by = c("country", "year")) %>%
  dplyr::rename("cases" = "count.x", "population" = "count.y") %>%
  dplyr::select(-c("type.x", "type.y")) %>%
  dplyr::mutate(rate = cases / population)

rm(cases2, population2)


cases4_1999 <- tidyr::table4a %>%
  dplyr::select("country", "1999") %>%
  dplyr::mutate(year = "1999") %>%
  dplyr::rename(cases = "1999")

cases4_2000 <- tidyr::table4a %>%
  dplyr::select("country", "2000") %>%
  dplyr::mutate(year = "2000") %>%
  dplyr::rename(cases = "2000")

cases4 <- cases4_1999 %>%
  dplyr::union(cases4_2000)

rm(cases4_1999, cases4_2000)

population4_1999 <- tidyr::table4b %>%
  dplyr::select("country", "1999") %>%
  dplyr::mutate(year = "1999") %>%
  dplyr::rename(population = "1999")

population4_2000 <- tidyr::table4b %>%
  dplyr::select("country", "2000") %>%
  dplyr::mutate(year = "2000") %>%
  dplyr::rename(population = "2000")

population4 <- population4_1999 %>%
  dplyr::union(population4_2000)

rm(population4_1999, population4_2000)

new_table4 <- dplyr:::left_join(cases4, population4, by = c("country", "year")) %>%
  dplyr::mutate(rate = cases / population)

rm(cases4, population4)

#table 2 was easier to work with, as it was already closer to tidy
#tables 4 sucked!

##3
new_table2 %>%
  ggplot2::ggplot(ggplot2::aes(year, cases)) +
  ggplot2::geom_line(ggplot2::aes(group = country)) +
  ggplot2::geom_point(ggplot2::aes(color = country))

#I already made table2 tidy...so this was easy? :)

###9.2 Gather and Spread
tidyr::table4a
tidy4a <- tidyr::table4a %>%
  tidyr::gather(`1999`, `2000`, key = "year", value = "cases")

tidy4b <- tidyr::table4b %>%
  tidyr::gather(`1999`, `2000`, key = "year", value = "population")

dplyr::left_join(tidy4a, tidy4b)

tidyr::table2

tidyr::table2 %>%
  tidyr::spread(key = type, value = count)


###9.2 exercises
##1
stocks <- dplyr::tibble(
  year = c(2015, 2015, 2016, 2016),
  half = c(1,2,1,2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>%
  tidyr::spread(year, return) %>%5
  tidyr::gather("year","return", `2015`,`2016`)

#not symmetrical because half is not selected as part of the spreading or gathering, so it ends up in front during the spread instead of in the middle

##2
tidyr::table4a %>%
  tidyr::gather(1999, 2000, key = "year", value = "cases")
#this is missing ticks around the years...so that gather knows that these are column names

##3
people <- tibble::tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

people %>%
  tidyr::spread(key, value)

#this failes becaues Phillip Woods, age has 2 values (45 and 50)
#we could add any column that uniquely identifies the two different columns (like an observation 1 v observation 2)

##4
preg <- tibble::tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

preg %>%
  tidyr::gather(`male`, `female`, key = "Gender", value = "Count")

#gather this
#variables: pregnant (binary), gender (male or female), count (number of people)

###9.4 Separating and Pull
tidyr::table3

tidyr::table3 %>%
  tidyr::separate(rate, into = c("cases", "population"))

tidyr::table3 %>%
  tidyr::separate(rate, into = c("cases", "population"), sep = "/")

tidyr::table3 %>%
  tidyr::separate(rate, into = c("cases", "population"), convert = TRUE)

tidyr::table3 %>%
  tidyr::separate(year, into = c("C", "X"), sep = 2)

tidyr::table5 %>%
  tidyr::unite(year, century, year, sep = "")

###9.4 Exercises

##1
?tidyr::separate

tibble::tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  tidyr::separate(x, c("one", "two", "three"), extra = "drop")

tibble::tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  tidyr::separate(x, c("one", "two", "three"), extra = "merge")

#extra tells separate what to do with extra pieces that are separated out

tibble::tibble(x = c("a,b,c", "d,e", "h,i,j")) %>%
  tidyr::separate(x, c("one", "two", "three"), fill = "right")

tibble::tibble(x = c("a,b,c", "d,e", "h,i,j")) %>%
  tidyr::separate(x, c("one", "two", "three"), fill = "left")

#fill tells you where to put the missing value (on the left or right side)

##2
#remove takes away the input column (does not keep that column as originally constructed in the ouput)
#this could be useful if you need to index as a separated column + united column
#for example you wanted full year, but also to breakdown by decade...you might want both so that you don't have to reconstruct the date on the fly

##3
?tidyr::extract

tibble::tibble(x = c(NA, "a-b", "a-d", "b-c", "d-e")) %>%
  tidyr::extract(x, "A")

tibble::tibble(x = c(NA, "a-b", "a-d", "b-c", "d-e")) %>%
  tidyr::extract(x, c("A", "B"), "([[:alnum:]]+)-([[:alnum:]]+)")

tibble::tibble(x = c(NA, "a-b", "a-d", "b-c", "d-e")) %>%
  tidyr::extract(x, c("A", "B"), "([[:alnum:]]+)-([[:alnum:]]+)")

tibble::tibble(x = c(NA, "a-b", "a-d", "b-c", "d-e")) %>%
  tidyr::separate(x, c("A","B"))

tibble::tibble(x = c(NA, "a-b", "a-d", "b-c", "d-e")) %>%
  tidyr::separate(x, "A")

#extract requires a regex, which is apparently more complicated...but probably more controlable
#extract does not give extra + fill options...the regex has to control for this

###9.5 Missing Values
stocks <- tibble::tibble(
  year = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr = c(1,2,3,4,2,3,4),
  return = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66)
)
stocks %>%
  tidyr::spread(year, return)

stocks %>%
  tidyr::spread(year, return) %>%
  tidyr::gather(year, return, `2015`:`2016`, na.rm = TRUE)

stocks %>%
  tidyr::complete(year, qtr)

treatment <- tibble::tribble(
  ~ person,           ~ treatment, ~ response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)

###9.5 exercises

##1
treatment %>%
  tidyr::fill(person)

#fill is about replicating a value over NAs
#complete is about putting NAs where data is absent, which spread does as well (although implicitly)

##2
?tidyr::fill
treatment %>%
  tidyr::fill(person, .direction = "up")

#to fill from the cells above or from the cells below (from above, i.e., 'down', is the default)

###9.6 Case Study
tidyr::who

who1 <- tidyr::who %>%
  tidyr::gather(new_sp_m014:newrel_f65, key = "key",
         value = "cases",
         na.rm = TRUE
         )

who1 %>%
  dplyr::count(key) %>%
  print(n = 100)

who2 <- who1 %>%
  dplyr::mutate(key = stringr::str_replace(key, "newrel", "new_rel"))

who3 <- who2 %>%
  tidyr::separate(key, c("new", "type", "sexage"), sep = "_")

who3

who3 %>%
  dplyr::count(new)

who4 <- who3 %>%
  dplyr::select(-c(iso2, iso3, new))

who4

who5 <- who4 %>%
  tidyr::separate(sexage, c("sex", "age"), sep = 1)

who5

tidyr::who %>%
  tidyr::gather(new_sp_m014:newrel_f65, key = "key",
                value = "cases",
                na.rm = TRUE
                ) %>%
  dplyr::mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>%
  tidyr::separate(key, c("new", "type", "sexage"), sep = "_") %>%
  dplyr::select(-c(iso2, iso3, new)) %>%
  tidyr::separate(sexage, c("sex", "age"), sep = 1)

###9.6 Exercises
##1
#na.rm = true makes sense, as it removes data that is explicitly not present
#it could be useful to keep the data if we wanted to analyze what was missing
#this dataset appears to explicitly write out NA for every missing observation -- check by counting number of years per country?
#we don't know if countries are missing unless we get a list of countries to compare to

tidyr::who %>%
  dplyr::group_by(country) %>%
  dplyr::tally() %>%
  print(n = 1000)

#the data is only showing less than 34 years for a small number of countries...quick look verifies that they were not countries for all of the years covered...

##2
tidyr::who %>%
  tidyr::gather(new_sp_m014:newrel_f65, key = "key",
                value = "cases",
                na.rm = TRUE
  ) %>%
  tidyr::separate(key, c("new", "type", "sexage"), sep = "_") %>%
  dplyr::select(-c(iso2, iso3, new)) %>%
  tidyr::separate(sexage, c("sex", "age"), sep = 1)

#it looks like the first separate doesn't work correctly, as it doesn't have the right separator

##3
tidyr::who %>%
  dplyr::select(country, iso2, iso3) %>%
  dplyr::distinct() %>%
  dplyr::group_by(country) %>%
  dplyr::tally() %>%
  dplyr::filter(n > 1)

#none contain more than 1 combination

##4
who1 <-
  tidyr::who %>%
  tidyr::gather(new_sp_m014:newrel_f65, key = "key",
                value = "cases",
                na.rm = TRUE
  ) %>%
  dplyr::mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>%
  tidyr::separate(key, c("new", "type", "sexage"), sep = "_") %>%
  dplyr::select(-c(iso2, iso3, new)) %>%
  tidyr::separate(sexage, c("sex", "age"), sep = 1)

who1 %>%
  dplyr::group_by(country, year, sex) %>%
  dplyr::summarise(cases = sum(cases)) %>%
  ggplot2::ggplot(ggplot2::aes(year, country)) +
  ggplot2::geom_point(ggplot2::aes(size = cases, color = sex))

who1 %>%
  dplyr::group_by(country, year, sex) %>%
  dplyr::summarise(cases = sum(cases)) %>%
  ggplot2::ggplot(ggplot2::aes(year)) +
  ggplot2::geom_bar(ggplot2::aes(color = sex))

#didn't use the country aspect, but could have. I think this is really a number of visuals, not 3 variables (including one with 200 + values) + 1 obversation in 1 chart
