FROM node:12.2.0-alpine

# Create app directory
WORKDIR /usr/app

COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

EXPOSE 3000
CMD [ "node", "app.js" ]