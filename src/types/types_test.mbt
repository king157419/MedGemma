test "Report::new creates report with default values" {
  let report = @types.Report::new(@types.ReportFormat::Text, "test content")
  inspect(report.content, content="test content")
}

test "Report::with_metadata adds metadata" {
  let report = @types.Report::new(@types.ReportFormat::Text, "test")
    .with_metadata("patient", "张三")
  inspect(report.metadata.get("patient"), content="Some(\"张三\")")
}

test "DetailItem::new creates item with default status" {
  let item = @types.DetailItem::new("血红蛋白", "140", "g/L")
  inspect(item.item_name, content="血红蛋白")
  inspect(item.value, content="140")
  inspect(item.unit, content="g/L")
}

test "DetailItem::is_normal returns correct value" {
  let normal_item = @types.DetailItem::new("test", "100", "mg")
    .with_status(@types.ItemStatus::Normal)
  let high_item = @types.DetailItem::new("test", "200", "mg")
    .with_status(@types.ItemStatus::High)
  
  inspect(normal_item.is_normal(), content="true")
  inspect(high_item.is_normal(), content="false")
}

test "ItemStatus::to_string returns Chinese text" {
  inspect(@types.ItemStatus::Normal.to_string(), content="正常")
  inspect(@types.ItemStatus::High.to_string(), content="偏高")
  inspect(@types.ItemStatus::Low.to_string(), content="偏低")
  inspect(@types.ItemStatus::Abnormal.to_string(), content="异常")
}

test "ItemStatus::from_string parses correctly" {
  inspect(@types.ItemStatus::from_string("正常"), content="ItemStatus::Normal")
  inspect(@types.ItemStatus::from_string("偏高"), content="ItemStatus::High")
  inspect(@types.ItemStatus::from_string("normal"), content="ItemStatus::Normal")
}

test "AnalysisResult::new creates result with empty arrays" {
  let result = @types.AnalysisResult::new("测试摘要")
  inspect(result.summary, content="测试摘要")
  inspect(result.has_warnings(), content="false")
}

test "AnalysisResult::add_warning updates warnings" {
  let result = @types.AnalysisResult::new("test")
    .add_warning("注意异常指标")
  inspect(result.has_warnings(), content="true")
}

test "MedGemmaError::to_string formats error message" {
  let err = @types.MedGemmaError::ConnectionError("网络不可达")
  inspect(err.to_string(), content="连接错误: 网络不可达")
}

test "APIResponse::success creates successful response" {
  let resp = @types.APIResponse::success("分析结果")
  inspect(resp.success, content="true")
  inspect(resp.content, content="分析结果")
}

test "APIResponse::error creates error response" {
  let resp = @types.APIResponse::error(@types.MedGemmaError::TimeoutError)
  inspect(resp.success, content="false")
}
