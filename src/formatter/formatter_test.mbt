fn init {
  println("Running formatter module tests...")
}

test "test_generate_explanation_normal" {
  let exp1 = @formatter.generate_explanation("血红蛋白", @types.ItemStatus::normal())
  inspect!(exp1.contains("正常").to_string(), content="true")
  
  let exp2 = @formatter.generate_explanation("白细胞", @types.ItemStatus::normal())
  inspect!(exp2.contains("正常").to_string(), content="true")
}

test "test_generate_explanation_high" {
  let exp = @formatter.generate_explanation("血红蛋白", @types.ItemStatus::high())
  inspect!(exp.contains("高").to_string(), content="true")
}

test "test_generate_explanation_low" {
  let exp = @formatter.generate_explanation("血红蛋白", @types.ItemStatus::low())
  inspect!(exp.contains("低").to_string(), content="true")
}

test "test_generate_explanation_cholesterol" {
  let exp = @formatter.generate_explanation("总胆固醇", @types.ItemStatus::high())
  inspect!(exp.contains("胆固醇").to_string(), content="true")
}

test "test_generate_explanation_hdl" {
  let exp = @formatter.generate_explanation("高密度脂蛋白", @types.ItemStatus::low())
  inspect!(exp.contains("好胆固醇").to_string(), content="true")
}

test "test_generate_explanation_ldl" {
  let exp = @formatter.generate_explanation("低密度脂蛋白", @types.ItemStatus::high())
  inspect!(exp.contains("坏胆固醇").to_string(), content="true")
}

test "test_get_overall_status_normal" {
  let result = @types.AnalysisResult::new("测试")
  let item = @types.DetailItem::new("test", "1", "u").with_status(@types.ItemStatus::normal())
  let result2 = result.add_detail(item)
  let status = @formatter.get_overall_status(result2)
  inspect!(status, content="各项指标均在正常范围内")
}

test "test_get_overall_status_abnormal" {
  let result = @types.AnalysisResult::new("测试")
  let item = @types.DetailItem::new("test", "1", "u").with_status(@types.ItemStatus::high())
  let result2 = result.add_detail(item)
  let status = @formatter.get_overall_status(result2)
  inspect!(status.contains("异常").to_string(), content="true")
}

test "test_format_summary_contains_summary" {
  let result = @types.AnalysisResult::new("测试摘要")
  let output = @formatter.format_summary(result)
  inspect!(output.contains("测试摘要").to_string(), content="true")
}

test "test_format_summary_contains_disclaimer" {
  let result = @types.AnalysisResult::new("测试")
  let output = @formatter.format_summary(result)
  inspect!(output.contains("仅供参考").to_string(), content="true")
}

test "test_format_markdown_header" {
  let result = @types.AnalysisResult::new("测试")
  let output = @formatter.format_markdown(result)
  inspect!(output.contains("# 健康报告解读").to_string(), content="true")
}

test "test_format_markdown_table" {
  let result = @types.AnalysisResult::new("测试")
  let item = @types.DetailItem::new("血红蛋白", "145", "g/L")
    .with_status(@types.ItemStatus::normal())
    .with_range("120-160 g/L")
  let result2 = result.add_detail(item)
  let output = @formatter.format_markdown(result2)
  inspect!(output.contains("| 指标 |").to_string(), content="true")
  inspect!(output.contains("血红蛋白").to_string(), content="true")
}

test "test_format_json_structure" {
  let result = @types.AnalysisResult::new("测试摘要")
  let output = @formatter.format_json(result)
  inspect!(output.contains("\"summary\"").to_string(), content="true")
  inspect!(output.contains("\"details\"").to_string(), content="true")
  inspect!(output.contains("\"warnings\"").to_string(), content="true")
  inspect!(output.contains("\"recommendations\"").to_string(), content="true")
}

test "test_format_json_with_details" {
  let result = @types.AnalysisResult::new("测试")
  let item = @types.DetailItem::new("血红蛋白", "145", "g/L")
    .with_status(@types.ItemStatus::normal())
    .with_range("120-160 g/L")
    .with_explanation("测试解释")
  let result2 = result.add_detail(item)
  let output = @formatter.format_json(result2)
  inspect!(output.contains("\"name\"").to_string(), content="true")
  inspect!(output.contains("\"value\"").to_string(), content="true")
  inspect!(output.contains("\"status\"").to_string(), content="true")
}
