pub struct MedGemmaConfig {
  api_url : String
  model : String
  timeout_ms : Int
  max_retries : Int
  api_key : String
}

pub fn default_config() -> MedGemmaConfig {
  MedGemmaConfig::{
    api_url: "http://localhost:8000/v1/chat/completions",
    model: "medgemma-4b",
    timeout_ms: 30000,
    max_retries: 3,
    api_key: ""
  }
}

pub fn MedGemmaConfig::with_url(self : MedGemmaConfig, url : String) -> MedGemmaConfig {
  { ..self, api_url: url }
}

pub fn MedGemmaConfig::with_model(self : MedGemmaConfig, model : String) -> MedGemmaConfig {
  { ..self, model }
}

pub fn MedGemmaConfig::with_timeout(self : MedGemmaConfig, timeout_ms : Int) -> MedGemmaConfig {
  { ..self, timeout_ms }
}

pub fn MedGemmaConfig::with_api_key(self : MedGemmaConfig, key : String) -> MedGemmaConfig {
  { ..self, api_key: key }
}

pub fn build_request_prompt(report_content : String, report_type : String) -> String {
  let type_instruction = match report_type {
    "blood_routine" => "这是一份血常规检验报告，请分析各项血液指标。重点关注血红蛋白、白细胞、血小板等核心指标。"
    "liver_function" => "这是一份肝功能检验报告，请分析肝脏相关指标。重点关注转氨酶、胆红素等指标。"
    "kidney_function" => "这是一份肾功能检验报告，请分析肾脏相关指标。重点关注肌酐、尿素氮、尿酸等指标。"
    "blood_glucose" => "这是一份血糖检验报告，请分析血糖相关指标。重点关注空腹血糖、糖化血红蛋白等指标。"
    "blood_lipid" => "这是一份血脂检验报告，请分析血脂相关指标。重点关注总胆固醇、甘油三酯等指标。"
    "thyroid" => "这是一份甲状腺功能检验报告，请分析甲状腺相关指标。重点关注TSH、T3、T4等指标。"
    "urine_routine" => "这是一份尿常规检验报告，请分析尿液相关指标。"
    _ => "这是一份医疗检验报告，请分析报告内容。"
  }
  
  "你是一位专业的医疗报告解读助手。请用通俗易懂的语言解读以下医疗报告，帮助患者家属理解报告内容。\n\n" +
  type_instruction + "\n\n" +
  "报告内容：\n" + report_content + "\n\n" +
  "请提供以下内容：\n" +
  "1. 整体健康评估摘要（用一两句话概括）\n" +
  "2. 各项指标的解释（包括正常范围和当前状态，用通俗语言解释每项指标的含义）\n" +
  "3. 需要关注的异常指标（如果有）\n" +
  "4. 建议的后续行动（如复查、就医等）\n\n" +
  "重要提示：\n" +
  "- 请使用简单易懂的语言，避免过多专业术语\n" +
  "- 如果指标异常，请解释可能的原因\n" +
  "- 本解读仅供参考，不作为医疗诊断依据\n" +
  "- 如有疑问，请咨询专业医生"
}

pub fn format_api_request(config : MedGemmaConfig, prompt : String) -> String {
  let request = #{
    "model": config.model,
    "messages": [
      #{
        "role": "system",
        "content": "你是一位专业的医疗报告解读助手，擅长用通俗易懂的语言解释医疗检验报告。你的目标受众是普通患者家属，他们可能没有医学背景。请用简单、亲切、专业的语言进行解读。"
      },
      #{
        "role": "user",
        "content": prompt
      }
    ],
    "temperature": 0.3,
    "max_tokens": 2000,
    "top_p": 0.9
  }
  request.to_json()
}

pub struct APIRequest {
  endpoint : String
  method : String
  headers : Map<String, String>
  body : String
}

pub fn APIRequest::post(url : String, body : String) -> APIRequest {
  let mut headers = Map::new()
  headers.set("Content-Type", "application/json")
  
  APIRequest::{
    endpoint: url,
    method: "POST",
    headers,
    body
  }
}

pub fn APIRequest::with_header(self : APIRequest, key : String, value : String) -> APIRequest {
  let mut new_headers = self.headers
  new_headers.set(key, value)
  { ..self, headers: new_headers }
}

pub fn APIRequest::with_auth(self : APIRequest, token : String) -> APIRequest {
  self.with_header("Authorization", "Bearer " + token)
}

pub fn parse_api_response(json_str : String) -> Result<@types.APIResponse, @types.MedGemmaError> {
  let json_result = json_str.parse_json()
  
  match json_result {
    Err(_) => Err(@types.MedGemmaError::ParseError("无法解析API响应"))
    Ok(json) => {
      let choices = json.get("choices")
      match choices {
        None => Err(@types.MedGemmaError::ParseError("响应格式错误：缺少choices"))
        Some(arr) => {
          if arr.length() == 0 {
            Err(@types.MedGemmaError::ParseError("响应格式错误：choices为空"))
          } else {
            let first_choice = arr[0]
            let message = first_choice.get("message")
            match message {
              None => Err(@types.MedGemmaError::ParseError("响应格式错误：缺少message"))
              Some(msg) => {
                let content = msg.get("content")
                match content {
                  None => Err(@types.MedGemmaError::ParseError("响应格式错误：缺少content"))
                  Some(c) => Ok(@types.APIResponse::success(c.to_string()))
                }
              }
            }
          }
        }
      }
    }
  }
}

pub fn parse_error_response(json_str : String) -> @types.MedGemmaError {
  let json_result = json_str.parse_json()
  
  match json_result {
    Err(_) => @types.MedGemmaError::ParseError("无法解析错误响应")
    Ok(json) => {
      let error = json.get("error")
      match error {
        None => @types.MedGemmaError::APIError(500, "未知错误")
        Some(err) => {
          let code = err.get("code")
          let message = err.get("message")
          match (code, message) {
            (Some(c), Some(m)) => @types.MedGemmaError::APIError(c.to_int(), m.to_string())
            _ => @types.MedGemmaError::APIError(500, "未知错误")
          }
        }
      }
    }
  }
}

pub struct AnalysisOptions {
  include_recommendations : Bool
  include_warnings : Bool
  detail_level : String
  language : String
}

pub fn AnalysisOptions::default() -> AnalysisOptions {
  AnalysisOptions::{
    include_recommendations: true,
    include_warnings: true,
    detail_level: "normal",
    language: "zh-CN"
  }
}

pub fn AnalysisOptions::detailed(self : AnalysisOptions) -> AnalysisOptions {
  { ..self, detail_level: "detailed" }
}

pub fn AnalysisOptions::brief(self : AnalysisOptions) -> AnalysisOptions {
  { ..self, detail_level: "brief" }
}

pub fn AnalysisOptions::in_language(self : AnalysisOptions, lang : String) -> AnalysisOptions {
  { ..self, language: lang }
}
