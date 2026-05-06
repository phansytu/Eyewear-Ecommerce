import os
from dotenv import load_dotenv

load_dotenv()

# Database config
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': int(os.getenv('DB_PORT', 3306)),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', '240805'),
    'database': os.getenv('DB_NAME', 'eyewear_shop'),
    'charset': 'utf8mb4'
}

# Model config (optional)
MODEL_NAME = 'paraphrase-multilingual-MiniLM-L12-v2'