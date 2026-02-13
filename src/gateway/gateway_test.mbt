test "default_config creates valid config" {
  let config = @gateway.default_config()
  inspect(config.model, content="medgemma-4b")
  inspect(config.timeout_ms.to_string(), content="30000")
}

test "MedGemmaConfig::with_url updates url" {
  let config = @gateway.default_config()
    .with_url("http://api.example.com/v1/chat")
  inspect(config.api_url, content="http://api.example.com/v1/chat")
}

test "MedGemmaConfig::with_model updates model" {
  let config = @gateway.default_config()
    .with_model("medgemma-27b")
  inspect(config.model, content="medgemma-27b")
}

test "build_request_prompt includes report content" {
  let prompt = @gateway.build_request_prompt("血红蛋白 140 g/L", "blood_routine")
  inspect(prompt.contains("血红蛋白"), content="true")
  inspect(prompt.contains("血常规"), content="true")
}

test "build_request_prompt includes liver function instruction" {
  let prompt = @gateway.build_request_prompt("ALT 35 U/L", "liver_function")
  inspect(prompt.contains("肝功能"), content="true")
}

test "build_request_prompt includes disclaimer" {
  let prompt = @gateway.build_request_prompt("test", "general")
  inspect(prompt.contains("仅供参考"), content="true")
}

test "APIRequest::post creates POST request" {
  let req = @gateway.APIRequest::post("http://api.example.com", "{}")
  inspect(req.method, content="POST")
  inspect(req.endpoint, content="http://api.example.com")
}

test "APIRequest::with_header adds header" {
  let req = @gateway.APIRequest::post("http://api.example.com", "{}")
    .with_header("X-Custom", "value")
  let header_val = req.headers.get("X-Custom")
  inspect(header_val, content="Some(\"value\")")
}

test "APIRequest::with_auth adds bearer token" {
  let req = @gateway.APIRequest::post("http://api.example.com", "{}")
    .with_auth("my-token")
  let auth_header = req.headers.get("Authorization")
  inspect(auth_header, content="Some(\"Bearer my-token\")")
}

test "AnalysisOptions::default creates valid options" {
  let opts = @gateway.AnalysisOptions::default()
  inspect(opts.include_recommendations.to_string(), content="true")
  inspect(opts.language, content="zh-CN")
}

test "AnalysisOptions::detailed sets detail level" {
  let opts = @gateway.AnalysisOptions::default().detailed()
  inspect(opts.detail_level, content="detailed")
}

test "AnalysisOptions::brief sets brief level" {
  let opts = @gateway.AnalysisOptions::default().brief()
  inspect(opts.detail_level, content="brief")
}

test "AnalysisOptions::in_language sets language" {
  let opts = @gateway.AnalysisOptions::default().in_language("en-US")
  inspect(opts.language, content="en-US")
}
