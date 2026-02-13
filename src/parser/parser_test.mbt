test "parse_text_report returns error for empty content" {
  let result = @parser.parse_text_report("")
  inspect(result, content="Err(\"报告内容不能为空\")")
}

test "parse_text_report creates report for valid content" {
  let result = @parser.parse_text_report("血红蛋白 140 g/L")
  match result {
    Ok(report) => inspect(report.content, content="血红蛋白 140 g/L")
    Err(_) => inspect("should not error", content="error")
  }
}

test "detect_report_type identifies blood_routine" {
  let result = @parser.detect_report_type("血常规检验报告")
  inspect(result, content="blood_routine")
}

test "detect_report_type identifies liver_function" {
  let result = @parser.detect_report_type("肝功能检查 ALT 35")
  inspect(result, content="liver_function")
}

test "detect_report_type identifies kidney_function" {
  let result = @parser.detect_report_type("肾功能 肌酐 80")
  inspect(result, content="kidney_function")
}

test "detect_report_type returns general for unknown" {
  let result = @parser.detect_report_type("未知报告类型")
  inspect(result, content="general")
}

test "get_report_type_name returns Chinese names" {
  inspect(@parser.get_report_type_name("blood_routine"), content="血常规检验报告")
  inspect(@parser.get_report_type_name("liver_function"), content="肝功能检验报告")
  inspect(@parser.get_report_type_name("general"), content="医疗检验报告")
}

test "extract_numeric_value parses valid number" {
  let result = @parser.extract_numeric_value("140.5")
  match result {
    Some(v) => inspect(v, content="140.5")
    None => inspect("should parse", content="error")
  }
}

test "extract_numeric_value handles unit suffix" {
  let result = @parser.extract_numeric_value("140g/L")
  match result {
    Some(v) => inspect(v, content="140.0")
    None => inspect("should parse", content="error")
  }
}

test "extract_numeric_value returns None for invalid" {
  let result = @parser.extract_numeric_value("abc")
  inspect(result, content="None")
}

test "parse_range parses valid range" {
  let result = @parser.parse_range("120-160")
  match result {
    Some((low, high)) => {
      inspect(low, content="120.0")
      inspect(high, content="160.0")
    }
    None => inspect("should parse", content="error")
  }
}

test "determine_status returns High for high value" {
  let status = @parser.determine_status(200.0, (120.0, 160.0))
  inspect(status, content="ItemStatus::High")
}

test "determine_status returns Low for low value" {
  let status = @parser.determine_status(100.0, (120.0, 160.0))
  inspect(status, content="ItemStatus::Low")
}

test "determine_status returns Normal for in-range value" {
  let status = @parser.determine_status(140.0, (120.0, 160.0))
  inspect(status, content="ItemStatus::Normal")
}

test "create_detail_item sets status based on value" {
  let item = @parser.create_detail_item("血红蛋白", "180", "g/L", "blood_routine")
  inspect(item.status, content="ItemStatus::High")
}

test "create_detail_item sets normal range" {
  let item = @parser.create_detail_item("血红蛋白", "140", "g/L", "blood_routine")
  inspect(item.normal_range.contains("120"), content="true")
}
