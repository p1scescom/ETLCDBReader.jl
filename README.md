# What is ETLCDBReader ?
ETLCDBReader.jl is a library to read binary of [ETL Character Database](http://www.yahoo.co.jp).

> “ETL Character Database” is a collection of images of about 1.2 million hand-written and machine-printed numerals, symbols, Latin alphabets and Japanese characters and compiled in 9 datasets (ETL-1 to ETL-9)

You need to sign up to use ETL Character Database.
After, you can download the dataset.
you use unziped the directory.

# Please Pull Request
I hope your pull Request.

# Support dataset
List of dataset supprted ETLCDBReader

- [] ETL1
- [] ETL2
- [] ETL3
- [] ETL4
- [] ETL5
- [] ETL6
- [] ETL7L
- [] ETL7S
- [] ETL8G
- [] ETL8B2
- [] ETL9G
- [x] ETL9B

# Heed
Now, this library use so much memory.
Before use this, You check your computer's free memory is over 6 GB.

# Usage 

```
(v1.0) pkg> add https://github.com/p1scescom/ETLCDBReader.jl
julia> using ETLCDBReader
julia> dir = "Downloads/ETL9B"
julia> ETLCDBReader.getetl9b(dir)
julia> ETLCDBReader.showterm(ans)
```
