# Use the official Python image from the Docker Hub
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory
WORKDIR /usr/src/app

# Install system dependencies and update ca-certificates
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && apt-get clean \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the container
COPY requirements.txt ./

# Upgrade pip and install dependencies with SSL verification disabled (temporary workaround)
RUN python -m pip install --upgrade pip --trusted-host pypi.org --trusted-host files.pythonhosted.org \
    && pip install --no-cache-dir -r requirements.txt --trusted-host pypi.org --trusted-host files.pythonhosted.org

RUN pip install grpcio-reflection

# Copy the rest of the application code into the container
COPY . .

# Copy the service account key file into the container
COPY serviceAccountKey.json /usr/src/app/

# Expose the port that the app runs on
EXPOSE 50051

# Run the application
CMD ["python", "greeter_server.py"]
