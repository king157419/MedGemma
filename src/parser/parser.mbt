pub fn parse_text_report(content : String) -> Result<@types.Report, String> {
  if content.is_empty() {
    Err("报告内容不能为空")
  } else {
    Ok(@types.Report::new(@types.ReportFormat::Text, content))
  }
}

pub fn detect_report_type(content : String) -> String {
  let content_lower = content.to_lower()
  if content_lower.contains("血常规") || content_lower.contains("血细胞") || content_lower.contains("白细胞") || content_lower.contains("红细胞") {
    "blood_routine"
  } else if content_lower.contains("肝功能") || content_lower.contains("alt") || content_lower.contains("ast") || content_lower.contains("谷丙") || content_lower.contains("谷草") {
    "liver_function"
  } else if content_lower.contains("肾功能") || content_lower.contains("肌酐") || content_lower.contains("尿素") || content_lower.contains("尿酸") {
    "kidney_function"
  } else if content_lower.contains("血糖") || content_lower.contains("葡萄糖") || content_lower.contains("糖化血红蛋白") {
    "blood_glucose"
  } else if content_lower.contains("血脂") || content_lower.contains("胆固醇") || content_lower.contains("甘油三酯") {
    "blood_lipid"
  } else if content_lower.contains("尿常规") || content_lower.contains("尿检") {
    "urine_routine"
  } else if content_lower.contains("甲状腺") || content_lower.contains("t3") || content_lower.contains("t4") || content_lower.contains("tsh") {
    "thyroid"
  } else {
    "general"
  }
}

pub fn get_report_type_name(type_code : String) -> String {
  match type_code {
    "blood_routine" => "血常规检验报告"
    "liver_function" => "肝功能检验报告"
    "kidney_function" => "肾功能检验报告"
    "blood_glucose" => "血糖检验报告"
    "blood_lipid" => "血脂检验报告"
    "urine_routine" => "尿常规检验报告"
    "thyroid" => "甲状腺功能检验报告"
    _ => "医疗检验报告"
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

pub fn extract_numeric_value(value_str : String) -> Option<Double> {
  let cleaned = value_str.trim()
  let mut num_str = ""
  let mut has_dot = false
  
  for c in cleaned.chars() {
    if c >= '0' && c <= '9' {
      num_str = num_str + c.to_string()
    } else if c == '.' && !has_dot {
      num_str = num_str + "."
      has_dot = true
    } else if c == '-' && num_str.is_empty() {
      num_str = "-"
    } else {
      break
    }
  }
  
  if num_str.is_empty() || num_str == "-" || num_str == "." {
    None
  } else {
    num_str.to_double()
  }
}

pub fn parse_range(range_str : String) -> Option<(Double, Double)> {
  let cleaned = range_str.trim()
  
  let parts = if cleaned.contains('-') {
    cleaned.split('-')
  } else if cleaned.contains('~') {
    cleaned.split('~')
  } else if cleaned.contains('—') {
    cleaned.split('—')
  } else {
    return None
  }
  
  if parts.length() != 2 {
    return None
  }
  
  let low = extract_numeric_value(parts[0])
  let high = extract_numeric_value(parts[1])
  
  match (low, high) {
    (Some(l), Some(h)) => Some((l, h))
    _ => None
  }
}

pub fn determine_status(value : Double, range : (Double, Double)) -> @types.ItemStatus {
  let (low, high) = range
  if value < low {
    @types.ItemStatus::Low
  } else if value > high {
    @types.ItemStatus::High
  } else {
    @types.ItemStatus::Normal
  }
}

pub struct NormalRange {
  low : Double
  high : Double
  unit : String
}

pub let blood_routine_ranges : Map<String, NormalRange> = {
  let mut m = Map::new()
  m.set("血红蛋白", { low: 120.0, high: 160.0, unit: "g/L" })
  m.set("红细胞", { low: 4.0, high: 5.5, unit: "T/L" })
  m.set("白细胞", { low: 4.0, high: 10.0, unit: "G/L" })
  m.set("血小板", { low: 100.0, high: 300.0, unit: "G/L" })
  m.set("红细胞压积", { low: 37.0, high: 50.0, unit: "%" })
  m.set("平均红细胞体积", { low: 80.0, high: 100.0, unit: "fL" })
  m
}

pub let liver_function_ranges : Map<String, NormalRange> = {
  let mut m = Map::new()
  m.set("谷丙转氨酶(ALT)", { low: 0.0, high: 40.0, unit: "U/L" })
  m.set("谷草转氨酶(AST)", { low: 0.0, high: 40.0, unit: "U/L" })
  m.set("总胆红素", { low: 3.4, high: 17.1, unit: "umol/L" })
  m.set("直接胆红素", { low: 0.0, high: 6.8, unit: "umol/L" })
  m.set("白蛋白", { low: 35.0, high: 55.0, unit: "g/L" })
  m
}

pub let kidney_function_ranges : Map<String, NormalRange> = {
  let mut m = Map::new()
  m.set("肌酐", { low: 44.0, high: 133.0, unit: "umol/L" })
  m.set("尿素氮", { low: 2.9, high: 8.2, unit: "mmol/L" })
  m.set("尿酸", { low: 150.0, high: 420.0, unit: "umol/L" })
  m
}

pub fn get_normal_range(item_name : String, report_type : String) -> Option<NormalRange> {
  let ranges = match report_type {
    "blood_routine" => blood_routine_ranges
    "liver_function" => liver_function_ranges
    "kidney_function" => kidney_function_ranges
    _ => return None
  }
  
  let normalized_name = normalize_item_name(item_name)
  ranges.get(normalized_name)
}

fn normalize_item_name(name : String) -> String {
  let trimmed = name.trim()
  let lower = trimmed.to_lower()
  
  if lower.contains("血红蛋白") || lower.contains("hgb") || lower.contains("hb") {
    "血红蛋白"
  } else if lower.contains("红细胞") && !lower.contains("压积") && !lower.contains("体积") {
    "红细胞"
  } else if lower.contains("白细胞") && !lower.contains("分类") {
    "白细胞"
  } else if lower.contains("血小板") {
    "血小板"
  } else if lower.contains("红细胞压积") || lower.contains("hct") {
    "红细胞压积"
  } else if lower.contains("平均红细胞体积") || lower.contains("mcv") {
    "平均红细胞体积"
  } else if lower.contains("谷丙") || lower.contains("alt") {
    "谷丙转氨酶(ALT)"
  } else if lower.contains("谷草") || lower.contains("ast") {
    "谷草转氨酶(AST)"
  } else if lower.contains("总胆红素") || lower.contains("tbil") {
    "总胆红素"
  } else if lower.contains("直接胆红素") || lower.contains("dbil") {
    "直接胆红素"
  } else if lower.contains("白蛋白") && !lower.contains("球") {
    "白蛋白"
  } else if lower.contains("肌酐") || lower.contains("cr") || lower.contains("crea") {
    "肌酐"
  } else if lower.contains("尿素氮") || lower.contains("bun") {
    "尿素氮"
  } else if lower.contains("尿酸") || lower.contains("ua") {
    "尿酸"
  } else {
    trimmed
  }
}

pub fn create_detail_item(name : String, value_str : String, unit : String, report_type : String) -> @types.DetailItem {
  let item = @types.DetailItem::new(name, value_str, unit)
  
  let value_opt = extract_numeric_value(value_str)
  let range_opt = get_normal_range(name, report_type)
  
  match (value_opt, range_opt) {
    (Some(value), Some(range)) => {
      let status = determine_status(value, (range.low, range.high))
      let range_str = "\{range.low}-\{range.high} \{range.unit}"
      item
        .with_status(status)
        .with_range(range_str)
    }
    _ => item
  }
}
