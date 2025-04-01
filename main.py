import os
import uvicorn
from fastapi import FastAPI
from datetime import datetime
from fastapi.responses import HTMLResponse



##python -m uvicorn main:app --reload

app = FastAPI()

@app.get(path="/")
async def home():
    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return HTMLResponse(content=f"""
<body>
<div style="width: 400px; margin: 50 auto;">
    <h1> 천준영님 환영합니다</h1>
    <h2>{current_time}</h2>
</div>
</body>
""")

if __name__ == "__main__":

    port = int(os.getenv("PORT", 8000))  # Railway가 PORT 주입함. 없으면 기본값 8000
    uvicorn.run("main:app", host="0.0.0.0", port=port)
