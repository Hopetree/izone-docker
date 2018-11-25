FROM python:3.5
ENV PYTHONUNBUFFERED=1
RUN mkdir -p /app/izone
WORKDIR /app/izone
COPY ./izone .
RUN pip install -r requirements.txt -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
