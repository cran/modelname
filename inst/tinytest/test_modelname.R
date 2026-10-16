# Port of modelname_test.go and example_test.go from the Go package.

case <- function(input, vendor = "", family = "", version = "", size = "",
                 snapshot = "", date = "", tags = character()) {
  list(input = input, want = list(
    vendor = vendor, family = family, version = version, size = size,
    snapshot = snapshot, date = date, tags = tags
  ))
}

cases <- list(
  # API IDs
  case("claude-3-5-sonnet-20241022", vendor = "anthropic", family = "claude-sonnet", version = "3.5", date = "2024-10-22"),
  case("claude-sonnet-4-5", vendor = "anthropic", family = "claude-sonnet", version = "4.5"),
  case("claude-opus-4-1-20250805", vendor = "anthropic", family = "claude-opus", version = "4.1", date = "2025-08-05"),
  case("anthropic/claude-haiku-4.5", vendor = "anthropic", family = "claude-haiku", version = "4.5"),
  case("gpt-4o-2024-08-06", vendor = "openai", family = "gpt", version = "4o", date = "2024-08-06"),
  case("gpt-4.1-mini", vendor = "openai", family = "gpt-mini", version = "4.1"),
  case("gpt-4-0613", vendor = "openai", family = "gpt", version = "4", snapshot = "0613"),
  case("chatgpt-4o-latest", vendor = "openai", family = "chatgpt", version = "4o", tags = "latest"),
  case("o3-mini", vendor = "openai", family = "o3-mini"),
  case("gemini-2.0-flash-001", vendor = "google", family = "gemini-flash", version = "2.0", snapshot = "001"),
  case("gemini-2.5-pro-exp-03-25", vendor = "google", family = "gemini-pro", version = "2.5", snapshot = "03-25", tags = "exp"),
  case("x-ai/grok-4", vendor = "xai", family = "grok", version = "4"),
  case("meta-llama/llama-3.3-70b-instruct:free", vendor = "meta", family = "llama", version = "3.3", size = "70b", tags = c("free", "instruct")),
  case("mistral-large-2411", vendor = "mistral", family = "mistral-large", snapshot = "2411"),
  case("mistral-7b-instruct-v0.2", vendor = "mistral", family = "mistral", version = "0.2", size = "7b", tags = "instruct"),
  case("deepseek/deepseek-v3.2", vendor = "deepseek", family = "deepseek", version = "3.2"),
  case("deepseek-chat-v3-1", vendor = "deepseek", family = "deepseek-chat", version = "3.1"),
  case("qwen/qwen3-235b-a22b", vendor = "alibaba", family = "qwen", version = "3", size = "235b-a22b"),
  case("moonshotai/kimi-k2", vendor = "moonshot", family = "kimi", version = "k2"),
  case("glm-4-6", vendor = "zhipu", family = "glm", version = "4.6"),

  # Display names, from https://whizi.io/models/
  case("Claude Opus 4.8", vendor = "anthropic", family = "claude-opus", version = "4.8"),
  case("Claude Fable 5", vendor = "anthropic", family = "claude-fable", version = "5"),
  case("GPT-5.4 Nano", vendor = "openai", family = "gpt-nano", version = "5.4"),
  case("GPT-6.1 Sol", vendor = "openai", family = "gpt-sol", version = "6.1"),
  case("GPT Chat Latest", vendor = "openai", family = "gpt-chat", tags = "latest"),
  case("Gemini 3.1 Pro Preview", vendor = "google", family = "gemini-pro", version = "3.1", tags = "preview"),
  case("Gemini 3.5 Flash Lite", vendor = "google", family = "gemini-flash-lite", version = "3.5"),
  case("Grok Build 0.1", vendor = "xai", family = "grok-build", version = "0.1"),
  case("DeepSeek V4 Pro 0813", vendor = "deepseek", family = "deepseek-pro", version = "4", snapshot = "0813"),
  case("DeepSeek V4.1 Flash", vendor = "deepseek", family = "deepseek-flash", version = "4.1"),
  case("R1", vendor = "deepseek", family = "r1"),
  case("Qwen3.5 Plus 2026-04-20", vendor = "alibaba", family = "qwen-plus", version = "3.5", date = "2026-04-20"),
  case("Qwen3.6 35B A3B", vendor = "alibaba", family = "qwen", version = "3.6", size = "35b-a3b"),
  case("Qwen3.8 2.4T A95B", vendor = "alibaba", family = "qwen", version = "3.8", size = "2.4t-a95b"),
  case("Qwen3 Coder Next", vendor = "alibaba", family = "qwen-coder-next", version = "3"),
  case("Kimi K2 0711", vendor = "moonshot", family = "kimi", version = "k2", snapshot = "0711"),
  case("Kimi K2.7 Code", vendor = "moonshot", family = "kimi-code", version = "k2.7"),
  case("Kimi K2 Thinking", vendor = "moonshot", family = "kimi", version = "k2", tags = "thinking"),
  case("MiniMax M3", vendor = "minimax", family = "minimax", version = "m3"),
  case("MiMo-V2.6-Pro-UltraSpeed", vendor = "xiaomi", family = "mimo-pro-ultraspeed", version = "2.6"),
  case("Mistral Large 3 2512", vendor = "mistral", family = "mistral-large", version = "3", snapshot = "2512"),
  case("Codestral 2508", vendor = "mistral", family = "codestral", snapshot = "2508"),
  case("Llama 3.3 70B Instruct", vendor = "meta", family = "llama", version = "3.3", size = "70b", tags = "instruct"),
  case("Llama 4 Maverick", vendor = "meta", family = "llama-maverick", version = "4"),
  case("Granite 4.2 8B", vendor = "ibm", family = "granite", version = "4.2", size = "8b"),
  case("Nemotron 3 Ultra", vendor = "nvidia", family = "nemotron-ultra", version = "3"),
  case("Command A+", vendor = "cohere", family = "command-a+"),
  case("Hy4 preview", vendor = "tencent", family = "hy", version = "4", tags = "preview"),
  case("Ring-2.6-1T", vendor = "inclusionai", family = "ring", version = "2.6", size = "1t"),
  case("KAT-Coder-Pro V2.5", family = "kat-coder-pro", version = "2.5"),
  case("Nova Pro 1.0", vendor = "amazon", family = "nova-pro", version = "1.0"),
  case("Phi 4", vendor = "microsoft", family = "phi", version = "4"),
  case("Solar Pro 4", vendor = "upstage", family = "solar-pro", version = "4"),
  case("Perceptron Mk1", family = "perceptron", version = "mk1"),
  case("Inkling Small", family = "inkling-small")
)

# TestParse: one expectation per name, checking every field at once.
for (tc in cases) {
  m <- parse_model(tc$input)
  got <- list(
    vendor = m$vendor, family = m$family, version = m$version, size = m$size,
    snapshot = m$snapshot,
    date = if (is.na(m$date)) "" else format(m$date, "%Y-%m-%d"),
    tags = sort(m$tags[[1L]], method = "radix")
  )
  expect_identical(got, tc$want, info = tc$input)
}

# The same names parsed in one vectorised call give the same rows.
all_in <- vapply(cases, function(tc) tc$input, character(1L))
all_m <- parse_model(all_in)
expect_identical(nrow(all_m), length(cases))
expect_identical(all_m$id, all_in)
expect_identical(
  all_m$family,
  vapply(cases, function(tc) tc$want$family, character(1L))
)

# TestSameFamilyAcrossNamingStyles
a <- parse_model("claude-3-5-sonnet-20241022")
b <- parse_model("Claude Sonnet 4.5")
expect_identical(a$family, b$family)
expect_true(same_family("claude-3-5-sonnet-20241022", "Claude Sonnet 4.5"))
expect_true(compare_models("claude-3-5-sonnet-20241022", "Claude Sonnet 4.5") < 0L)
expect_false(same_family("claude-sonnet-4-5", "claude-opus-4-1"))

# TestCompare
older <- c(
  "gemini-2.5-flash", "gemini-3.9-flash", "kimi-k2-0711", "kimi-k2-0905",
  "claude-opus-4-1-20250805", "claude-3-5-sonnet-20240620"
)
newer <- c(
  "gemini-3.10-flash", "gemini-3.10-flash", "kimi-k2.7-code", "kimi-k3",
  "claude-opus-4-1-20250901", "claude-3-5-sonnet-20241022"
)
for (i in seq_along(older)) {
  expect_identical(compare_models(older[i], newer[i]), -1L,
                   info = paste(older[i], "<", newer[i]))
  expect_identical(compare_models(newer[i], older[i]), 1L,
                   info = paste(newer[i], ">", older[i]))
}
expect_identical(compare_models(older, newer), rep(-1L, length(older)))
expect_identical(compare_models("gpt-5", "GPT-5"), 0L,
                 info = "same model in different case should compare equal")

# TestLatest
ids <- c(
  "gpt-4o", "claude-sonnet-4-5", "claude-3-7-sonnet-20250219",
  "claude-sonnet-4-6", "claude-opus-5", "gemini-2.5-flash"
)
expect_identical(latest_model(ids, "claude-sonnet"), "claude-sonnet-4-6")
expect_true(is.na(latest_model(ids, "llama")),
            info = "found a llama that isn't there")

# ExampleParse
m <- parse_model("claude-opus-4-1-20250805")
expect_identical(
  paste(m$vendor, m$family, m$version, format(m$date, "%Y-%m-%d")),
  "anthropic claude-opus 4.1 2025-08-05"
)

# ExampleLatest
expect_identical(
  latest_model(
    c("claude-sonnet-4-5", "claude-3-7-sonnet-20250219", "claude-sonnet-4-6", "gpt-5"),
    "claude-sonnet"
  ),
  "claude-sonnet-4-6"
)

# R specific: shape, empty input, NA and bad input.
expect_identical(
  names(parse_model("gpt-5")),
  c("id", "vendor", "family", "version", "size", "date", "snapshot", "tags")
)
expect_inherits(parse_model("gpt-5")$date, "Date")
expect_identical(nrow(parse_model(character())), 0L)
expect_identical(compare_models(character(), "gpt-5"), integer())
na_row <- parse_model(c("gpt-5", NA))
expect_identical(na_row$family, c("gpt", NA))
expect_identical(compare_models(NA_character_, "gpt-5"), NA_integer_)
expect_identical(parse_model(factor("gpt-4.1-mini"))$family, "gpt-mini")
expect_error(parse_model(42), "character")
expect_error(latest_model(ids, c("a", "b")), "single string")
