pub fn parse_text_report(content : String) -> Result[@types.Report, String] {
  if content.is_empty() {
    Err("报告内容不能为空")
  } else {
    Ok(@types.Report::new(@types.ReportFormat::text(), content))
  }
}

pub fn detect_report_type(content : String) -> String {
  let lower = content.to_lower()
  if lower.contains("血常规") || lower.contains("白细胞") || lower.contains("红细胞") || lower.contains("血红蛋白") {
    "blood_routine"
  } else if lower.contains("肝功能") || lower.contains("alt") || lower.contains("ast") || lower.contains("谷丙") || lower.contains("谷草") {
    "liver_function"
  } else if lower.contains("肾功能") || lower.contains("肌酐") || lower.contains("尿素") || lower.contains("尿酸") {
    "kidney_function"
  } else if lower.contains("血脂") || lower.contains("胆固醇") || lower.contains("甘油三酯") || lower.contains("ldl") || lower.contains("hdl") {
    "blood_lipid"
  } else if lower.contains("血糖") || lower.contains("葡萄糖") || lower.contains("糖化血红蛋白") || lower.contains("空腹血糖") {
    "blood_glucose"
  } else if lower.contains("甲状腺") || lower.contains("t3") || lower.contains("t4") || lower.contains("tsh") {
    "thyroid"
  } else if lower.contains("尿常规") || lower.contains("尿蛋白") || lower.contains("尿潜血") {
    "urine_routine"
  } else {
    "general"
  }
}

pub fn get_report_type_name(type_code : String) -> String {
  match type_code {
    "blood_routine" => "血常规检验报告"
    "liver_function" => "肝功能检验报告"
    "kidney_function" => "肾功能检验报告"
    "blood_lipid" => "血脂检验报告"
    "blood_glucose" => "血糖检验报告"
    "thyroid" => "甲状腺功能检验报告"
    "urine_routine" => "尿常规检验报告"
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
    "血红蛋白" => check_range(num, 120.0, 160.0)
    "白细胞" => check_range(num, 4.0, 10.0)
    "血小板" => check_range(num, 100.0, 300.0)
    "红细胞" => check_range(num, 4.0, 5.5)
    "红细胞压积" => check_range(num, 37.0, 50.0)
    "平均红细胞体积" => check_range(num, 80.0, 100.0)
    "谷丙转氨酶" => check_range(num, 0.0, 40.0)
    "谷草转氨酶" => check_range(num, 0.0, 40.0)
    "总胆红素" => check_range(num, 3.4, 17.1)
    "直接胆红素" => check_range(num, 0.0, 6.8)
    "白蛋白" => check_range(num, 35.0, 55.0)
    "肌酐" => check_range(num, 44.0, 133.0)
    "尿素氮" => check_range(num, 2.9, 8.2)
    "尿酸" => check_range(num, 150.0, 420.0)
    "总胆固醇" => check_range(num, 3.1, 5.7)
    "甘油三酯" => check_range(num, 0.4, 1.7)
    "高密度脂蛋白" => check_range_low_only(num, 1.0)
    "低密度脂蛋白" => check_range_high_only(num, 3.4)
    "空腹血糖" => check_range(num, 3.9, 6.1)
    "糖化血红蛋白" => check_range_high_only(num, 6.0)
    "TSH" => check_range(num, 0.27, 4.2)
    "T3" => check_range(num, 1.3, 3.1)
    "T4" => check_range(num, 66.0, 181.0)
    _ => @types.ItemStatus::unknown()
  }
}

fn check_range(num : Option[Double], low : Double, high : Double) -> @types.ItemStatus {
  match num {
    Some(v) => if v >= low && v <= high { @types.ItemStatus::normal() } else if v < low { @types.ItemStatus::low() } else { @types.ItemStatus::high() }
    None => @types.ItemStatus::unknown()
  }
}

fn check_range_high_only(num : Option[Double], high : Double) -> @types.ItemStatus {
  match num {
    Some(v) => if v <= high { @types.ItemStatus::normal() } else { @types.ItemStatus::high() }
    None => @types.ItemStatus::unknown()
  }
}

fn check_range_low_only(num : Option[Double], low : Double) -> @types.ItemStatus {
  match num {
    Some(v) => if v >= low { @types.ItemStatus::normal() } else { @types.ItemStatus::low() }
    None => @types.ItemStatus::unknown()
  }
}

fn get_normal_range(name : String) -> String {
  match name {
    "血红蛋白" => "120-160 g/L"
    "白细胞" => "4-10 G/L"
    "血小板" => "100-300 G/L"
    "红细胞" => "4-5.5 T/L"
    "红细胞压积" => "37-50 %"
    "平均红细胞体积" => "80-100 fL"
    "谷丙转氨酶" => "0-40 U/L"
    "谷草转氨酶" => "0-40 U/L"
    "总胆红素" => "3.4-17.1 umol/L"
    "直接胆红素" => "0-6.8 umol/L"
    "白蛋白" => "35-55 g/L"
    "肌酐" => "44-133 umol/L"
    "尿素氮" => "2.9-8.2 mmol/L"
    "尿酸" => "150-420 umol/L"
    "总胆固醇" => "3.1-5.7 mmol/L"
    "甘油三酯" => "0.4-1.7 mmol/L"
    "高密度脂蛋白" => ">1.0 mmol/L"
    "低密度脂蛋白" => "<3.4 mmol/L"
    "空腹血糖" => "3.9-6.1 mmol/L"
    "糖化血红蛋白" => "<6.0 %"
    "TSH" => "0.27-4.2 mIU/L"
    "T3" => "1.3-3.1 nmol/L"
    "T4" => "66-181 nmol/L"
    _ => ""
  }
}

pub fn normalize_item_name(name : String) -> String {
  let trimmed = name.trim()
  let lower = trimmed.to_lower()
  
  if lower.contains("血红蛋白") || lower.contains("hgb") || lower.contains("hb") {
    "血红蛋白"
  } else if lower.contains("白细胞") && !lower.contains("分类") {
    "白细胞"
  } else if lower.contains("血小板") {
    "血小板"
  } else if lower.contains("红细胞") && !lower.contains("压积") && !lower.contains("体积") {
    "红细胞"
  } else if lower.contains("红细胞压积") || lower.contains("hct") {
    "红细胞压积"
  } else if lower.contains("平均红细胞体积") || lower.contains("mcv") {
    "平均红细胞体积"
  } else if lower.contains("谷丙") || lower.contains("alt") || lower.contains("丙氨酸") {
    "谷丙转氨酶"
  } else if lower.contains("谷草") || lower.contains("ast") || lower.contains("天门冬") {
    "谷草转氨酶"
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
  } else if lower.contains("总胆固醇") || lower.contains("tc") || (lower.contains("胆固醇") && !lower.contains("高") && !lower.contains("低")) {
    "总胆固醇"
  } else if lower.contains("甘油三酯") || lower.contains("tg") {
    "甘油三酯"
  } else if lower.contains("高密度") || lower.contains("hdl") {
    "高密度脂蛋白"
  } else if lower.contains("低密度") || lower.contains("ldl") {
    "低密度脂蛋白"
  } else if lower.contains("空腹血糖") || lower.contains("fpg") || (lower.contains("血糖") && !lower.contains("餐后")) {
    "空腹血糖"
  } else if lower.contains("糖化血红蛋白") || lower.contains("hba1c") {
    "糖化血红蛋白"
  } else if lower.contains("tsh") || lower.contains("促甲状腺") {
    "TSH"
  } else if lower.contains("t3") && !lower.contains("t4") {
    "T3"
  } else if lower.contains("t4") && !lower.contains("t3") {
    "T4"
  } else {
    trimmed.to_string()
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
