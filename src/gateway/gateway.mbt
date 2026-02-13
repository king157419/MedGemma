pub struct MedGemmaConfig {
  api_url : String
  model : String
  timeout_ms : Int
}

pub fn default_config() -> MedGemmaConfig {
  MedGemmaConfig::{
    api_url: "http://localhost:8000/v1/chat/completions",
    model: "medgemma-4b",
    timeout_ms: 30000,
  }
}
