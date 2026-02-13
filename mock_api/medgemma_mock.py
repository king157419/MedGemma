"""
MedGemma Mock API Server
模拟 MedGemma 模型 API 服务，用于开发和测试
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import uvicorn
import json

app = FastAPI(title="MedGemma Mock API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Message(BaseModel):
    role: str
    content: str

class ChatRequest(BaseModel):
    model: str
    messages: List[Message]
    temperature: float = 0.3
    max_tokens: int = 2000
    top_p: float = 0.9

class ChatChoice(BaseModel):
    index: int
    message: Message
    finish_reason: str

class ChatResponse(BaseModel):
    id: str
    object: str
    choices: List[ChatChoice]
    model: str

def generate_medical_response(user_content: str) -> str:
    """生成模拟的医疗报告解读"""
    
    if "血常规" in user_content:
        return """
【整体健康评估摘要】
根据您的血常规检验结果，各项指标均在正常范围内，整体血液健康状况良好。

【各项指标解释】

1. 血红蛋白 (145 g/L) - 正常范围 120-160 g/L
   ✅ 正常
   解读：血红蛋白是血液中携带氧气的蛋白质，您的数值在正常范围内，说明血液携氧能力正常。

2. 红细胞 (4.8 T/L) - 正常范围 4.0-5.5 T/L
   ✅ 正常
   解读：红细胞负责运输氧气，您的数值正常。

3. 白细胞 (7.5 G/L) - 正常范围 4.0-10.0 G/L
   ✅ 正常
   解读：白细胞是身体的免疫细胞，您的数值正常，说明免疫系统功能良好。

4. 血小板 (220 G/L) - 正常范围 100-300 G/L
   ✅ 正常
   解读：血小板参与血液凝固，您的数值正常。

【需要关注的指标】
暂无异常指标需要特别关注。

【建议】
• 保持健康的生活方式，均衡饮食
• 适量运动，保证充足睡眠
• 建议每年进行一次体检

📌 重要提示：本解读仅供参考，不作为医疗诊断依据。如有健康问题，请咨询专业医生。
"""
    elif "肝功能" in user_content:
        return """
【整体健康评估摘要】
根据您的肝功能检验结果，各项指标均在正常范围内，肝脏功能状态良好。

【各项指标解释】

1. 谷丙转氨酶(ALT) (25 U/L) - 正常范围 0-40 U/L
   ✅ 正常
   解读：ALT主要存在于肝细胞中，是肝脏健康的重要指标。您的数值正常。

2. 谷草转氨酶(AST) (22 U/L) - 正常范围 0-40 U/L
   ✅ 正常
   解读：AST存在于肝脏、心脏等组织中，您的数值正常。

3. 总胆红素 (12.5 umol/L) - 正常范围 3.4-17.1 umol/L
   ✅ 正常
   解读：胆红素是胆汁的主要成分，您的数值正常。

【建议】
• 避免过量饮酒
• 保持规律作息
• 均衡饮食，少油腻食物

📌 重要提示：本解读仅供参考，不作为医疗诊断依据。
"""
    elif "肾功能" in user_content:
        return """
【整体健康评估摘要】
根据您的肾功能检验结果，各项指标均在正常范围内，肾脏过滤功能良好。

【各项指标解释】

1. 肌酐 (98 umol/L) - 正常范围 44-133 umol/L
   ✅ 正常
   解读：肌酐是肌肉代谢的产物，通过肾脏排出。您的数值正常，说明肾脏过滤功能良好。

2. 尿素氮 (6.5 mmol/L) - 正常范围 2.9-8.2 mmol/L
   ✅ 正常
   解读：尿素氮是蛋白质代谢的产物，您的数值正常。

3. 尿酸 (380 umol/L) - 正常范围 150-420 umol/L
   ✅ 正常
   解读：尿酸是嘌呤代谢的产物，您的数值在正常范围内。

【建议】
• 多喝水，保持充足水分
• 减少高嘌呤食物摄入（如动物内脏、海鲜）
• 适量运动

📌 重要提示：本解读仅供参考，不作为医疗诊断依据。
"""
    else:
        return """
【整体健康评估摘要】
根据您提供的检验报告，已进行初步分析。

【建议】
• 如有疑问，请咨询专业医生
• 定期进行体检

📌 重要提示：本解读仅供参考，不作为医疗诊断依据。
"""

@app.post("/v1/chat/completions")
async def chat_completions(request: ChatRequest):
    """处理聊天完成请求"""
    
    user_message = ""
    for msg in request.messages:
        if msg.role == "user":
            user_message = msg.content
            break
    
    response_content = generate_medical_response(user_message)
    
    return ChatResponse(
        id="chatcmpl-mock-" + str(hash(user_message) % 10000),
        object="chat.completion",
        choices=[
            ChatChoice(
                index=0,
                message=Message(
                    role="assistant",
                    content=response_content
                ),
                finish_reason="stop"
            )
        ],
        model=request.model
    )

@app.get("/health")
async def health():
    """健康检查端点"""
    return {"status": "healthy", "model": "medgemma-mock"}

@app.get("/")
async def root():
    """根端点"""
    return {
        "message": "MedGemma Mock API Server",
        "version": "1.0.0",
        "endpoints": {
            "chat": "/v1/chat/completions",
            "health": "/health"
        }
    }

if __name__ == "__main__":
    print("=" * 60)
    print("  MedGemma Mock API Server")
    print("  医疗报告解读模拟服务")
    print("=" * 60)
    print()
    print("  服务地址: http://localhost:8000")
    print("  API文档: http://localhost:8000/docs")
    print()
    print("  按 Ctrl+C 停止服务")
    print("=" * 60)
    
    uvicorn.run(app, host="0.0.0.0", port=8000)
