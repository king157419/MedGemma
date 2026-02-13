pub fn analyze_report(content : String) -> @gateway.AIAnalysisResponse {
  let report_type = @parser.detect_report_type(content)
  let type_name = @parser.get_report_type_name(report_type)
  
  let mut analysis = "【AI智能分析报告】\n"
  analysis = analysis + "══════════════════════════════════════════════════════\n\n"
  analysis = analysis + "报告类型：" + type_name + "\n\n"
  
  let items = parse_items(content)
  let abnormal_items : Array[String] = []
  let recommendations : Array[String] = []
  let warnings : Array[String] = []
  
  for item_tuple in items {
    let (name, value, unit) = item_tuple
    let normalized_name = @parser.normalize_item_name(name)
    let item = @parser.create_detail_item(normalized_name, value, unit)
    
    if item.is_abnormal() {
      abnormal_items.push(normalized_name + " " + value + " " + unit + " (" + item.status.to_string() + ")")
    }
  }
  
  if abnormal_items.length() == 0 {
    analysis = analysis + "整体评估：各项指标均在正常范围内，健康状况良好。\n\n"
    recommendations.push("继续保持健康的生活方式")
    recommendations.push("定期进行体检")
    recommendations.push("保持均衡饮食")
    recommendations.push("适量运动")
  } else {
    analysis = analysis + "整体评估：发现" + abnormal_items.length().to_string() + "项异常指标，需要关注。\n\n"
    
    analysis = analysis + "异常指标分析：\n"
    analysis = analysis + "────────────────────────────────────────────────────\n"
    
    for item_str in abnormal_items {
      analysis = analysis + "• " + item_str + "\n"
      warnings.push(item_str)
    }
    analysis = analysis + "\n"
    
    let specific_analysis = generate_specific_analysis(report_type, abnormal_items)
    analysis = analysis + specific_analysis
    
    let recs = generate_recommendations(report_type, abnormal_items)
    for rec in recs {
      recommendations.push(rec)
    }
  }
  
  analysis = analysis + "\n══════════════════════════════════════════════════════\n"
  analysis = analysis + "重要提示：本分析由AI规则引擎生成，仅供参考，不作为医疗诊断依据。\n"
  
  let mut response = @gateway.AIAnalysisResponse::success(analysis)
  response = response.with_recommendations(recommendations)
  response = response.with_warnings(warnings)
  response = response.with_confidence(0.9)
  
  response
}

fn generate_specific_analysis(report_type : String, abnormal_items : Array[String]) -> String {
  match report_type {
    "blood_routine" => generate_blood_analysis(abnormal_items)
    "liver_function" => generate_liver_analysis(abnormal_items)
    "kidney_function" => generate_kidney_analysis(abnormal_items)
    "blood_lipid" => generate_lipid_analysis(abnormal_items)
    "blood_glucose" => generate_glucose_analysis(abnormal_items)
    "thyroid" => generate_thyroid_analysis(abnormal_items)
    "tumor_marker" => generate_tumor_analysis()
    "electrolyte" => generate_electrolyte_analysis(abnormal_items)
    "cardiac_enzyme" => generate_cardiac_analysis(abnormal_items)
    _ => generate_general_analysis()
  }
}

fn generate_blood_analysis(abnormal_items : Array[String]) -> String {
  let mut analysis = "血液系统分析：\n"
  
  let has_hemoglobin = contains_keyword(abnormal_items, "血红蛋白")
  let has_wbc = contains_keyword(abnormal_items, "白细胞")
  let has_platelet = contains_keyword(abnormal_items, "血小板")
  
  if has_hemoglobin {
    analysis = analysis + "• 血红蛋白异常可能提示贫血或红细胞增多症，建议进一步检查铁代谢指标。\n"
  }
  if has_wbc {
    analysis = analysis + "• 白细胞异常可能与感染、炎症或免疫系统疾病相关。\n"
  }
  if has_platelet {
    analysis = analysis + "• 血小板异常可能影响凝血功能，建议复查并咨询血液科医生。\n"
  }
  
  analysis
}

fn generate_liver_analysis(abnormal_items : Array[String]) -> String {
  let mut analysis = "肝功能分析：\n"
  
  let has_alt = contains_keyword(abnormal_items, "谷丙转氨酶")
  let has_ast = contains_keyword(abnormal_items, "谷草转氨酶")
  let has_bilirubin = contains_keyword(abnormal_items, "胆红素")
  
  if has_alt || has_ast {
    analysis = analysis + "• 转氨酶升高提示肝细胞损伤，可能与肝炎、脂肪肝、药物损伤等有关。\n"
    analysis = analysis + "• 建议避免饮酒，减少油腻食物摄入，保证充足睡眠。\n"
  }
  if has_bilirubin {
    analysis = analysis + "• 胆红素异常可能与肝胆系统疾病相关，建议进行腹部超声检查。\n"
  }
  
  analysis
}

fn generate_kidney_analysis(abnormal_items : Array[String]) -> String {
  let mut analysis = "肾功能分析：\n"
  
  let has_creatinine = contains_keyword(abnormal_items, "肌酐")
  let has_urea = contains_keyword(abnormal_items, "尿素")
  let has_uric = contains_keyword(abnormal_items, "尿酸")
  
  if has_creatinine || has_urea {
    analysis = analysis + "• 肾功能指标异常提示肾脏可能存在损伤，建议进一步检查尿常规和肾脏超声。\n"
    analysis = analysis + "• 注意控制蛋白质摄入，避免使用肾毒性药物。\n"
  }
  if has_uric {
    analysis = analysis + "• 尿酸升高可能增加痛风风险，建议减少高嘌呤食物摄入。\n"
  }
  
  analysis
}

fn generate_lipid_analysis(abnormal_items : Array[String]) -> String {
  let mut analysis = "血脂分析：\n"
  
  let has_tc = contains_keyword(abnormal_items, "总胆固醇")
  let has_tg = contains_keyword(abnormal_items, "甘油三酯")
  let has_ldl = contains_keyword(abnormal_items, "低密度脂蛋白")
  let has_hdl = contains_keyword(abnormal_items, "高密度脂蛋白")
  
  if has_tc || has_tg || has_ldl {
    analysis = analysis + "• 血脂异常是心血管疾病的重要危险因素。\n"
    analysis = analysis + "• 建议控制饮食，减少高脂肪、高胆固醇食物摄入。\n"
    analysis = analysis + "• 增加有氧运动，每周至少150分钟中等强度运动。\n"
  }
  if has_hdl {
    analysis = analysis + "• 高密度脂蛋白偏低会降低心血管保护作用，建议适量运动和戒烟。\n"
  }
  
  analysis
}

fn generate_glucose_analysis(abnormal_items : Array[String]) -> String {
  let mut analysis = "血糖分析：\n"
  
  let has_fpg = contains_keyword(abnormal_items, "空腹血糖")
  let has_hba1c = contains_keyword(abnormal_items, "糖化血红蛋白")
  
  if has_fpg || has_hba1c {
    analysis = analysis + "• 血糖异常可能提示糖尿病前期或糖尿病，建议进一步进行糖耐量试验。\n"
    analysis = analysis + "• 控制碳水化合物摄入，避免高糖食物。\n"
    analysis = analysis + "• 定期监测血糖，必要时咨询内分泌科医生。\n"
  }
  
  analysis
}

fn generate_thyroid_analysis(abnormal_items : Array[String]) -> String {
  let mut analysis = "甲状腺功能分析：\n"
  
  let has_tsh = contains_keyword(abnormal_items, "TSH")
  let has_t3 = contains_keyword(abnormal_items, "T3") || contains_keyword(abnormal_items, "FT3")
  let has_t4 = contains_keyword(abnormal_items, "T4") || contains_keyword(abnormal_items, "FT4")
  
  if has_tsh || has_t3 || has_t4 {
    analysis = analysis + "• 甲状腺功能异常可能导致甲亢或甲减。\n"
    analysis = analysis + "• 建议进行甲状腺超声检查，咨询内分泌科医生。\n"
    analysis = analysis + "• 注意休息，避免过度劳累和精神紧张。\n"
  }
  
  analysis
}

fn generate_tumor_analysis() -> String {
  let mut analysis = "肿瘤标志物分析：\n"
  
  analysis = analysis + "• 肿瘤标志物升高不一定是恶性肿瘤，可能与炎症、良性疾病等有关。\n"
  analysis = analysis + "• 建议进行进一步检查，如影像学检查等。\n"
  analysis = analysis + "• 请咨询肿瘤科医生进行专业评估。\n"
  analysis = analysis + "• 保持良好心态，避免过度焦虑。\n"
  
  analysis
}

fn generate_electrolyte_analysis(abnormal_items : Array[String]) -> String {
  let mut analysis = "电解质分析：\n"
  
  let has_k = contains_keyword(abnormal_items, "钾")
  let has_na = contains_keyword(abnormal_items, "钠")
  let has_ca = contains_keyword(abnormal_items, "钙")
  
  if has_k {
    analysis = analysis + "• 血钾异常可能影响心脏功能，严重时需紧急处理。\n"
  }
  if has_na {
    analysis = analysis + "• 血钠异常可能与脱水、肾脏疾病或内分泌疾病相关。\n"
  }
  if has_ca {
    analysis = analysis + "• 血钙异常可能与甲状旁腺疾病、骨骼疾病相关。\n"
  }
  
  analysis = analysis + "• 建议在医生指导下进行电解质调整。\n"
  
  analysis
}

fn generate_cardiac_analysis(abnormal_items : Array[String]) -> String {
  let mut analysis = "心肌酶谱分析：\n"
  
  let has_ck = contains_keyword(abnormal_items, "CK")
  let has_ckmb = contains_keyword(abnormal_items, "CKMB")
  let has_ldh = contains_keyword(abnormal_items, "LDH")
  
  if has_ck || has_ckmb {
    analysis = analysis + "• 心肌酶升高可能提示心肌损伤，需警惕心脏疾病。\n"
    analysis = analysis + "• 建议立即进行心电图检查，必要时进行心脏超声。\n"
    analysis = analysis + "• 如有胸痛、胸闷等症状，请立即就医。\n"
  }
  if has_ldh {
    analysis = analysis + "• LDH升高可能与多种组织损伤相关，需结合其他指标综合分析。\n"
  }
  
  analysis
}

fn generate_general_analysis() -> String {
  let mut analysis = "综合分析：\n"
  
  analysis = analysis + "• 发现异常指标，建议进一步检查和咨询专业医生。\n"
  analysis = analysis + "• 请结合临床症状和其他检查结果进行综合评估。\n"
  
  analysis
}

fn generate_recommendations(report_type : String, abnormal_items : Array[String]) -> Array[String] {
  let recs : Array[String] = []
  
  if abnormal_items.length() > 0 {
    recs.push("建议复查异常指标")
    recs.push("如有不适症状，请及时就医")
    recs.push("保持规律作息，避免熬夜")
    recs.push("均衡饮食，适量运动")
  } else {
    recs.push("继续保持健康的生活方式")
    recs.push("定期体检")
    recs.push("均衡饮食，适量运动")
    recs.push("保持良好心态")
  }
  
  match report_type {
    "liver_function" => {
      recs.push("避免饮酒")
      recs.push("减少油腻食物摄入")
    }
    "kidney_function" => {
      recs.push("多喝水，保持尿量充足")
      recs.push("避免使用肾毒性药物")
    }
    "blood_lipid" => {
      recs.push("控制脂肪摄入")
      recs.push("增加有氧运动")
    }
    "blood_glucose" => {
      recs.push("控制碳水化合物摄入")
      recs.push("定期监测血糖")
    }
    "thyroid" => {
      recs.push("避免过度劳累")
      recs.push("定期复查甲状腺功能")
    }
    _ => ignore(())
  }
  
  recs
}

fn contains_keyword(items : Array[String], keyword : String) -> Bool {
  for item in items {
    if item.contains(keyword) {
      return true
    }
  }
  false
}

fn parse_items(input : String) -> Array[(String, String, String)] {
  let lines = input.split("\n")
  let result : Array[(String, String, String)] = []
  
  for line in lines {
    let trimmed = line.trim()
    if trimmed.is_empty() { continue }
    
    let parts = trimmed.split(" ")
    let parts_arr = parts.to_array()
    if parts_arr.length() >= 2 {
      let name = parts_arr[0].trim().to_string()
      let value = parts_arr[1].trim().to_string()
      let unit = if parts_arr.length() >= 3 { parts_arr[2].trim().to_string() } else { "" }
      
      if !name.is_empty() && !value.is_empty() {
        result.push((name, value, unit))
      }
    }
  }
  
  result
}
