FROM continuumio/miniconda3

# docker build -t vanessa/watchme-mnist .
# docker push vanessa/watchme-mnist

RUN apt-get update && apt-get install -y git
RUN conda install scikit-learn matplotlib memory_profiler
RUN pip install watchme
ADD run.py /run.py
ENTRYPOINT ["python", "/run.py"]
