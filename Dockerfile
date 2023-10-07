# Stage 1: Build the Nest.js application
FROM node:18 AS build

WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
COPY package*.json ./
RUN npm install

# Copy the rest of your application source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Create a production-ready image
FROM node:18

WORKDIR /app

# Copy the built application from the previous stage
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./package.json

# Expose the port your Nest.js application will run on
EXPOSE 3000

# Define the command to start your Nest.js application in production
CMD [ "node", "dist/main" ]
