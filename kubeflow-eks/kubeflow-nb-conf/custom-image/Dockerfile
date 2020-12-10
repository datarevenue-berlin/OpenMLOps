ARG BASE_CONTAINER=jupyter/datascience-notebook
FROM $BASE_CONTAINER

LABEL maintainer="pedro@datarevenue.com"
LABEL version="0.0.1"

COPY .libs ./libs/
RUN pip install --upgrade pip
RUN pip install kfp --upgrade
RUN pip install taclib --find-links ./libs


ENV NB_PREFIX /

CMD ["sh","-c", "jupyter notebook --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]