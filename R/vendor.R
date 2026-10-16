# First word of a model name, and who makes it.
# Not complete. Open an issue if yours is missing.
vendors <- c(
  aya = "cohere",
  chatgpt = "openai",
  claude = "anthropic",
  codestral = "mistral",
  codex = "openai",
  command = "cohere",
  deepseek = "deepseek",
  devstral = "mistral",
  ernie = "baidu",
  gemini = "google",
  gemma = "google",
  glm = "zhipu",
  gpt = "openai",
  granite = "ibm",
  grok = "xai",
  hunyuan = "tencent",
  hy = "tencent",
  jamba = "ai21",
  kimi = "moonshot",
  ling = "inclusionai",
  llama = "meta",
  longcat = "meituan",
  magistral = "mistral",
  mercury = "inception",
  mimo = "xiaomi",
  minimax = "minimax",
  ministral = "mistral",
  mistral = "mistral",
  mixtral = "mistral",
  muse = "meta",
  nemotron = "nvidia",
  nova = "amazon",
  o1 = "openai",
  o3 = "openai",
  o4 = "openai",
  phi = "microsoft",
  pixtral = "mistral",
  qwen = "alibaba",
  qwq = "alibaba",
  r1 = "deepseek",
  ring = "inclusionai",
  seed = "bytedance",
  solar = "upstage",
  sonar = "perplexity",
  step = "stepfun"
)

# OpenRouter and friends put the vendor in front, spelled their own way.
# Anything not listed here is used as is.
prefixes <- c(
  "ibm-granite" = "ibm",
  "meta-llama" = "meta",
  "mistralai" = "mistral",
  "moonshotai" = "moonshot",
  "qwen" = "alibaba",
  "x-ai" = "xai",
  "z-ai" = "zhipu"
)

vendor_for <- function(prefix, words) {
  if (nzchar(prefix)) {
    v <- prefixes[prefix]
    if (!is.na(v)) {
      return(unname(v))
    }
    return(prefix)
  }
  if (length(words) > 0L) {
    v <- vendors[words[1L]]
    if (!is.na(v)) {
      return(unname(v))
    }
  }
  ""
}
