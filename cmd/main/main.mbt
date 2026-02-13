fn main {
  println("==============================================")
  println("  MedReport Bridge - 医疗报告解读助手 v0.1.0")
  println("  Medical Report Analysis System")
  println("==============================================")
  println("")
  
  println("【示例报告】")
  println("----------------------------------------------")
  println("血常规检验报告")
  println("")
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
  
  let item2 = @parser.create_detail_item("白细胞", "7.5", "G/L")
  let explanation2 = @formatter.generate_explanation("白细胞", item2.status)
  result = result.add_detail(item2.with_explanation(explanation2))
  
  let item3 = @parser.create_detail_item("血小板", "220", "G/L")
  let explanation3 = @formatter.generate_explanation("血小板", item3.status)
  result = result.add_detail(item3.with_explanation(explanation3))
  
  let item4 = @parser.create_detail_item("红细胞", "4.8", "T/L")
  let explanation4 = @formatter.generate_explanation("红细胞", item4.status)
  result = result.add_detail(item4.with_explanation(explanation4))
  
  let overall = @formatter.get_overall_status(result)
  result = result.with_summary(overall)
  
  result = result.add_recommendation("保持健康的生活方式")
  result = result.add_recommendation("定期体检")
  
  let output = @formatter.format_summary(result)
  println(output)
}
