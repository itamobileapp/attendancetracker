FROM python:3.9.1
EXPOSE 5000
ADD . /python-itamobileapp
WORKDIR /python-itamobileapp
COPY requirements.txt /python-itamobileapp
RUN pip install -r requirements.txt
COPY restful_apis.py /python-itamobileapp
CMD python restful_apis.py
