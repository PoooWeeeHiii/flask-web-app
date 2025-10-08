
import unittest
import sys
from pathlib import Path

# 让解释器能找到 src 包（把项目根目录加入 sys.path）
sys.path.append(str(Path(__file__).parent.parent))

from src.app import app

class TestApp(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_hello_world(self):
        resp = self.client.get("/")
        self.assertEqual(resp.status_code, 200)
        self.assertEqual(resp.data.decode("utf-8"), "Hello, World!")

if __name__ == "__main__":
    unittest.main()
