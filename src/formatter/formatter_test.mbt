test "format_summary includes summary" {
  let result = @types.AnalysisResult::new("整体健康状况良好")
  let output = @formatter.format_summary(result)
  inspect(output.contains("整体健康状况良好"), content="true")
}

test "format_summary includes disclaimer" {
  let result = @types.AnalysisResult::new("test")
  let output = @formatter.format_summary(result)
  inspect(output.contains("仅供参考"), content="true")
}

test "format_summary includes warnings" {
  let result = @types.AnalysisResult::new("test")
    .add_warning("血红蛋白偏高")
  let output = @formatter.format_summary(result)
  inspect(output.contains("血红蛋白偏高"), content="true")
}

test "format_summary includes recommendations" {
  let result = @types.AnalysisResult::new("test")
    .add_recommendation("建议复查")
  let output = @formatter.format_summary(result)
  inspect(output.contains("建议复查"), content="true")
}

test "simplify_explanation adds explanations" {
  let text = @formatter.simplify_explanation("血红蛋白检测结果")
  inspect(text.contains("携带氧气"), content="true")
}

test "simplify_explanation handles multiple terms" {
  let text = @formatter.simplify_explanation("血红蛋白和白细胞")
  inspect(text.contains("携带氧气"), content="true")
  inspect(text.contains("免疫细胞"), content="true")
}

test "generate_explanation for normal status" {
  let explanation = @formatter.generate_explanation("血红蛋白", @types.ItemStatus::Normal)
  inspect(explanation.contains("正常范围"), content="true")
}

test "generate_explanation for high status" {
  let explanation = @formatter.generate_explanation("白细胞", @types.ItemStatus::High)
  inspect(explanation.contains("高于正常范围"), content="true")
}

test "generate_explanation for low status" {
  let explanation = @formatter.generate_explanation("血小板", @types.ItemStatus::Low)
  inspect(explanation.contains("低于正常范围"), content="true")
}

test "count_abnormal_items counts correctly" {
  let result = @types.AnalysisResult::new("test")
    .add_detail(@types.DetailItem::new("item1", "100", "g/L")
      .with_status(@types.ItemStatus::High))
    .add_detail(@types.DetailItem::new("item2", "50", "g/L")
      .with_status(@types.ItemStatus::Normal))
    .add_detail(@types.DetailItem::new("item3", "200", "g/L")
      .with_status(@types.ItemStatus::Low))
  
  let count = @formatter.count_abnormal_items(result)
  inspect(count.to_string(), content="2")
}

test "get_overall_status for no abnormalities" {
  let result = @types.AnalysisResult::new("test")
  let status = @formatter.get_overall_status(result)
  inspect(status.contains("正常范围"), content="true")
}

test "get_overall_status for one abnormality" {
  let result = @types.AnalysisResult::new("test")
    .add_detail(@types.DetailItem::new("item", "100", "g/L")
      .with_status(@types.ItemStatus::High))
  let status = @formatter.get_overall_status(result)
  inspect(status.contains("1项"), content="true")
}

test "format_json produces valid json" {
  let result = @types.AnalysisResult::new("test summary")
  let json = @formatter.format_json(result)
  inspect(json.contains("summary"), content="true")
  inspect(json.contains("test summary"), content="true")
}

test "format_html produces valid html" {
  let result = @types.AnalysisResult::new("test")
  let html = @formatter.format_html(result)
  inspect(html.contains("<!DOCTYPE html>"), content="true")
  inspect(html.contains("</html>"), content="true")
}

test "format_markdown produces valid markdown" {
  let result = @types.AnalysisResult::new("test")
    .add_detail(@types.DetailItem::new("血红蛋白", "140", "g/L")
      .with_status(@types.ItemStatus::Normal)
      .with_range("120-160 g/L"))
  let md = @formatter.format_markdown(result)
  inspect(md.contains("# 健康报告解读"), content="true")
  inspect(md.contains("| 血红蛋白"), content="true")
}
