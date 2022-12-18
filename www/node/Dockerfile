FROM node:8.4.0

WORKDIR /app

RUN npm install express --save
RUN npm install pg

COPY . .

EXPOSE 3000
ENTRYPOINT ["node", "index.js"]
