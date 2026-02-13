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
  if !item.explanation.is_empty() {
    output = output + "   解读：" + item.explanation + "\n"
  }
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
      "status": status_to_string(item.status),
      "explanation": item.explanation
    }),
    "warnings": result.warnings,
    "recommendations": result.recommendations,
    "confidence": result.confidence
  }
  json_obj.to_json()
}

fn status_to_string(status : @types.ItemStatus) -> String {
  match status {
    @types.ItemStatus::Normal => "normal"
    @types.ItemStatus::High => "high"
    @types.ItemStatus::Low => "low"
    @types.ItemStatus::Abnormal => "abnormal"
    @types.ItemStatus::Unknown => "unknown"
  }
}

pub fn format_html(result : @types.AnalysisResult) -> String {
  let mut html = "<!DOCTYPE html>\n"
  html = html + "<html lang=\"zh-CN\">\n"
  html = html + "<head>\n"
  html = html + "  <meta charset=\"UTF-8\">\n"
  html = html + "  <title>健康报告解读</title>\n"
  html = html + "  <style>\n"
  html = html + "    body { font-family: 'Microsoft YaHei', sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }\n"
  html = html + "    .summary { background: #f0f9ff; padding: 15px; border-radius: 8px; margin-bottom: 20px; }\n"
  html = html + "    .detail-item { border-left: 3px solid #3b82f6; padding-left: 15px; margin: 10px 0; }\n"
  html = html + "    .normal { border-left-color: #22c55e; }\n"
  html = html + "    .high { border-left-color: #ef4444; }\n"
  html = html + "    .low { border-left-color: #f59e0b; }\n"
  html = html + "    .warning { background: #fef3c7; padding: 10px; border-radius: 4px; margin: 5px 0; }\n"
  html = html + "    .recommendation { background: #dcfce7; padding: 10px; border-radius: 4px; margin: 5px 0; }\n"
  html = html + "    .disclaimer { color: #666; font-size: 12px; margin-top: 20px; padding: 10px; background: #f3f4f6; border-radius: 4px; }\n"
  html = html + "  </style>\n"
  html = html + "</head>\n"
  html = html + "<body>\n"
  html = html + "  <h1>健康报告解读</h1>\n"
  html = html + "  <div class=\"summary\">\n"
  html = html + "    <h2>整体评估</h2>\n"
  html = html + "    <p>" + result.summary + "</p>\n"
  html = html + "  </div>\n"
  
  if result.details.length() > 0 {
    html = html + "  <h2>详细指标分析</h2>\n"
    for item in result.details {
      let status_class = match item.status {
        @types.ItemStatus::Normal => "normal"
        @types.ItemStatus::High => "high"
        @types.ItemStatus::Low => "low"
        _ => ""
      }
      html = html + "  <div class=\"detail-item " + status_class + "\">\n"
      html = html + "    <strong>" + item.item_name + "</strong>\n"
      html = html + "    <p>检测值：" + item.value + " " + item.unit + "</p>\n"
      if !item.normal_range.is_empty() {
        html = html + "    <p>正常范围：" + item.normal_range + "</p>\n"
      }
      if !item.explanation.is_empty() {
        html = html + "    <p>解读：" + item.explanation + "</p>\n"
      }
      html = html + "  </div>\n"
    }
  }
  
  if result.warnings.length() > 0 {
    html = html + "  <h2>需要关注的指标</h2>\n"
    for warning in result.warnings {
      html = html + "  <div class=\"warning\">⚠️ " + warning + "</div>\n"
    }
  }
  
  if result.recommendations.length() > 0 {
    html = html + "  <h2>建议</h2>\n"
    for rec in result.recommendations {
      html = html + "  <div class=\"recommendation\">💡 " + rec + "</div>\n"
    }
  }
  
  html = html + "  <div class=\"disclaimer\">\n"
  html = html + "    📌 重要提示：本解读仅供参考，不作为医疗诊断依据。如有健康问题，请咨询专业医生。\n"
  html = html + "  </div>\n"
  html = html + "</body>\n"
  html = html + "</html>"
  
  html
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
    ("总胆固醇", "血液中胆固醇的总量"),
    ("红细胞", "负责运输氧气的细胞"),
    ("红细胞压积", "红细胞在血液中所占的体积比例"),
    ("尿酸", "嘌呤代谢的产物"),
    ("糖化血红蛋白", "反映近2-3个月血糖控制情况")
  ]
  
  for (term, explanation) in replacements {
    result = result.replace(term, term + "(" + explanation + ")")
  }
  
  result
}

pub fn generate_explanation(item_name : String, status : @types.ItemStatus) -> String {
  let status_text = match status {
    @types.ItemStatus::Normal => "处于正常范围内"
    @types.ItemStatus::High => "高于正常范围"
    @types.ItemStatus::Low => "低于正常范围"
    @types.ItemStatus::Abnormal => "存在异常"
    @types.ItemStatus::Unknown => "状态未知"
  }
  
  let explanation = match item_name {
    "血红蛋白" => "血红蛋白是血液中负责携带氧气的蛋白质。" + status_text + "。"
    "白细胞" => "白细胞是身体的免疫细胞。" + status_text + "，可能影响身体抵抗感染的能力。"
    "血小板" => "血小板参与血液凝固。" + status_text + "，可能影响止血能力。"
    "红细胞" => "红细胞负责运输氧气。" + status_text + "。"
    "肌酐" => "肌酐是肌肉代谢的产物，通过肾脏排出。" + status_text + "，可能反映肾脏功能状态。"
    "尿素氮" => "尿素氮是蛋白质代谢的产物。" + status_text + "，可能与肾脏功能相关。"
    "尿酸" => "尿酸是嘌呤代谢的产物。" + status_text + "，过高可能与痛风相关。"
    _ => item_name + status_text + "。"
  }
  
  explanation
}

pub fn count_abnormal_items(result : @types.AnalysisResult) -> Int {
  let mut count = 0
  for item in result.details {
    if item.is_abnormal() {
      count = count + 1
    }
  }
  count
}

pub fn get_overall_status(result : @types.AnalysisResult) -> String {
  let abnormal_count = count_abnormal_items(result)
  
  if abnormal_count == 0 {
    "各项指标均在正常范围内"
  } else if abnormal_count == 1 {
    "有1项指标异常"
  } else if abnormal_count <= 3 {
    "有" + abnormal_count.to_string() + "项指标异常"
  } else {
    "多项指标异常，建议尽快就医"
  }
}

pub fn format_markdown(result : @types.AnalysisResult) -> String {
  let mut md = "# 健康报告解读\n\n"
  
  md = md + "## 整体评估\n\n"
  md = md + result.summary + "\n\n"
  
  if result.details.length() > 0 {
    md = md + "## 详细指标分析\n\n"
    md = md + "| 指标 | 检测值 | 正常范围 | 状态 |\n"
    md = md + "|------|--------|----------|------|\n"
    for item in result.details {
      let status_text = match item.status {
        @types.ItemStatus::Normal => "✅ 正常"
        @types.ItemStatus::High => "⬆️ 偏高"
        @types.ItemStatus::Low => "⬇️ 偏低"
        @types.ItemStatus::Abnormal => "⚠️ 异常"
        @types.ItemStatus::Unknown => "❓ 未知"
      }
      md = md + "| " + item.item_name + " | " + item.value + " " + item.unit + " | " + item.normal_range + " | " + status_text + " |\n"
    }
    md = md + "\n"
  }
  
  if result.warnings.length() > 0 {
    md = md + "## 需要关注的指标\n\n"
    for warning in result.warnings {
      md = md + "- ⚠️ " + warning + "\n"
    }
    md = md + "\n"
  }
  
  if result.recommendations.length() > 0 {
    md = md + "## 建议\n\n"
    for rec in result.recommendations {
      md = md + "- 💡 " + rec + "\n"
    }
    md = md + "\n"
  }
  
  md = md + "---\n\n"
  md = md + "*📌 重要提示：本解读仅供参考，不作为医疗诊断依据。如有健康问题，请咨询专业医生。*\n"
  
  md
}
