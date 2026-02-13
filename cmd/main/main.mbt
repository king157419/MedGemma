fn main {
  println("╔════════════════════════════════════════════════════════════╗")
  println("║       MedReport Bridge - 医疗报告解读助手 v0.1.0          ║")
  println("║       Medical Report Analysis System                       ║")
  println("╚════════════════════════════════════════════════════════════╝")
  println("")
  
  let sample_report = "
血常规检验报告

血红蛋白 145 g/L
红细胞 4.8 T/L
白细胞 7.5 G/L
血小板 220 G/L
红细胞压积 42 %
平均红细胞体积 88 fL
"
  
  println("【示例报告】")
  println("────────────────────────────────────────────────────────────")
  println(sample_report)
  println("────────────────────────────────────────────────────────────")
  println("")
  
  let report_result = @parser.parse_text_report(sample_report)
  
  match report_result {
    Ok(report) => {
      let report_type = @parser.detect_report_type(sample_report)
      let type_name = @parser.get_report_type_name(report_type)
      
      println("【报告识别】")
      println("  报告类型: " + type_name)
      println("")
      
      let items = @parser.extract_key_values(sample_report)
      
      let mut result = @types.AnalysisResult::new("根据血常规检验结果分析")
      
      for (name, value, unit) in items {
        if !name.is_empty() && !value.is_empty() {
          let detail = @parser.create_detail_item(name, value, unit, report_type)
          let explanation = @formatter.generate_explanation(name, detail.status)
          let detail_with_explanation = detail.with_explanation(explanation)
          result = result.add_detail(detail_with_explanation)
          
          if detail.is_abnormal() {
            result = result.add_warning(name + " " + value + " " + unit + " (" + detail.status.to_string() + ")")
          }
        }
      }
      
      let overall = @formatter.get_overall_status(result)
      result = { ..result, summary: overall }
      
      if result.has_warnings() {
        result = result.add_recommendation("建议复查异常指标")
        result = result.add_recommendation("如有不适，请及时就医")
      } else {
        result = result.add_recommendation("保持健康的生活方式")
        result = result.add_recommendation("定期体检")
      }
      
      let output = @formatter.format_summary(result)
      println(output)
      
      println("")
      println("【JSON格式输出】")
      println("────────────────────────────────────────────────────────────")
      println(@formatter.format_json(result))
      println("")
      
      println("【Markdown格式输出】")
      println("────────────────────────────────────────────────────────────")
      println(@formatter.format_markdown(result))
    }
    Err(msg) => {
      println("错误: " + msg)
    }
  }
}
