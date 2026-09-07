FROM python:3.11-slim

ARG ADAS_COMMIT=2702bee8fefda42255efc5be9f60e3bd3db96ae4

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/adas

# Fetch a pinned source archive directly. No git clone and no moving upstream main.
RUN curl -fsSL "https://github.com/ShengranHu/ADAS/archive/${ADAS_COMMIT}.tar.gz" \
    | tar -xz --strip-components=1

RUN pip install --no-cache-dir -r requirements.txt

COPY beans /opt/adas/_beans

WORKDIR /opt/adas/_beans
ENV PYTHONUNBUFFERED=1
ENV RESULTS_DIR=/work/results
ENV META_MODEL=gpt-5.6-terra
ENV EVAL_MODEL=gpt-5.6-luna
ENV JUDGE_MODEL=gpt-5.6-luna

CMD ["python", "run.py"]
