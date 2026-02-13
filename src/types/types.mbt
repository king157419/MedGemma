pub enum ReportFormat {
  Text
  Image
  PDF
}

pub fn ReportFormat::text() -> ReportFormat {
  ReportFormat::Text
}

pub struct Report {
  format : ReportFormat
  content : String
}

pub fn Report::new(format : ReportFormat, content : String) -> Report {
  Report::{
    format,
    content,
  }
}

pub struct AnalysisResult {
  summary : String
  details : Array[DetailItem]
  recommendations : Array[String]
  warnings : Array[String]
}

pub fn AnalysisResult::new(summary : String) -> AnalysisResult {
  AnalysisResult::{
    summary,
    details: [],
    recommendations: [],
    warnings: [],
  }
}

pub fn AnalysisResult::with_summary(self : AnalysisResult, summary : String) -> AnalysisResult {
  { ..self, summary }
}

pub fn AnalysisResult::add_detail(self : AnalysisResult, item : DetailItem) -> AnalysisResult {
  let new_details = self.details
  new_details.push(item)
  { ..self, details: new_details }
}

pub fn AnalysisResult::add_recommendation(self : AnalysisResult, rec : String) -> AnalysisResult {
  let new_rec = self.recommendations
  new_rec.push(rec)
  { ..self, recommendations: new_rec }
}

pub fn AnalysisResult::add_warning(self : AnalysisResult, warning : String) -> AnalysisResult {
  let new_warnings = self.warnings
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
    explanation: "",
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

pub fn ItemStatus::normal() -> ItemStatus {
  ItemStatus::Normal
}

pub fn ItemStatus::high() -> ItemStatus {
  ItemStatus::High
}

pub fn ItemStatus::low() -> ItemStatus {
  ItemStatus::Low
}

pub fn ItemStatus::unknown() -> ItemStatus {
  ItemStatus::Unknown
}
