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
    "白细胞" => "白细胞是身体的免疫细胞，负责抵抗感染。" + status_text + "。"
    "血小板" => "血小板参与血液凝固，帮助止血。" + status_text + "。"
    "红细胞" => "红细胞负责运输氧气到全身各组织。" + status_text + "。"
    "红细胞压积" => "红细胞压积反映红细胞在血液中所占体积比例。" + status_text + "。"
    "平均红细胞体积" => "平均红细胞体积反映红细胞的大小。" + status_text + "。"
    "中性粒细胞" => "中性粒细胞是白细胞的一种，负责吞噬细菌。" + status_text + "。"
    "淋巴细胞" => "淋巴细胞参与免疫反应，产生抗体。" + status_text + "。"
    "单核细胞" => "单核细胞参与清除死亡细胞和病原体。" + status_text + "。"
    "嗜酸性粒细胞" => "嗜酸性粒细胞与过敏反应和寄生虫感染相关。" + status_text + "。"
    "嗜碱性粒细胞" => "嗜碱性粒细胞参与炎症反应。" + status_text + "。"
    "谷丙转氨酶" => "谷丙转氨酶(ALT)主要存在于肝脏，是肝功能的重要指标。" + status_text + "。"
    "谷草转氨酶" => "谷草转氨酶(AST)存在于肝脏、心脏等组织。" + status_text + "。"
    "总胆红素" => "胆红素是红细胞分解产物，反映肝脏代谢功能。" + status_text + "。"
    "直接胆红素" => "直接胆红素是经肝脏处理后的胆红素。" + status_text + "。"
    "白蛋白" => "白蛋白由肝脏合成，维持血液胶体渗透压。" + status_text + "。"
    "球蛋白" => "球蛋白参与免疫反应，反映机体免疫功能。" + status_text + "。"
    "白球比" => "白球比是白蛋白与球蛋白的比值，反映肝脏合成功能。" + status_text + "。"
    "肌酐" => "肌酐是肌肉代谢产物，反映肾脏过滤功能。" + status_text + "。"
    "尿素氮" => "尿素氮是蛋白质代谢产物，反映肾脏排泄功能。" + status_text + "。"
    "尿酸" => "尿酸是嘌呤代谢产物，过高可能导致痛风。" + status_text + "。"
    "总胆固醇" => "总胆固醇是血脂的重要指标，与心血管疾病风险相关。" + status_text + "。"
    "甘油三酯" => "甘油三酯是血液中的脂肪，受饮食影响较大。" + status_text + "。"
    "高密度脂蛋白" => "高密度脂蛋白(HDL)被称为\"好胆固醇\"，有助于清除血管中的胆固醇。" + status_text + "。"
    "低密度脂蛋白" => "低密度脂蛋白(LDL)被称为\"坏胆固醇\"，过高会增加心血管疾病风险。" + status_text + "。"
    "空腹血糖" => "空腹血糖反映基础状态下的血糖水平。" + status_text + "。"
    "餐后血糖" => "餐后血糖反映进食后的血糖调节能力。" + status_text + "。"
    "糖化血红蛋白" => "糖化血红蛋白反映近2-3个月的平均血糖水平。" + status_text + "。"
    "TSH" => "促甲状腺激素(TSH)调节甲状腺功能。" + status_text + "。"
    "T3" => "三碘甲状腺原氨酸(T3)是甲状腺激素，调节新陈代谢。" + status_text + "。"
    "T4" => "甲状腺素(T4)是甲状腺激素，调节新陈代谢。" + status_text + "。"
    "FT3" => "游离三碘甲状腺原氨酸(FT3)是活性甲状腺激素。" + status_text + "。"
    "FT4" => "游离甲状腺素(FT4)是活性甲状腺激素。" + status_text + "。"
    "AFP" => "甲胎蛋白(AFP)是肝癌的肿瘤标志物。" + status_text + "。"
    "CEA" => "癌胚抗原(CEA)是消化道肿瘤的标志物。" + status_text + "。"
    "CA125" => "糖类抗原125(CA125)是卵巢癌的标志物。" + status_text + "。"
    "CA199" => "糖类抗原199(CA199)是胰腺癌、胆管癌的标志物。" + status_text + "。"
    "PSA" => "前列腺特异抗原(PSA)是前列腺癌的标志物。" + status_text + "。"
    "CA153" => "糖类抗原153(CA153)是乳腺癌的标志物。" + status_text + "。"
    "钾" => "钾离子维持心脏和肌肉正常功能。" + status_text + "。"
    "钠" => "钠离子维持体液平衡和神经传导。" + status_text + "。"
    "氯" => "氯离子维持酸碱平衡。" + status_text + "。"
    "钙" => "钙离子参与骨骼代谢和神经肌肉传导。" + status_text + "。"
    "磷" => "磷参与骨骼代谢和能量代谢。" + status_text + "。"
    "镁" => "镁离子参与多种酶反应。" + status_text + "。"
    "CK" => "肌酸激酶(CK)主要存在于心肌和骨骼肌。" + status_text + "。"
    "CKMB" => "肌酸激酶同工酶(CK-MB)是心肌损伤的特异性指标。" + status_text + "。"
    "LDH" => "乳酸脱氢酶(LDH)存在于多种组织，反映细胞损伤。" + status_text + "。"
    _ => item_name + status_text + "。"
  }
}

pub fn get_overall_status(result : @types.AnalysisResult) -> String {
  let mut abnormal_count = 0
  
  for item in result.details {
    match item.status {
      @types.ItemStatus::High => {
        abnormal_count = abnormal_count + 1
      }
      @types.ItemStatus::Low => {
        abnormal_count = abnormal_count + 1
      }
      @types.ItemStatus::Abnormal => {
        abnormal_count = abnormal_count + 1
      }
      _ => ignore(())
    }
  }
  
  if abnormal_count == 0 {
    "各项指标均在正常范围内"
  } else if abnormal_count == 1 {
    "有1项指标异常，建议关注"
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

pub fn format_markdown(result : @types.AnalysisResult) -> String {
  let mut output = "# 健康报告解读\n\n"
  
  output = output + "## 整体评估\n\n"
  output = output + result.summary + "\n\n"
  
  if result.details.length() > 0 {
    output = output + "## 详细指标分析\n\n"
    output = output + "| 指标 | 检测值 | 单位 | 状态 | 正常范围 |\n"
    output = output + "|------|--------|------|------|----------|\n"
    for item in result.details {
      let status_text = match item.status {
        @types.ItemStatus::Normal => "正常"
        @types.ItemStatus::High => "偏高"
        @types.ItemStatus::Low => "偏低"
        @types.ItemStatus::Abnormal => "异常"
        @types.ItemStatus::Unknown => "未知"
      }
      output = output + "| " + item.item_name + " | " + item.value + " | " + item.unit + " | " + status_text + " | " + item.normal_range + " |\n"
    }
    output = output + "\n"
    
    output = output + "### 指标解读\n\n"
    for item in result.details {
      if !item.explanation.is_empty() {
        output = output + "- **" + item.item_name + "**: " + item.explanation + "\n"
      }
    }
    output = output + "\n"
  }
  
  if result.warnings.length() > 0 {
    output = output + "## 需要关注的指标\n\n"
    for warning in result.warnings {
      output = output + "- " + warning + "\n"
    }
    output = output + "\n"
  }
  
  if result.recommendations.length() > 0 {
    output = output + "## 建议\n\n"
    for rec in result.recommendations {
      output = output + "- " + rec + "\n"
    }
    output = output + "\n"
  }
  
  output = output + "---\n\n"
  output = output + "> **重要提示**: 本解读仅供参考，不作为医疗诊断依据。如有健康问题，请咨询专业医生。\n"
  
  output
}

pub fn format_json(result : @types.AnalysisResult) -> String {
  let mut output = "{\n"
  output = output + "  \"summary\": \"" + escape_json(result.summary) + "\",\n"
  
  output = output + "  \"details\": [\n"
  let mut first = true
  for item in result.details {
    if !first {
      output = output + ",\n"
    }
    first = false
    output = output + "    {\n"
    output = output + "      \"name\": \"" + escape_json(item.item_name) + "\",\n"
    output = output + "      \"value\": \"" + escape_json(item.value) + "\",\n"
    output = output + "      \"unit\": \"" + escape_json(item.unit) + "\",\n"
    output = output + "      \"status\": \"" + item.status.to_string() + "\",\n"
    output = output + "      \"normal_range\": \"" + escape_json(item.normal_range) + "\",\n"
    output = output + "      \"explanation\": \"" + escape_json(item.explanation) + "\"\n"
    output = output + "    }"
  }
  output = output + "\n  ],\n"
  
  output = output + "  \"warnings\": [\n"
  let mut first_warn = true
  for warning in result.warnings {
    if !first_warn {
      output = output + ",\n"
    }
    first_warn = false
    output = output + "    \"" + escape_json(warning) + "\""
  }
  output = output + "\n  ],\n"
  
  output = output + "  \"recommendations\": [\n"
  let mut first_rec = true
  for rec in result.recommendations {
    if !first_rec {
      output = output + ",\n"
    }
    first_rec = false
    output = output + "    \"" + escape_json(rec) + "\""
  }
  output = output + "\n  ]\n"
  
  output = output + "}\n"
  
  output
}

fn escape_json(s : String) -> String {
  let mut result = ""
  for c in s {
    match c {
      '"' => result = result + "\\\""
      '\\' => result = result + "\\\\"
      '\n' => result = result + "\\n"
      '\r' => result = result + "\\r"
      '\t' => result = result + "\\t"
      _ => result = result + c.to_string()
    }
  }
  result
}
