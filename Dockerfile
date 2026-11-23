FROM python:3.14.10-slim-bookworm@sha256:3fe1a0b6c2d6b2ebb572906cdabeca75aeb558c0c17db5ffefbcf8094871c32b

ENV UV_VERSION=0.13.7 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN python -m pip install --no-cache-dir "uv==${UV_VERSION}"

COPY pyproject.toml uv.lock .python-version README.md ./
COPY src/ ./src/
COPY tests/ ./tests/

RUN uv sync --locked

CMD ["uv", "run", "--locked", "pytest"]
