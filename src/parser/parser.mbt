pub fn parse_text_report(content : String) -> Result[@types.Report, String] {
  if content.is_empty() {
    Err("报告内容不能为空")
  } else {
    Ok(@types.Report::new(@types.ReportFormat::text(), content))
  }
}

pub fn detect_report_type(content : String) -> String {
  if content.contains("血常规") || content.contains("白细胞") {
    "blood_routine"
  } else if content.contains("肝功能") {
    "liver_function"
  } else if content.contains("肾功能") {
    "kidney_function"
  } else {
    "general"
  }
}

pub fn get_report_type_name(type_code : String) -> String {
  match type_code {
    "blood_routine" => "血常规检验报告"
    "liver_function" => "肝功能检验报告"
    "kidney_function" => "肾功能检验报告"
    _ => "医疗检验报告"
  }
}

pub fn create_detail_item(name : String, value : String, unit : String) -> @types.DetailItem {
  @types.DetailItem::new(name, value, unit)
    .with_status(determine_status(name, value))
    .with_range(get_normal_range(name))
}

fn determine_status(name : String, value : String) -> @types.ItemStatus {
  let num = parse_double(value)
  match name {
    "血红蛋白" => {
      match num {
        Some(v) => if v >= 120.0 && v <= 160.0 { @types.ItemStatus::normal() } else if v < 120.0 { @types.ItemStatus::low() } else { @types.ItemStatus::high() }
        None => @types.ItemStatus::unknown()
      }
    }
    "白细胞" => {
      match num {
        Some(v) => if v >= 4.0 && v <= 10.0 { @types.ItemStatus::normal() } else if v < 4.0 { @types.ItemStatus::low() } else { @types.ItemStatus::high() }
        None => @types.ItemStatus::unknown()
      }
    }
    "血小板" => {
      match num {
        Some(v) => if v >= 100.0 && v <= 300.0 { @types.ItemStatus::normal() } else if v < 100.0 { @types.ItemStatus::low() } else { @types.ItemStatus::high() }
        None => @types.ItemStatus::unknown()
      }
    }
    "红细胞" => {
      match num {
        Some(v) => if v >= 4.0 && v <= 5.5 { @types.ItemStatus::normal() } else if v < 4.0 { @types.ItemStatus::low() } else { @types.ItemStatus::high() }
        None => @types.ItemStatus::unknown()
      }
    }
    _ => @types.ItemStatus::unknown()
  }
}

fn get_normal_range(name : String) -> String {
  match name {
    "血红蛋白" => "120-160 g/L"
    "白细胞" => "4-10 G/L"
    "血小板" => "100-300 G/L"
    "红细胞" => "4-5.5 T/L"
    _ => ""
  }
}

fn parse_double(s : String) -> Option[Double] {
  let trimmed = s.trim()
  let mut result = 0.0
  let mut decimal = 0.0
  let mut decimal_places = 0
  let mut found_digit = false
  let mut in_decimal = false
  let mut negative = false
  let mut i = 0
  
  for c in trimmed {
    if i == 0 && c == '-' {
      negative = true
    } else if c >= '0' && c <= '9' {
      found_digit = true
      let digit = (c.to_int() - 48).to_double()
      if in_decimal {
        decimal = decimal * 10.0 + digit
        decimal_places = decimal_places + 1
      } else {
        result = result * 10.0 + digit
      }
    } else if c == '.' && !in_decimal {
      in_decimal = true
    } else {
      break
    }
    i = i + 1
  }
  
  if !found_digit {
    None
  } else {
    let divisor = pow10(decimal_places)
    let mut final_result = result + decimal / divisor
    if negative {
      final_result = -final_result
    }
    Some(final_result)
  }
}

fn pow10(n : Int) -> Double {
  if n <= 0 {
    1.0
  } else {
    let mut result = 1.0
    let mut i = 0
    while i < n {
      result = result * 10.0
      i = i + 1
    }
    result
  }
}
