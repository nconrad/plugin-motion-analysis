FROM waggle/plugin-base:1.1.1-ml

# RUN apt-get update \
#   && apt-get install -y \
#   && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/
RUN pip3 install --no-cache-dir --upgrade -r /app/requirements.txt

COPY app.py Classifiers.py TrainingSequence.py Utilities.py app.py /app/

ARG SAGE_STORE_URL="https://osn.sagecontinuum.org"
ARG BUCKET_ID_MODEL="3562bef2-735b-4a98-8b13-2206644bdb8e"

ENV SAGE_STORE_URL=${SAGE_STORE_URL} \
    BUCKET_ID_MODEL=${BUCKET_ID_MODEL}

RUN sage-cli.py storage files download ${BUCKET_ID_MODEL} tt_classifier_1fps.model --target /app/tt_classifier_1fps.model
RUN sage-cli.py storage files download ${BUCKET_ID_MODEL} tt_classifier_1fps.model --target /app/tt_classifier_5fps.model
RUN sage-cli.py storage files download ${BUCKET_ID_MODEL} tt_classifier_1fps.model --target /app/tt_classifier_50fps.model

WORKDIR /app
ENTRYPOINT ["python3", "-u", "/app/app.py"]
