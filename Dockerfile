# Use the official Node.js 20 image as the base image
FROM node:20
RUN chmod 1777 /tmp
# Install necessary dependencies for running Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    apt-transport-https \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update -y \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Set up the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port your app runs on
EXPOSE 8080

# Command to run the application

CMD [ "node", "src/index.js" ]