pub enum ReportFormat {
  Text
  Image
  PDF
}

pub struct Report {
  format : ReportFormat
  content : String
  metadata : Map<String, String>
  source_file : String
  created_at : String
}

pub fn Report::new(format : ReportFormat, content : String) -> Report {
  Report::{
    format,
    content,
    metadata: Map::new(),
    source_file: "",
    created_at: ""
  }
}

pub fn Report::with_metadata(self : Report, key : String, value : String) -> Report {
  let mut new_metadata = self.metadata
  new_metadata.set(key, value)
  { ..self, metadata: new_metadata }
}

pub fn Report::with_source(self : Report, source : String) -> Report {
  { ..self, source_file: source }
}

pub struct AnalysisResult {
  summary : String
  details : Array<DetailItem>
  recommendations : Array<String>
  warnings : Array<String>
  confidence : Double
}

pub fn AnalysisResult::new(summary : String) -> AnalysisResult {
  AnalysisResult::{
    summary,
    details: [],
    recommendations: [],
    warnings: [],
    confidence: 0.0
  }
}

pub fn AnalysisResult::add_detail(self : AnalysisResult, item : DetailItem) -> AnalysisResult {
  let mut new_details = self.details
  new_details.push(item)
  { ..self, details: new_details }
}

pub fn AnalysisResult::add_recommendation(self : AnalysisResult, rec : String) -> AnalysisResult {
  let mut new_rec = self.recommendations
  new_rec.push(rec)
  { ..self, recommendations: new_rec }
}

pub fn AnalysisResult::add_warning(self : AnalysisResult, warning : String) -> AnalysisResult {
  let mut new_warnings = self.warnings
  new_warnings.push(warning)
  { ..self, warnings: new_warnings }
}

pub fn AnalysisResult::has_warnings(self : AnalysisResult) -> Bool {
  self.warnings.length() > 0
}

pub struct DetailItem {
  item_name : String
  value : String
  unit : String
  normal_range : String
  status : ItemStatus
  explanation : String
}

pub fn DetailItem::new(name : String, value : String, unit : String) -> DetailItem {
  DetailItem::{
    item_name: name,
    value,
    unit,
    normal_range: "",
    status: ItemStatus::Unknown,
    explanation: ""
  }
}

pub fn DetailItem::with_range(self : DetailItem, range : String) -> DetailItem {
  { ..self, normal_range: range }
}

pub fn DetailItem::with_status(self : DetailItem, status : ItemStatus) -> DetailItem {
  { ..self, status }
}

pub fn DetailItem::with_explanation(self : DetailItem, explanation : String) -> DetailItem {
  { ..self, explanation }
}

pub fn DetailItem::is_normal(self : DetailItem) -> Bool {
  match self.status {
    ItemStatus::Normal => true
    _ => false
  }
}

pub fn DetailItem::is_abnormal(self : DetailItem) -> Bool {
  match self.status {
    ItemStatus::Normal => false
    ItemStatus::Unknown => false
    _ => true
  }
}

pub enum ItemStatus {
  Normal
  High
  Low
  Abnormal
  Unknown
}

pub fn ItemStatus::to_string(self : ItemStatus) -> String {
  match self {
    ItemStatus::Normal => "正常"
    ItemStatus::High => "偏高"
    ItemStatus::Low => "偏低"
    ItemStatus::Abnormal => "异常"
    ItemStatus::Unknown => "未知"
  }
}

pub fn ItemStatus::from_string(s : String) -> ItemStatus {
  let lower = s.to_lower()
  if lower == "normal" || lower == "正常" {
    ItemStatus::Normal
  } else if lower == "high" || lower == "偏高" || lower == "高" {
    ItemStatus::High
  } else if lower == "low" || lower == "偏低" || lower == "低" {
    ItemStatus::Low
  } else if lower == "abnormal" || lower == "异常" {
    ItemStatus::Abnormal
  } else {
    ItemStatus::Unknown
  }
}

pub enum MedGemmaError {
  ConnectionError(String)
  ParseError(String)
  APIError(Int, String)
  TimeoutError
  InvalidInput(String)
  ModelNotReady
  RateLimitExceeded
}

pub fn MedGemmaError::to_string(self : MedGemmaError) -> String {
  match self {
    MedGemmaError::ConnectionError(msg) => "连接错误: " + msg
    MedGemmaError::ParseError(msg) => "解析错误: " + msg
    MedGemmaError::APIError(code, msg) => "API错误(" + code.to_string() + "): " + msg
    MedGemmaError::TimeoutError => "请求超时"
    MedGemmaError::InvalidInput(msg) => "输入无效: " + msg
    MedGemmaError::ModelNotReady => "模型未就绪"
    MedGemmaError::RateLimitExceeded => "请求频率超限"
  }
}

pub struct APIResponse {
  success : Bool
  content : String
  error : Option<MedGemmaError>
  processing_time_ms : Int
}

pub fn APIResponse::success(content : String) -> APIResponse {
  APIResponse::{
    success: true,
    content,
    error: None,
    processing_time_ms: 0
  }
}

pub fn APIResponse::error(err : MedGemmaError) -> APIResponse {
  APIResponse::{
    success: false,
    content: "",
    error: Some(err),
    processing_time_ms: 0
  }
}

pub fn APIResponse::with_time(self : APIResponse, time_ms : Int) -> APIResponse {
  { ..self, processing_time_ms: time_ms }
}
