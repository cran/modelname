# modelname

Parse AI model names into something you can sort.

This is the R port of my Go package
[modelname](https://github.com/BoNour/modelname). Same rules, same test cases,
plain base R with no dependencies.

```r
library(modelname)

m <- parse_model("claude-opus-4-1-20250805")
m[, c("vendor", "family", "version", "date")]
#>      vendor      family version       date
#> 1 anthropic claude-opus     4.1 2025-08-05
```

It reads API IDs (`gpt-4.1-mini`, `meta-llama/llama-3.3-70b-instruct:free`)
and display names (`Gemini 3.1 Pro Preview`) the same way. Old and new
Claude names land in the same family, so `claude-3-5-sonnet` and
`claude-sonnet-4-5` can be compared.

```r
parse_model(c("gpt-4.1-mini", "meta-llama/llama-3.3-70b-instruct:free",
              "Gemini 3.1 Pro Preview"))[, c("vendor", "family", "version", "size", "tags")]
#>   vendor     family version size           tags
#> 1 openai   gpt-mini     4.1
#> 2   meta      llama     3.3  70b free, instruct
#> 3 google gemini-pro     3.1             preview
```

## Install

```r
install.packages("modelname")
```

## Newest in a family

```r
ids <- c("claude-sonnet-4-5", "claude-3-7-sonnet-20250219", "claude-sonnet-4-6")
latest_model(ids, "claude-sonnet")
#> [1] "claude-sonnet-4-6"
```

`compare_models(a, b)` gives you -1, 0 or 1 if you want the ordering, and
`same_family(a, b)` tells you if two names are the same line of models.

## What it won't do

It doesn't know about every model and it doesn't call any API. It's string
parsing. If a name is weird enough it'll put everything in `family` and leave
`version` empty, which is usually the right call.

Most of the test cases are real names from [whizi.io/models](https://whizi.io/models/).
If you find one it gets wrong, open an issue with the name.

## License

MIT
