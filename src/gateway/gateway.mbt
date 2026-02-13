pub struct MedGemmaConfig {
  api_url : String
  model : String
  timeout_ms : Int
}

pub fn default_config() -> MedGemmaConfig {
  MedGemmaConfig::{
    api_url: "http://localhost:8000/v1/chat/completions",
    model: "medgemma-4b",
    timeout_ms: 30000
  }
}

pub fn build_request_prompt(report_content : String, report_type : String) -> String {
  let type_instruction = match report_type {
    "blood_routine" => "这是一份血常规检验报告，请分析各项血液指标。"
    "liver_function" => "这是一份肝功能检验报告，请分析肝脏相关指标。"
    "kidney_function" => "这是一份肾功能检验报告，请分析肾脏相关指标。"
    "blood_glucose" => "这是一份血糖检验报告，请分析血糖相关指标。"
    "blood_lipid" => "这是一份血脂检验报告，请分析血脂相关指标。"
    _ => "这是一份医疗检验报告，请分析报告内容。"
  }
  
  "你是一位专业的医疗报告解读助手。请用通俗易懂的语言解读以下医疗报告，帮助患者家属理解报告内容。\n\n" +
  type_instruction + "\n\n" +
  "报告内容：\n" + report_content + "\n\n" +
  "请提供以下内容：\n" +
  "1. 整体健康评估摘要\n" +
  "2. 各项指标的解释（包括正常范围和当前状态）\n" +
  "3. 需要关注的异常指标\n" +
  "4. 建议的后续行动\n\n" +
  "注意：请使用简单易懂的语言，避免过多专业术语。本解读仅供参考，不作为医疗诊断依据。"
}

pub fn format_api_request(config : MedGemmaConfig, prompt : String) -> String {
  let request = #{
    "model": config.model,
    "messages": [
      #{
        "role": "system",
        "content": "你是一位专业的医疗报告解读助手，擅长用通俗易懂的语言解释医疗检验报告。"
      },
      #{
        "role": "user",
        "content": prompt
      }
    ],
    "temperature": 0.3,
    "max_tokens": 2000
  }
  request.to_json()
}
