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

## subsetting strings
x <- c("Apple", "Banana", "Pear")
stringr::str_sub(x, 1, 3)

stringr::str_sub(x, -3, -1)

stringr::str_sub("a", 1, 3)

# this only does string to lower for the first element of the substring
stringr::str_sub(x, 1, 1) <- stringr::str_to_lower(stringr::str_sub(x,1,1))

# can do the same for the middle elements...but to upper

stringr::str_sub(x, 2, 3) <- stringr::str_to_upper(stringr::str_sub(x,2,3))
(x)

## locale
x <- c("apple","eggplan", "banana")

stringr::str_sort(x, locale = "en")
stringr::str_sort(x, locale = "haw")

### 11.1 exercises
## 1
# paste0 & paste are both string concats, but paste0 adds no space between the strings (sep = "")
# stringr::str_c is the comparable, with the default of sep = ""

## 2
# sep = what to provide between strings that are being concatenated within a vector
# collapse = collapses all vector elements into a single string
# for a non-vector, collapse will do nothing?
y <- c("1","2","3")
stringr::str_c(x, y, sep = ",")
stringr::str_c(x, y, collapse = ",")

## 3
x <- "123456"
x <- "1234567"
stringr::str_sub(x, (stringr::str_length(x)+1)/2, (stringr::str_length(x)+1)/2)
# the way i set it up, i'm pulling the middle character, or 1 to the left if its an even number

## 4
?stringr::str_wrap

x <- stringr::str_c((1:100), collapse = " ")
stringr::str_wrap(x, width = 50, indent = 10)
# this creates a line break every so many lines (in this case 50), so that you can read a really long string

## 5
# str_trim removes whitespace around a string
# str_pad is the opposite

## 6
vec_cat <- function(x) {
  dplyr::case_when(
    length(x) == 0 ~ "",
    length(x) == 1 ~ x[1],
    length(x) == 2 ~ stringr::str_c(x[1], " and ", x[2]),
    length(x) > 2 ~ stringr::str_c(stringr::str_c(x[1:length(x) -
                                                      1], collapse = ", "), ", and ", x[length(x)])
  )
}

x <- c("one", "two", "three", "monkey")
vec_cat(x)

### 11.2 -- Matching Patterns with Regular Expressions
x <- c("apple", "banana", "pear")
stringr::str_view(x, "an")

# I give up on explicit references to packages...I'm OK with loading the library and just using the package...
library(stringr)

str_view(x, ".a.")

writeLines("\\.")

str_view(c("abc","a.c","bef"), "a\\.c")

x <- "a\\b"
writeLines(x)
str_view(x, "\\\\")

### 11.2 exercises
## 1
# "\" won't even run...because it will treat the " after it as the thing being escaped
# "\\" is a string escape for a \...so it will only try to match \ in the regexp
# "\\\" won't run, because the third \ is escaping the second "...

## 2
writeLines("\\\"\\\'\\\\")
str_view("a\"\'\\","\\\"\\\'\\\\")

## 3
# this will match ._._._
str_view("a.b.c.d","\\..\\..\\..")

### 11.3 anchors
x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$") # putting the $ in front of the a does nothing...because the end of the string can't be directly before a letter...

x <- c("apple pie", "apple", "apple cake")
str_view(x, "^apple$")

### 11.3 exercises
## 1
str_view("a$^$","\\$\\^\\$")

## 2
length(words)
str_view(words, "^a", match = TRUE)
str_view(words, "e$", match = TRUE)
str_view(words, "^...$", match = TRUE)
str_view(words, ".......", match = TRUE)

### 11.4 character classes and alternatives
