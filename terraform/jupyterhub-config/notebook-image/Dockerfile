FROM daskdev/dask-notebook


RUN conda init
COPY prefect-py36_enviroment.yaml ./

RUN conda env update -f prefect-py36_enviroment.yaml && \
    source activate prefect-py36 && \
    python -m ipykernel install --user --name prefect-py36 --display-name "Prefect py36" && \
    prefect backend server
