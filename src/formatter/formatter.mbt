pub fn format_summary(result : @types.AnalysisResult) -> String {
  let mut output = "【健康报告解读】\n"
  output = output + "═══════════════════════════════════\n\n"
  
  output = output + "📋 整体评估：\n"
  output = output + result.summary + "\n\n"
  
  if result.details.length() > 0 {
    output = output + "📊 详细指标分析：\n"
    output = output + "───────────────────────────────────\n"
    for item in result.details {
      output = output + format_detail_item(item)
    }
    output = output + "\n"
  }
  
  if result.warnings.length() > 0 {
    output = output + "⚠️ 需要关注的指标：\n"
    for warning in result.warnings {
      output = output + "  • " + warning + "\n"
    }
    output = output + "\n"
  }
  
  if result.recommendations.length() > 0 {
    output = output + "💡 建议：\n"
    for rec in result.recommendations {
      output = output + "  • " + rec + "\n"
    }
    output = output + "\n"
  }
  
  output = output + "═══════════════════════════════════\n"
  output = output + "📌 重要提示：本解读仅供参考，不作为医疗诊断依据。\n"
  output = output + "   如有健康问题，请咨询专业医生。\n"
  
  output
}

fn format_detail_item(item : @types.DetailItem) -> String {
  let status_icon = match item.status {
    @types.ItemStatus::Normal => "✅"
    @types.ItemStatus::High => "⬆️"
    @types.ItemStatus::Low => "⬇️"
    @types.ItemStatus::Abnormal => "⚠️"
    @types.ItemStatus::Unknown => "❓"
  }
  
  let mut output = "\n" + status_icon + " " + item.item_name + "\n"
  output = output + "   检测值：" + item.value + " " + item.unit + "\n"
  if !item.normal_range.is_empty() {
    output = output + "   正常范围：" + item.normal_range + "\n"
  }
  output = output + "   解读：" + item.explanation + "\n"
  output
}

pub fn format_json(result : @types.AnalysisResult) -> String {
  let json_obj = #{
    "summary": result.summary,
    "details": result.details.map(|item| #{
      "name": item.item_name,
      "value": item.value,
      "unit": item.unit,
      "normal_range": item.normal_range,
      "status": match item.status {
        @types.ItemStatus::Normal => "normal"
        @types.ItemStatus::High => "high"
        @types.ItemStatus::Low => "low"
        @types.ItemStatus::Abnormal => "abnormal"
        @types.ItemStatus::Unknown => "unknown"
      },
      "explanation": item.explanation
    }),
    "warnings": result.warnings,
    "recommendations": result.recommendations
  }
  json_obj.to_json()
}

pub fn simplify_explanation(technical_text : String) -> String {
  let mut result = technical_text
  
  let replacements = [
    ("血红蛋白", "血液中携带氧气的蛋白质"),
    ("白细胞", "身体的免疫细胞，帮助抵抗感染"),
    ("血小板", "帮助血液凝固的细胞"),
    ("谷丙转氨酶(ALT)", "肝脏健康指标"),
    ("谷草转氨酶(AST)", "肝脏和心脏健康指标"),
    ("肌酐", "肾脏过滤功能的指标"),
    ("尿素氮", "肾脏健康的指标"),
    ("空腹血糖", "空腹时的血糖水平"),
    ("甘油三酯", "血液中的一种脂肪"),
    ("总胆固醇", "血液中胆固醇的总量")
  ]
  
  for (term, explanation) in replacements {
    result = result.replace(term, term + "(" + explanation + ")")
  }
  
  result
}
