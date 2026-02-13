pub fn generate_explanation(item_name : String, status : @types.ItemStatus) -> String {
  let status_text = match status {
    @types.ItemStatus::Normal => "处于正常范围内"
    @types.ItemStatus::High => "高于正常范围"
    @types.ItemStatus::Low => "低于正常范围"
    @types.ItemStatus::Abnormal => "存在异常"
    @types.ItemStatus::Unknown => "状态未知"
  }
  
  match item_name {
    "血红蛋白" => "血红蛋白是血液中负责携带氧气的蛋白质。" + status_text + "。"
    "白细胞" => "白细胞是身体的免疫细胞。" + status_text + "。"
    "血小板" => "血小板参与血液凝固。" + status_text + "。"
    "红细胞" => "红细胞负责运输氧气。" + status_text + "。"
    _ => item_name + status_text + "。"
  }
}

pub fn get_overall_status(result : @types.AnalysisResult) -> String {
  let mut abnormal_count = 0
  for item in result.details {
    if item.is_abnormal() {
      abnormal_count = abnormal_count + 1
    }
  }
  
  if abnormal_count == 0 {
    "各项指标均在正常范围内"
  } else if abnormal_count == 1 {
    "有1项指标异常"
  } else {
    "有" + abnormal_count.to_string() + "项指标异常"
  }
}

pub fn format_summary(result : @types.AnalysisResult) -> String {
  let mut output = "【健康报告解读】\n"
  output = output + "═══════════════════════════════════\n\n"
  
  output = output + "整体评估：" + result.summary + "\n\n"
  
  if result.details.length() > 0 {
    output = output + "详细指标分析：\n"
    output = output + "───────────────────────────────────\n"
    for item in result.details {
      let status_icon = match item.status {
        @types.ItemStatus::Normal => "[正常]"
        @types.ItemStatus::High => "[偏高]"
        @types.ItemStatus::Low => "[偏低]"
        @types.ItemStatus::Abnormal => "[异常]"
        @types.ItemStatus::Unknown => "[未知]"
      }
      output = output + status_icon + " " + item.item_name + ": " + item.value + " " + item.unit + "\n"
      if !item.normal_range.is_empty() {
        output = output + "   正常范围：" + item.normal_range + "\n"
      }
      if !item.explanation.is_empty() {
        output = output + "   解读：" + item.explanation + "\n"
      }
    }
    output = output + "\n"
  }
  
  if result.warnings.length() > 0 {
    output = output + "需要关注的指标：\n"
    for warning in result.warnings {
      output = output + "  - " + warning + "\n"
    }
    output = output + "\n"
  }
  
  if result.recommendations.length() > 0 {
    output = output + "建议：\n"
    for rec in result.recommendations {
      output = output + "  - " + rec + "\n"
    }
    output = output + "\n"
  }
  
  output = output + "═══════════════════════════════════\n"
  output = output + "重要提示：本解读仅供参考，不作为医疗诊断依据。\n"
  
  output
}
