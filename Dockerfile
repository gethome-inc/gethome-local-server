# Use an official Node.js runtime as the base image
FROM node:16

# Set the working directory in the container to /app
WORKDIR /app

# Copy the built executable to the working directory
COPY app/gethome-server-linux /app/

# Make port 3010 available outside the container
EXPOSE 3010
EXPOSE 3011

# Start the application
CMD ["./gethome-server-linux"]
