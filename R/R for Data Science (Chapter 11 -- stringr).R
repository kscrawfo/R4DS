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
<<<<<<< HEAD
#a
str_view(words, "^a", match = TRUE)
#b
str_view(words, "e$", match = TRUE)
#c
str_view(words, "^...$", match = TRUE)
#d
str_view(words, ".......", match = TRUE)

### 11.4 character classes and alternatives
str_view(c("grey", "gray"), "gr(e|a)y")

### 11.4 exercises
## 1
#a
str_view(words, "^(a|e|i|o|u)", match = TRUE)
str_view(words, "^[aeiou]", match = TRUE)
#b
str_view(words, "^[^aeiou]+$", match = TRUE)
#c
str_view(words, "ed$", match = TRUE)
str_view(words, "[^e]ed$", match = TRUE)
#d
str_view(words, "(ing|ize)$", match = TRUE)

## 2
# so this isn't a rule as written...you need the rest of the rule!
str_view(words, "ei", match = TRUE)

# we could verify it this way...which should come out with no matches...
str_view(words, "ei|cie", match = TRUE)

## 3
str_view(words, "q[^u]", match = TRUE)
# ...yes, at least in this data set
str_view(words, "q", match = TRUE)

## 4
# there should be a locale specific way to write this...but i don't know exactly how
# trying to go after individual patterns seems unreasonable
str_view(words, "ou", match = TRUE)

## 5
str_view("(123) 456-7890", "\\(\\d\\d\\d\\)\\s\\d\\d\\d-\\d\\d\\d\\d")

### 11.5 repetition
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC")
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, "CC*")
str_view(x, "CLX+")
str_view(x, "C+L?X+V")
str_view(x, "C{3}")
str_view(x, "C{1,}")
str_view(x, "C{1,2}")
str_view(x, "C{1,2}?")
str_view(x, "C[LX]+?")

### 11.5 exercises
## 1
# ? = {0,1}
# + = {1,}
# * = {0,}

## 2
# a
# ^.*$ = string with at least 0 characters

# b
# "\\{.+\\}" = string with at least 1 character between curly braces

# c
# \d{4}-\d{2}-\d{2} = string with 4 digits followed by 2 digits followed by 2 digits

# d
# "\\\\{4}" = string with 4 backslashes

## 3
# a
# ^[^aeiou]{3}
str_view(words, "^[^aeiou]{3}", match = TRUE)

# b
# [a|e|i|o|u]{3}
str_view(words, "[a|e|i|o|u]{3}", match = TRUE)

# c
# ([a|e|i|o|u]^[a|e|i|o|u]){2}
str_view(words, "([aeiou][^aeiou]){2}", match = TRUE)

## 4
str_view("B", ".*M?O.*")
# I'm stuck on the concept of the capturing group for regex...wtf does that mean? Need to find a good explanation / reference...or skip it

### 11.6 Grouping and Backreferences
str_view(fruit, "(..)\\1", match = TRUE)

### 11.6 exercises
## 1
# a: (.)\1\1
# didn't escape the \1...so it will find any char followed by the \1 char twice
# if did escape "(.)\\1\\1" then it would find 3 char in a row

# b: (.)(.)\\2\\1
# a pair of char followed by the same pair in reverse order

# c: (..)\1
# didn't escape the \1, so it will match any 2 char followed by a \1 char
# id did escape it "(..)\\1" then it would be any two char followed by the same 2 char

# d: (.).\\1.\\1
# any char a, any char b, any char a, any char c, any char a

# e: "(.)(.)(.).*\\3\\2\\1"
# any char a, any char b, any char c, then any char d (at least 0 times), then char c, char b, char a

## 2
# a
"^(.).*\\1$"
str_view(words, "^(.).*\\1$", match = TRUE)

# b
"(..).*\\1"
str_view(words, "(..).*\\1", match = TRUE)

# c
"(.).*\\1.*\\1"
str_view(words, "(.).*\\1.*\\1", match = TRUE)

### 11.7 Tools
x <- c("apple", "banana", "pear")
str_detect(x, "e")

sum(str_detect(words, "t$"))

mean(str_detect(words, "^[aeiou]"))

no_vowels_1 <-!str_detect(words, "[aeiou]")

no_vowels_2 <- str_detect(words, "^[^aeiou]+$")

identical(no_vowels_1, no_vowels_2)

str_subset(words, "x$")

df <- tibble::tibble(
  word = words,
  i = seq_along(word)
)

df %>%
  dplyr::filter(str_detect(words, "x$"))

str_count(x, "a")

df %>%
  dplyr::mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )

str_count("abababa", "aba")
str_view_all("abababa", "aba")

### 11.7 exercises
## 1
# a
df %>%
  dplyr::filter(str_detect(words, "^x|x$"))

df %>%
  dplyr::filter(str_detect(words, "^x") | str_detect(words, "x$"))

# b
df %>%
  dplyr::filter(str_detect(words, "^[aeiou].*[^aeiou]$"))

df %>%
  dplyr::filter(str_detect(words, "^[aeiou]") & str_detect(words, "[^aeiou]$"))

# c
df %>%
  dplyr::filter(str_detect(words, "a") &
                  str_detect(words, "e") &
                  str_detect(words, "i") &
                  str_detect(words, "o") &
                  str_detect(words, "u"))

# d
df <- df %>%
  dplyr::mutate(vowels = str_count(words, "[aeiou]"),
                prop = vowels / str_count(words, ".")
  )

df %>%
  dplyr::arrange(desc(vowels))

df %>%
  dplyr::arrange(desc(prop))

### 11.8 Extract Matches
length(sentences)

head(sentences)

colors <- c(
  "red", "orange", "yellow", "green", "blue", "purple"
)

color_match <- str_c(colors, collapse = "|")
color_match

has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)
head(matches)

more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match)

str_extract(more, color_match)

str_extract_all(more, color_match)

str_extract_all(more, color_match, simplify = TRUE)

### 11.7 exercises
## 1
color_match <- str_c("\\b(", color_match, ")\\b")
color_match
more <- sentences[str_count(sentences, color_match) > 1]
more

## 2
# a
str_extract(sentences, "[A-ZAa-z]+") %>%
  head()

# b
str_extract_all(sentences, "\\b[^\\s]+ing\\b", simplify = TRUE)

# c
# stupid ask - what about fish? too many confusions in english...there are surely some resources for doing this...

### 11.9 Grouped Matches
noun <- "(a|the) ([^ ]+)"
has_noun <- sentences %>%
  str_subset(noun) %>%
  head(20)

has_noun %>%
  str_extract(noun)

has_noun %>%
  str_match(noun)

tidyr::tibble(sentence = sentences) %>%
  tidyr::extract(sentence, c("article", "noun"), "(a|the) ([^ ]+)",
                 remove = FALSE)

### 11.8 Exercises
## 1
number_words <- c("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")
number_words <- str_c(number_words, collapse = "|")
number_words <- str_c("(",number_words, ") ([^ ]+)")
str_match(sentences, number_words)

## 2
str_match(sentences, "([^ ]+)'([^ ]+)")

### 11.9 Replacing Matches
str_replace(x, "[aeiou]", "-")
str_replace_all(x, "[aeiou]", "-")

x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

sentences %>%
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2")

### 11.9 exercises
## 1
writeLines("//")
str_replace_all("/a/b/c", "/", "\\\\")

## 2
?str_to_lower
# create a replacement vector
replacements <- c("A" = "a", "B" = "b") #...
# replace matches to the vector
str_replace_all("AAABBBCCCdddeee", pattern = replacements)

## 3
swapped <- str_replace_all(words, "^([A-Za-z])(.*)([A-Za-z])$", "\\3\\2\\1")
head(swapped)
intersect(words,swapped)

### 11.10 Splitting
sentences %>%
  head(5) %>%
  str_split(" ")

"a|b|c|d" %>%
  str_split("\\|") %>%
  .[[1]]

sentences %>%
  head(5) %>%
  str_split(" ", simplify = TRUE)

fields <- c("Name: Kyle", "Country: USA", "Age: 33")
fields %>%
  str_split(": ", n = 2, simplify = TRUE)

x <-  "This is a sentence. This is another sentence."
x %>%
  str_view_all(boundary("word"))

str_split(x, " ")[[1]]

str_split(x, boundary("word"))[[1]]

### 11.10 exercises
## 1
x <- "apples, pear, and bananas"
str_split(x, boundary("word"))[[1]]

## 2
# splitting by word boundary is better than by " " because " " will give you punctuation with the words...

## 3
x <- ""
str_split(x, " ")

# it isn't split into anything...it just is an empty string

### 11.11 Other Types of Patterns

str_view(fruit, "nana")
str_view(fruit, regex("nana"))

bananas <- c("Bananas", "BANANAS", "bAnAnAs")
str_view(bananas, regex("bananas", ignore_case = TRUE))

x <- "Line1\nLine 2\nLine3"
str_extract_all(x, "^Line")[[1]]
str_extract_all(x, regex("^Line",multiline = TRUE))[[1]]

phone <- regex("
               \\(?     # optional opening parens
               (\\d{3}) # area code
               [)- ]?   # optional closing parens, dash, or space
               (\\d{3}) # three prefix
               [ -]?    # optional space or dash
               (\\d{4}) #last 4 numbers
               #...
               ", comments = TRUE)

str_match("123-456-7890", phone)

a1 <- "\u00e1"
a2 <- "a\u0301"

str_detect(a1, fixed(a2))
str_detect(a1, coll(a2))

stringi::stri_locale_info()

x <- "this is a sentence."
str_view_all(x, boundary("word"))

str_extract_all(x, boundary("word"))

### 11.11 exercises
## 1
x <- "this is a \\ string"
f_slash <- "\\"

str_detect(x, fixed(f_slash))
str_detect(x, regex("\\\\"))

## 2
words <- tibble::tibble(word = unlist(str_extract_all(sentences, boundary("word"))))

words %>%
  dplyr::mutate(word = str_to_lower(word)) %>%
  dplyr::count(word) %>%
  dplyr::arrange(desc(n)) %>%
  head(5)

apropos("replace") # find me everything in the global enviro with "replace" in it
apropos("words")

dir(pattern = "\\.csv$")

### 11.12 exercises
## 1
# a
library(stringi)
s_list <- unlist(ls("package:stringi"))
str_subset(s_list, ".*count.*")

?stri_count
?stri_count_words
# stri_count_words seems like the right function

# b
str_subset(s_list, ".*duplicate.*")
?stri_duplicated
# stri_duplicated

# c
str_subset(s_list, ".*rand.*")
?stri_rand_strings

# stri_rand_strings

## 2
?stri_sort()
# opts_collator = stri_opts_collator(locale = _____)
