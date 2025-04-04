# FastAPI 앱용 Dockerfile
FROM python:3.12.7

# 작업 디렉토리
WORKDIR /app

# 필요한 파일 복사
COPY ./main.py /app/
COPY ./requirements.txt /app/
COPY ./com /app/com

# 의존성 설치
RUN pip install --no-cache-dir -r requirements.txt

# FastAPI 실행 명령
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
