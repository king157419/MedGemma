pub fn parse_text_report(content : String) -> Result<@types.Report, String> {
  if content.is_empty() {
    Err("报告内容不能为空")
  } else {
    Ok(@types.Report::{
      format: @types.ReportFormat::Text,
      content,
      metadata: Map::new()
    })
  }
}

pub fn detect_report_type(content : String) -> String {
  let content_lower = content.to_lower()
  if content_lower.contains("血常规") || content_lower.contains("血细胞") {
    "blood_routine"
  } else if content_lower.contains("肝功能") || content_lower.contains("alt") || content_lower.contains("ast") {
    "liver_function"
  } else if content_lower.contains("肾功能") || content_lower.contains("肌酐") || content_lower.contains("尿素") {
    "kidney_function"
  } else if content_lower.contains("血糖") || content_lower.contains("葡萄糖") {
    "blood_glucose"
  } else if content_lower.contains("血脂") || content_lower.contains("胆固醇") {
    "blood_lipid"
  } else {
    "general"
  }
}

pub fn extract_key_values(content : String) -> Array<(String, String, String)> {
  let lines = content.split('\n')
  let result : Array<(String, String, String)> = []
  
  for line in lines {
    let trimmed = line.trim()
    if trimmed.is_empty() { continue }
    
    let parts = trimmed.split(|c| c == ' ' || c == '\t')
    if parts.length() >= 2 {
      let name = parts[0].trim()
      let value = parts[1].trim()
      let unit = if parts.length() >= 3 { parts[2].trim() } else { "" }
      result.push((name, value, unit))
    }
  }
  
  result
}
