# Usando imagem leve do NGINX
FROM nginx:alpine

# Copia arquivos do site para o diretório padrão do NGINX
COPY . /usr/share/nginx/html

# Expõe a porta
EXPOSE 80
