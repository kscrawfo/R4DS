library(tidyverse)

tibble::as_tibble(iris)

tibble::tibble(
  x = 1:5,
  y = 1,
  z = x^2 + y
)

tb <- tibble::tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number"
)

tb

tibble::tribble(
  ~x, ~y, ~z,
  "a", 2, 3.6,
  "b", 1, 8.5
)

tibble::tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = stats::runif(1e3),
  e = base::sample(letters, 1e3, replace = TRUE)
)

nycflights13::flights %>%
  base::print(n = 8, width = 86)
##width is a measure of actual pixel width (or something) rather than a measure of the number of columns...weird
##it the width of the number of characters (unicode), for each column its the greatest(column name, column type, largest column value)

base::options(tibble.print_max = 100, tibble.print_min = 15)
##this sets the print options locally (just in this session?) for tibbles...

nycflights13::flights %>%
  base::print()

nycflights13::flights %>%
  view()

?view()


df <- tibble::tibble(
  x = stats::runif(5),
  y = stats::rnorm(5)
)

print(df)

df$x #get column x
df[["x"]] #get column x
df[[1]] #get the first column
df[[1,1]] #get the first element (row) in the first column (x)
df[[1, "x"]] #get the first element (row) in column x
df[[1,]] ##get the first row

df %>%
  .$x

df %>%
  .[["x"]]

base::class(base::as.data.frame(tb))

###8.5 Exercises
##1
base::print(mtcars)
base::print(tibble::as_tibble(mtcars))
#you can know its a tibble because R tells you with '# A tibble: 32 x 11'

##2
df <- base::data.frame(abc = 1, xyz = "a")
df$x
df[,"xyz"]
df[,c("abc", "xyz")]

df2 <- tibble::tibble(abc = 1, xyz = "a")
df2$x
df2[,"xyz"]
df2[,c("abc", "xyz")]
#when using $ with a data.frame, it looks like you can get the values as long as there is a partial match (first char match?) on the column name
#otherwise looks the same...except sometimes you get back a vecotr (df2[,"xyz"]) and sometimes you get back a data.frame(df2[,c("abc", "xyz")])

##3
#you can pass the variable into [[]] without "", as it will treat it as a variable (search for column name <var>.
#You can't do this to $...as it will treat it as a name(search for column name "var")

##4
annoying <- tibble::tibble(
  `1` = 1:10,
  `2` = `1` + 2 + stats::rnorm(length(`1`))
)

##4.1
annoying$`1`

##4.2
annoying %>%
  ggplot2::ggplot(aes(`1`, `2`)) +
  ggplot2::geom_point()

##4.3
annoying <- annoying %>%
  dplyr::mutate(`3` = `2` / `1`)

##4.4
annoying %>%
  dplyr::rename(`One` = `1`, `Two` = `2`, `Three` = `3`)

##5
?tibble::enframe
tibble::enframe(1:3)
tibble::enframe(c(a = 5, b = 7))
tibble::enframe(list(one = 1, two = 2:3, three = 4:6))
tibble::deframe(tibble::enframe(1:3))
tibble::deframe(tibble::tibble(a = 1:3))
tibble::tibble(a = 1:3)
#enframe turns a set of values into a vector in an observation (row/column location)
#this might be useful to store a vector of information in an observation
#example: you had a multi-select survey response and you wanted to store each selection as a separate object, but they are all part of the same question

##6
?options
base::print(tibble::as_tibble(nycflights13::flights), n_extra = 3)
#n_extra, which is an option for print, controls how many additional columns are printed before a '...' is printed
