# Stage 1: Build React frontend
FROM node:18 AS frontend-build
WORKDIR /app/frontend
COPY package*.json ./
RUN npm install
COPY .. .
RUN npm run build

# Stage 2: Build Python backend
FROM python:3.11-slim AS backend
WORKDIR /app

# Install backend dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend source
COPY .. .

# Copy built frontend into backend's static folder
COPY --from=frontend-build /app/frontend/build ./static

# Expose backend port
EXPOSE 8000

# Run backend server (adjust to your framework, e.g. Flask or FastAPI)
CMD ["python", "server.py"]
