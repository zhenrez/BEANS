FROM python:3.11-slim

ARG ADAS_COMMIT=2702bee8fefda42255efc5be9f60e3bd3db96ae4

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/adas

# Fetch the pinned upstream ADAS source archive directly. No git clone.
RUN curl -fsSL "https://github.com/ShengranHu/ADAS/archive/${ADAS_COMMIT}.tar.gz" \
    | tar -xz --strip-components=1

RUN pip install --no-cache-dir -r requirements.txt

COPY beans /opt/adas/_beans
RUN python -m py_compile /opt/adas/_beans/app.py /opt/adas/_beans/main.py

WORKDIR /opt/adas/_beans
ENV PYTHONUNBUFFERED=1
ENV RESULTS_DIR=/work/results

EXPOSE 8765
CMD ["python", "main.py"]
