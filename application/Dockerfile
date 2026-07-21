# Usa uma imagem oficial do Python 3.12 na versão "slim" (Debian enxuto).
# Reduz o tamanho da imagem final e a superfície de ataque para segurança.
FROM python:3.12-slim

# Define o diretório de trabalho onde as instruções seguintes serão executadas dentro do container.
WORKDIR /app

# Evita que o Python escreva arquivos .pyc (bytecode) no disco do container.
ENV PYTHONDONTWRITEBYTECODE=1

# Garante que os logs do Python sejam enviados diretamente para o stdout/stderr (tela/logs)
# sem ficar retidos em buffer. Essencial para coleta de logs no Kubernetes/Docker.
ENV PYTHONUNBUFFERED=1

# Copia apenas o arquivo de dependências primeiro.
# Isso aproveita o sistema de cache por camadas do Docker: se o requirements.txt não mudar,
# a camada de instalação das dependências abaixo não precisa rodar novamente no build.
COPY requirements.txt .

# Atualiza o gerenciador de pacotes 'pip' e instala as bibliotecas do projeto.
# O '--no-cache-dir' evita salvar arquivos temporários de instalação, mantendo a imagem leve.
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copia o código-fonte da aplicação Flask para dentro do container.
COPY app.py .

# Cria um grupo e um usuário de sistema sem privilégios administrativos (sem root).
RUN addgroup --system appgroup \
    && adduser --system --ingroup appgroup appuser

# Alterna para o usuário não-root criado acima.
# Princípio do menor privilégio: impede que um atacante ganhe acesso root no host caso a app seja vulnerável.
USER appuser

# Documenta que a aplicação dentro do container escuta na porta 8080.
# (Serve como documentação/metadado e não expõe a porta na rede por si só).
EXPOSE 8080

# Configura a verificação de saúde (Health Check) do container.
# Permite que o Docker (e orquestradores) saibam se a aplicação está realmente pronta para responder.
#
# Parâmetros:
# --interval=30s     : Executa o teste a cada 30 segundos.
# --timeout=5s      : Aguarda no máximo 5 segundos pela resposta do teste antes de considerar falha.
# --start-period=10s: Janela inicial de 10 segundos para a aplicação subir sem contar falhas (tempo de boot).
# --retries=3       : Exige 3 falhas consecutivas para alterar o status do container para 'unhealthy' (não saudável).
#
# Comando (CMD):
# Usa um mini-script Python sem dependências externas para fazer um GET na porta 8080/health.
# Se o endpoint responder HTTP 200, retorna código 0 (sucesso).
# Se falhar ou der erro de rede, o '|| exit 1' garante o retorno de código 1 (falha no health check).
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')" || exit 1

# Comando padrão executado ao iniciar o container.
# Inicia o servidor WSGI de produção (Gunicorn) binding na porta 8080 com 2 workers e 2 threads.
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--threads", "2", "--timeout", "30", "app:app"]