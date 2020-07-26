FROM node:12.2.0-alpine

# Create app directory
WORKDIR /usr/app

COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

EXPOSE 3000
ENTRYPOINT ["/bin/bash" , "-c", "source ./env.sh && printenv"]
CMD [ "node", "app.js" ]