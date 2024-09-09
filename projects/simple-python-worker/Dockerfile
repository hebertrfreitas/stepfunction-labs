FROM python:3.12-slim

RUN apt update && apt install gcc python3-dev curl procps -y

WORKDIR /app

RUN pip install --no-cache-dir poetry

# Copy the pyproject.toml and poetry.lock files into the container
COPY pyproject.toml poetry.lock ./

RUN poetry install --no-root

COPY simple_python_worker .

ENTRYPOINT ["poetry", "run", "python", "main.py"]