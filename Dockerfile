FROM ghcr.io/cirruslabs/flutter:stable

ENV PUB_CACHE=/app/.pub-cache
ENV FLUTTER_ALLOW_LOCAL_ENGINE_IN_RELEASE=true

WORKDIR /app

# Copia arquivos do pubspec primeiro
COPY pubspec.* ./

# Baixa as dependências
RUN flutter pub get || true

# Copia o restante do projeto
COPY . .

# Roda pub get novamente para garantir tudo atualizado
RUN flutter pub get

# Exponha a porta 8080 para acessar via navegador
EXPOSE 8080

# Roda o app no servidor web
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]
