FROM ghcr.io/cirruslabs/flutter:stable

ENV PUB_CACHE=/app/.pub-cache
ENV FLUTTER_ALLOW_LOCAL_ENGINE_IN_RELEASE=true

WORKDIR /app

# Copia os arquivos de dependências primeiro
COPY pubspec.* ./

# Baixa as dependências
RUN flutter pub get

# Copia o restante do projeto
COPY . .

# Garante que dependências estão atualizadas
RUN flutter pub get

# Exponha a porta usada pelo servidor web
EXPOSE 8080

# Comando padrão: roda o app no web-server
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]
