#### 11 stringr

### 11.1 String basics

string1 <- "This is a string"
string2 <- 'To put a "quote" inside a string, use single quotes'

double_quote <- "\""
single_quote <- "\'"
backslash <- "\\"

base::writeLines(backslash)
base::writeLines(single_quote)
base::writeLines(double_quote)

?'"'
x <- "\u00b5"

c("one", "two", "three")

stringr::str_length(c("a","R4DS", NA))

stringr::str_c("R"," for", " data", " science")
stringr::str_c("R", "for", "data", "science", sep=" ")

x <- c("abc", NA)
stringr::str_c("|-",x,"-|")
stringr::str_c("|-",stringr::str_replace_na(x),"-|")

stringr::str_c("a", c("1","2","3","4"), c("b","c"))
# interesting how str_c joins...only works if all are multiples of eachother (can't be len = 1, 2, 3, but can be len = 1,2,4)

name <- "Kyle"
time_of_day <- Sys.time() # :)
birthday <- FALSE

stringr::str_c(
  "Good ", time_of_day, " ", name,
  if(birthday) " and Happy Birthday!",
  "."
)

######Subsetting Strings
