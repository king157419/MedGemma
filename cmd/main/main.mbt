fn main {
  println("==============================================")
  println("  MedReport Bridge - 医疗报告解读助手 v0.2.0")
  println("  Medical Report Analysis System")
  println("==============================================")
  println("")
  
  demo_blood_routine()
  println("")
  demo_lipid_profile()
  println("")
  demo_liver_function()
}

fn demo_blood_routine() -> Unit {
  println("【示例1: 血常规检验报告】")
  println("----------------------------------------------")
  println("血红蛋白 145 g/L")
  println("红细胞 4.8 T/L")
  println("白细胞 7.5 G/L")
  println("血小板 220 G/L")
  println("----------------------------------------------")
  println("")
  
  let mut result = @types.AnalysisResult::new("根据血常规检验结果分析")
  
  let item1 = @parser.create_detail_item("血红蛋白", "145", "g/L")
  let explanation1 = @formatter.generate_explanation("血红蛋白", item1.status)
  result = result.add_detail(item1.with_explanation(explanation1))
  if item1.is_abnormal() { result = result.add_warning("血红蛋白 145 g/L (" + item1.status.to_string() + ")") }
  
  let item2 = @parser.create_detail_item("白细胞", "7.5", "G/L")
  let explanation2 = @formatter.generate_explanation("白细胞", item2.status)
  result = result.add_detail(item2.with_explanation(explanation2))
  if item2.is_abnormal() { result = result.add_warning("白细胞 7.5 G/L (" + item2.status.to_string() + ")") }
  
  let item3 = @parser.create_detail_item("血小板", "220", "G/L")
  let explanation3 = @formatter.generate_explanation("血小板", item3.status)
  result = result.add_detail(item3.with_explanation(explanation3))
  if item3.is_abnormal() { result = result.add_warning("血小板 220 G/L (" + item3.status.to_string() + ")") }
  
  let item4 = @parser.create_detail_item("红细胞", "4.8", "T/L")
  let explanation4 = @formatter.generate_explanation("红细胞", item4.status)
  result = result.add_detail(item4.with_explanation(explanation4))
  if item4.is_abnormal() { result = result.add_warning("红细胞 4.8 T/L (" + item4.status.to_string() + ")") }
  
  let overall = @formatter.get_overall_status(result)
  result = result.with_summary(overall)
  
  result = result.add_recommendation("保持健康的生活方式")
  result = result.add_recommendation("定期体检")
  
  let output = @formatter.format_summary(result)
  println(output)
}

fn demo_lipid_profile() -> Unit {
  println("【示例2: 血脂检验报告】")
  println("----------------------------------------------")
  println("总胆固醇 5.8 mmol/L")
  println("甘油三酯 2.1 mmol/L")
  println("高密度脂蛋白 0.9 mmol/L")
  println("低密度脂蛋白 3.8 mmol/L")
  println("----------------------------------------------")
  println("")
  
  let mut result = @types.AnalysisResult::new("根据血脂检验结果分析")
  
  let item1 = @parser.create_detail_item("总胆固醇", "5.8", "mmol/L")
  let explanation1 = @formatter.generate_explanation("总胆固醇", item1.status)
  result = result.add_detail(item1.with_explanation(explanation1))
  if item1.is_abnormal() { result = result.add_warning("总胆固醇 5.8 mmol/L (" + item1.status.to_string() + ")") }
  
  let item2 = @parser.create_detail_item("甘油三酯", "2.1", "mmol/L")
  let explanation2 = @formatter.generate_explanation("甘油三酯", item2.status)
  result = result.add_detail(item2.with_explanation(explanation2))
  if item2.is_abnormal() { result = result.add_warning("甘油三酯 2.1 mmol/L (" + item2.status.to_string() + ")") }
  
  let item3 = @parser.create_detail_item("高密度脂蛋白", "0.9", "mmol/L")
  let explanation3 = @formatter.generate_explanation("高密度脂蛋白", item3.status)
  result = result.add_detail(item3.with_explanation(explanation3))
  if item3.is_abnormal() { result = result.add_warning("高密度脂蛋白 0.9 mmol/L (" + item3.status.to_string() + ")") }
  
  let item4 = @parser.create_detail_item("低密度脂蛋白", "3.8", "mmol/L")
  let explanation4 = @formatter.generate_explanation("低密度脂蛋白", item4.status)
  result = result.add_detail(item4.with_explanation(explanation4))
  if item4.is_abnormal() { result = result.add_warning("低密度脂蛋白 3.8 mmol/L (" + item4.status.to_string() + ")") }
  
  let overall = @formatter.get_overall_status(result)
  result = result.with_summary(overall)
  
  result = result.add_recommendation("控制饮食，减少高脂肪食物摄入")
  result = result.add_recommendation("适量运动，每周至少150分钟")
  result = result.add_recommendation("建议复查血脂")
  
  let output = @formatter.format_summary(result)
  println(output)
}

fn demo_liver_function() -> Unit {
  println("【示例3: 肝功能检验报告】")
  println("----------------------------------------------")
  println("谷丙转氨酶 65 U/L")
  println("谷草转氨酶 45 U/L")
  println("总胆红素 12.5 umol/L")
  println("白蛋白 42 g/L")
  println("----------------------------------------------")
  println("")
  
  let mut result = @types.AnalysisResult::new("根据肝功能检验结果分析")
  
  let item1 = @parser.create_detail_item("谷丙转氨酶", "65", "U/L")
  let explanation1 = @formatter.generate_explanation("谷丙转氨酶", item1.status)
  result = result.add_detail(item1.with_explanation(explanation1))
  if item1.is_abnormal() { result = result.add_warning("谷丙转氨酶 65 U/L (" + item1.status.to_string() + ")") }
  
  let item2 = @parser.create_detail_item("谷草转氨酶", "45", "U/L")
  let explanation2 = @formatter.generate_explanation("谷草转氨酶", item2.status)
  result = result.add_detail(item2.with_explanation(explanation2))
  if item2.is_abnormal() { result = result.add_warning("谷草转氨酶 45 U/L (" + item2.status.to_string() + ")") }
  
  let item3 = @parser.create_detail_item("总胆红素", "12.5", "umol/L")
  let explanation3 = @formatter.generate_explanation("总胆红素", item3.status)
  result = result.add_detail(item3.with_explanation(explanation3))
  if item3.is_abnormal() { result = result.add_warning("总胆红素 12.5 umol/L (" + item3.status.to_string() + ")") }
  
  let item4 = @parser.create_detail_item("白蛋白", "42", "g/L")
  let explanation4 = @formatter.generate_explanation("白蛋白", item4.status)
  result = result.add_detail(item4.with_explanation(explanation4))
  if item4.is_abnormal() { result = result.add_warning("白蛋白 42 g/L (" + item4.status.to_string() + ")") }
  
  let overall = @formatter.get_overall_status(result)
  result = result.with_summary(overall)
  
  result = result.add_recommendation("避免饮酒")
  result = result.add_recommendation("注意休息，避免过度劳累")
  result = result.add_recommendation("建议复查肝功能")
  
  let output = @formatter.format_summary(result)
  println(output)
  
  println("")
  println("【Markdown格式输出示例】")
  println("────────────────────────────────────────────────────────────")
  println(@formatter.format_markdown(result))
}
