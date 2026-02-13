pub enum ReportFormat {
  Text
  Image
  PDF
}

pub struct Report {
  format : ReportFormat
  content : String
  metadata : Map<String, String>
}

pub struct AnalysisResult {
  summary : String
  details : Array<DetailItem>
  recommendations : Array<String>
  warnings : Array<String>
}

pub struct DetailItem {
  item_name : String
  value : String
  unit : String
  normal_range : String
  status : ItemStatus
  explanation : String
}

pub enum ItemStatus {
  Normal
  High
  Low
  Abnormal
  Unknown
}

pub enum MedGemmaError {
  ConnectionError(String)
  ParseError(String)
  APIError(Int, String)
  TimeoutError
  InvalidInput(String)
}
