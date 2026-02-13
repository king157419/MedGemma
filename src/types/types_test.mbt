fn init {
  println("Running types module tests...")
}

test "test_item_status_to_string" {
  let normal = @types.ItemStatus::normal()
  inspect!(normal.to_string(), content="正常")
  
  let high = @types.ItemStatus::high()
  inspect!(high.to_string(), content="偏高")
  
  let low = @types.ItemStatus::low()
  inspect!(low.to_string(), content="偏低")
  
  let unknown = @types.ItemStatus::unknown()
  inspect!(unknown.to_string(), content="未知")
}

test "test_detail_item_new" {
  let item = @types.DetailItem::new("血红蛋白", "145", "g/L")
  inspect!(item.item_name, content="血红蛋白")
  inspect!(item.value, content="145")
  inspect!(item.unit, content="g/L")
  inspect!(item.normal_range, content="")
  inspect!(item.explanation, content="")
}

test "test_detail_item_with_methods" {
  let item = @types.DetailItem::new("白细胞", "7.5", "G/L")
    .with_status(@types.ItemStatus::normal())
    .with_range("4-10 G/L")
    .with_explanation("测试解释")
  
  inspect!(item.status.to_string(), content="正常")
  inspect!(item.normal_range, content="4-10 G/L")
  inspect!(item.explanation, content="测试解释")
}

test "test_detail_item_is_abnormal" {
  let normal_item = @types.DetailItem::new("test", "1", "u")
    .with_status(@types.ItemStatus::normal())
  inspect!(normal_item.is_abnormal(), content="false")
  
  let high_item = @types.DetailItem::new("test", "1", "u")
    .with_status(@types.ItemStatus::high())
  inspect!(high_item.is_abnormal(), content="true")
  
  let low_item = @types.DetailItem::new("test", "1", "u")
    .with_status(@types.ItemStatus::low())
  inspect!(low_item.is_abnormal(), content="true")
}

test "test_analysis_result_new" {
  let result = @types.AnalysisResult::new("测试摘要")
  inspect!(result.summary, content="测试摘要")
  inspect!(result.details.length().to_string(), content="0")
  inspect!(result.warnings.length().to_string(), content="0")
  inspect!(result.recommendations.length().to_string(), content="0")
}

test "test_analysis_result_add_methods" {
  let mut result = @types.AnalysisResult::new("测试")
  let item = @types.DetailItem::new("test", "1", "u")
  
  result = result.add_detail(item)
  inspect!(result.details.length().to_string(), content="1")
  
  result = result.add_warning("警告1")
  inspect!(result.warnings.length().to_string(), content="1")
  
  result = result.add_recommendation("建议1")
  inspect!(result.recommendations.length().to_string(), content="1")
}

test "test_analysis_result_has_warnings" {
  let result1 = @types.AnalysisResult::new("测试")
  inspect!(result1.has_warnings().to_string(), content="false")
  
  let result2 = @types.AnalysisResult::new("测试").add_warning("警告")
  inspect!(result2.has_warnings().to_string(), content="true")
}

test "test_report_format" {
  let format = @types.ReportFormat::text()
  let report = @types.Report::new(format, "测试内容")
  inspect!(report.content, content="测试内容")
}
