pub struct MedGemmaConfig {
  api_url : String
  model : String
  timeout_ms : Int
  enabled : Bool
}

pub fn default_config() -> MedGemmaConfig {
  MedGemmaConfig::{
    api_url: "http://localhost:8000/v1/chat/completions",
    model: "medgemma-4b",
    timeout_ms: 30000,
    enabled: false,
  }
}

pub struct AIAnalysisRequest {
  report_content : String
  report_type : String
  language : String
}

pub fn AIAnalysisRequest::new(content : String, report_type : String) -> AIAnalysisRequest {
  AIAnalysisRequest::{
    report_content: content,
    report_type,
    language: "zh",
  }
}

pub struct AIAnalysisResponse {
  success : Bool
  analysis : String
  recommendations : Array[String]
  warnings : Array[String]
  confidence : Double
  error_message : String
}

pub fn AIAnalysisResponse::success(analysis : String) -> AIAnalysisResponse {
  AIAnalysisResponse::{
    success: true,
    analysis,
    recommendations: [],
    warnings: [],
    confidence: 0.85,
    error_message: "",
  }
}

pub fn AIAnalysisResponse::error(msg : String) -> AIAnalysisResponse {
  AIAnalysisResponse::{
    success: false,
    analysis: "",
    recommendations: [],
    warnings: [],
    confidence: 0.0,
    error_message: msg,
  }
}

pub fn AIAnalysisResponse::with_recommendations(self : AIAnalysisResponse, recs : Array[String]) -> AIAnalysisResponse {
  { ..self, recommendations: recs }
}

pub fn AIAnalysisResponse::with_warnings(self : AIAnalysisResponse, warns : Array[String]) -> AIAnalysisResponse {
  { ..self, warnings: warns }
}

pub fn AIAnalysisResponse::with_confidence(self : AIAnalysisResponse, conf : Double) -> AIAnalysisResponse {
  { ..self, confidence: conf }
}

pub fn is_ai_available() -> Bool {
  false
}

pub fn get_ai_status() -> String {
  "AI服务暂不可用 (Windows不支持异步网络库，需要Linux/macOS环境)"
}
