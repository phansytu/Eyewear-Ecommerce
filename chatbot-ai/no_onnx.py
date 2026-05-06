# no_onnx.py - Chạy file này TRƯỚC app.py
import os
os.environ["DISABLE_ONNX_PRECOMPILED"] = "1"
os.environ["HF_HUB_DISABLE_ONNX_DOWNLOADS"] = "1"
os.environ["TRANSFORMERS_OFFLINE"] = "1"

# Chặn tất cả các thư viện liên quan đến ONNX
import sys
sys.modules['optimum'] = None
sys.modules['optimum.onnxruntime'] = None
sys.modules['onnxruntime'] = None

print("✅ ONNX disabled completely")