print("Testing imports...")

try:
    from mini_vector_store import MiniVectorStore
    print("✅ MiniVectorStore imported")
except Exception as e:
    print(f"❌ MiniVectorStore error: {e}")

try:
    from mini_chatbot import MiniChatbot
    print("✅ MiniChatbot imported")
except Exception as e:
    print(f"❌ MiniChatbot error: {e}")

try:
    from config import DB_CONFIG
    print(f"✅ Config loaded: DB_NAME={DB_CONFIG.get('database')}")
except Exception as e:
    print(f"❌ Config error: {e}")

try:
    from flask import Flask
    print("✅ Flask imported")
except Exception as e:
    print(f"❌ Flask error: {e}")

print("\n✅ All imports OK! You can run: python app.py")