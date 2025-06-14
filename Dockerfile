FROM python:3.12-slim

# Criar grupo e usuário para rodar a aplicação (não root)
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y \
    gcc python3-dev libexpat1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install Django uwsgi

COPY . /app

# Rodar collectstatic como root (para evitar problemas de permissão)
RUN python manage.py collectstatic --noinput

# Ajustar dono para usuário não-root
RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 9001

CMD ["uwsgi", "--ini", "uwsgi.ini"]
