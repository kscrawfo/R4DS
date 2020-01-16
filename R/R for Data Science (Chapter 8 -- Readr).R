library(tidyverse)

readr::read_csv("a,b,c
                1,2,3
                4,5,6")

readr::read_csv("some words
                some more words
                x,y,z
                1,2,3", skip = 2)

readr::read_csv("# comments
                x,y,z
                1,2,3", comment = "#")

readr::read_csv("$ comments
                x,y,z
                1,2,3", comment = "$") #comment doesn't need to be #...can be whatever you want

readr::read_csv("# comments
                x,y,z
                1,2,3", comment = "1")

readr::read_csv("1,2,3\n4,5,6", col_names = FALSE)

readr::read_csv("1,2,3\n4,5,6", col_names = c("X","Y","Z"))

readr::read_csv("a,b,c\n1,2,.", na = ".")

###8.1 Exercises
##1
#readr::read_delim()

##2
?readr::read_csv
?readr::read_tsv
#col_names: are they there?
#col_types: what are the types? If not spec, then will guess based on top 1000 col
#locale: specifies country / geo specifics
#na: what char == missing string?
#quoted_na: treat missing values in quotes as strings or missing?
#quote: what is the quote char (if you have it in the read file)
#trim_ws: trim whitespace?
#n_max: max # records to read
#quess_max: max # records to use to guess column type
#progress: display progress bar? will only show if >5s
#skip_empty_rows: read blank rows or not?

##3
?readr::read_fwf
#file: what is the file?
#col_positions: spec which way to read in the file based on col positions and different functions (fwf_empty, fwf_widths, fwf_positions, fwf_cols)

##4
readr::read_delim("x,y\n1,'a,b'",",",quote = "'")
#quote = "'"

##5
readr::read_csv("a,b\n1,2,3\n4,5,6")
#missing a third col name...so that data isn't read

readr::read_csv("a,b,c\n1,2\n1,2,3,4")
#4th element of second line doesnt have a column to read into

readr::read_csv("a,b\n\"1")
#not sure - the '\"' doesn't do anything...?

readr::read_csv("a,b\n1,2\na,b")
#not sure what col type should be?

readr::read_csv("a;b\n1;3")
#need to use read_csv2 to read semi-colon separated files

###Parsing a vector
utils::str(readr::parse_logical(c("TRUE","FALSE","NA")))
utils::str(readr::parse_integer(c("1","2","3")))

utils::str(readr::parse_integer(c("1","231",".","456"), na = "."))

x <- readr::parse_integer(c("123","456","abc","123.45"))
readr::problems(x)
x

readr::parse_double("1.23")
readr::parse_double("1,23",locale = locale(decimal_mark = ","))

readr::parse_number("$100")
readr::parse_number("55%")
readr::parse_number("I owe him $55.12")

readr::parse_number("$123,456,789")
readr::parse_number("123.456.789")
readr::parse_number("123.456.789",
                    locale = locale(grouping_mark = ".")
                    )
readr::parse_number("123'456'789",
                    locale = locale(grouping_mark = "'"))

base::charToRaw("Crawford")
base::charToRaw("Rr")

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

readr::parse_character(x1, locale = locale(encoding = "Latin1"))
readr::parse_character(x2, locale = locale(encoding = "Shift-JIS"))

readr::guess_encoding(base::charToRaw(x1))
readr::guess_encoding(base::charToRaw(x2))

fruit <- c("apple", "banana")
readr::parse_factor(c("apple","banana","carrot"), levels = fruit)

readr::parse_datetime("2010-10-01T2010")
readr::parse_datetime("20101010")

readr::parse_date("2010-10-01")
readr::parse_date("2010-10/01")

readr::parse_time("20:10:01")

readr::parse_date("01/02/03", "%m/%d/%y")

###8.2 Exercises
##1
?readr::locale

readr::default_locale()
readr::locale("fr")
#each argument could be important depending on what you are doing...

##2
#decimal_mark == grouping_mark
readr::parse_double("1,23.45",locale = locale(decimal_mark = ",", grouping_mark = ","))
#error

#decidmal_mark = ,
readr::parse_double("1,23.45",locale = locale(decimal_mark = ","))
#warning because it parsed off the '.45' because it was behind the decimal point ...which was ','
#result is NA

#grouping_mark = .
readr::parse_double("1,23.45",locale = locale(grouping_mark = "."))
#warning because the decimal mark was switched to '.', so the grouping mark of '.' is just extra char

##3
#I have no idea...

##4
new_locale <- locale(
date_format = "%d,%m,%y"
)

readr::parse_date("01,02,03", locale = new_locale)

##5
#read_csv takes comma separated
#read_csv2 takes semi-colon separated

##6
#Europe == ISO-8859-1, ISO-8859
#Asia == Traditional Chinese: Big5, Simplified Chinese: GB18030, Japanese: Shift-JIS, EUC-JP, Russian: KOI8-R

##7
readr::parse_date("January 1, 2016", "%B %d, %Y")
readr::parse_date("2015-Mar-07", "%Y-%b-%d")
readr::parse_date("06-Jun-2017", "%d-%b-%Y")
readr::parse_date(c("August 19 (2015)","July 1 (2015)"), "%B %d (%Y)")
readr::parse_date("12/30/14", "%m/%d/%y")
readr::parse_time("1705","%H%M")
readr::parse_time("11:15:10.12 PM", "%I:%M:%OS %p")

###8.4 Parsing a file
readr::guess_parser("2010-10-01")
readr::guess_parser("15:01")
readr::guess_parser(c("TRUE","FALSE"))
readr::guess_parser(c("1","2","167","12.1"))
readr::guess_parser(c("1","2","3"))
readr::guess_parser(c("1","25","500","1100","123456789"))
readr::guess_parser("12,345,678")
utils::str(readr::parse_guess("2010-10-01"))

challenge <- readr::read_csv(readr::readr_example("challenge.csv"))
readr::problems(challenge)

challenge <- readr::read_csv(
  readr::readr_example("challenge.csv"),
  col_types = readr::cols(
    x = readr::col_double(),
    y = readr::col_date()
  )
)

utils::tail(challenge)

challenge2 <- readr::read_csv(readr::readr_example("challenge.csv"), guess_max = 1001)

challenge2 <- readr::read_csv(readr::readr_example("challenge.csv"),
                              col_types = readr::cols(.default = readr::col_character())
)

readr::type_convert(challenge2)

readr::write_csv(challenge, "challenge.csv")
readr::read_csv("challenge.csv") #loses col types

readr::write_rds(challenge, "challenge.rds")
readr::read_rds("challenge.rds") #r-specific data format

feather::write_feather(challenge, "challenge.feather")
feather::read_feather("challenge.feather") #general data format

#haven package to read SPSS, Stat, SAS
#readxl to get xls and xlsx
#DBI w/ a specific backend package to run SQL

