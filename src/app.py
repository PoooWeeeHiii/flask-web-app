
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    # 初始返回
    return "Hello, World!"

if __name__ == "__main__":
    # 开发环境运行；生产建议用 gunicorn 托管，这里按任务要求先用内置服务
    app.run(host="0.0.0.0", port=5000)
