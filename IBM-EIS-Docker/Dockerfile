FROM node:latest

WORKDIR /usr/src/app

COPY . /usr/src/app

WORKDIR Node-DC-EIS-master/Node-DC-EIS-cluster

RUN npm install

EXPOSE 9000

CMD ["node", "server-cluster.js"]
