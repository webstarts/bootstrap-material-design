FROM node:18-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    openjdk-17-jre-headless \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work

RUN npm install -g bower grunt-cli

COPY package.json package-lock.json* ./
# Legacy PhantomJS dependency has no arm64 binary; skip install scripts for containerized dev builds.
RUN npm install --ignore-scripts

COPY . .

EXPOSE 9001
CMD ["sh", "-lc", "bower install --allow-root && grunt serve"]
