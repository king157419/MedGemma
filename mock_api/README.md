# MedGemma Mock API

模拟 MedGemma 模型 API 服务，用于开发和测试 MoonBit 医疗报告解读系统。

## 快速启动

```bash
# 安装依赖
pip install -r requirements.txt

# 启动服务
python medgemma_mock.py
```

服务将在 http://localhost:8000 启动。

## API 端点

| 端点 | 方法 | 描述 |
|------|------|------|
| `/v1/chat/completions` | POST | 聊天完成接口 |
| `/health` | GET | 健康检查 |
| `/docs` | GET | API文档 |

## 使用示例

```bash
curl -X POST http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "medgemma-4b",
    "messages": [
      {"role": "system", "content": "你是一位医疗报告解读助手"},
      {"role": "user", "content": "血常规检验报告..."}
    ]
  }'
```

## 支持的报告类型

- 血常规检验报告
- 肝功能检验报告
- 肾功能检验报告
- 其他医疗检验报告
