# CVE Course with ECG

A comprehensive educational platform for learning about Common Vulnerabilities and Exposures (CVE) integrated with Electrocardiogram (ECG) analysis for medical device security.

## 🚀 Quick Start

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/Drmcoelho/CVE.git
   cd CVE
   ```

2. **Option A: Direct file serving**
   - Open `index.html` in your web browser
   - Or use a simple HTTP server:
   ```bash
   python -m http.server 8000
   # Visit http://localhost:8000
   ```

3. **Option B: Docker deployment**
   ```bash
   ./deploy.sh run
   # Visit http://localhost:8080
   ```

## 🐳 Docker Deployment

### Prerequisites
- Docker installed on your system
- Docker Compose (optional, for advanced deployment)

### Build and Run

1. **Using the deployment script (recommended)**
   ```bash
   ./deploy.sh build    # Build the Docker image
   ./deploy.sh run      # Run the application
   ./deploy.sh health   # Check application health
   ```

2. **Manual Docker commands**
   ```bash
   docker build -t cve-course .
   docker run -d -p 8080:80 --name cve-app cve-course
   ```

3. **Using Docker Compose**
   ```bash
   docker-compose up -d
   ```

### Deployment Options

The deployment script supports various commands:

```bash
./deploy.sh [COMMAND] [OPTIONS]

Commands:
  build       Build Docker image
  run         Run the application  
  deploy      Deploy with docker-compose
  stop        Stop the application
  logs        Show application logs
  health      Run health check
  cleanup     Clean up Docker resources

Options:
  -e, --env       Environment (development|production)
  -p, --port      Port to run on [default: 8080]
  -n, --name      Container name [default: cve-course-app]
```

## 🏗️ Architecture

The application is built with:

- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Web Server**: Nginx (Alpine Linux)
- **Containerization**: Docker
- **Orchestration**: Docker Compose
- **CI/CD**: GitHub Actions

### Project Structure

```
CVE/
├── index.html          # Main application file
├── styles.css          # Application styles
├── script.js           # Application logic
├── Dockerfile          # Docker image configuration
├── docker-compose.yml  # Docker Compose configuration
├── nginx.conf          # Nginx server configuration
├── deploy.sh           # Deployment script
├── .github/
│   └── workflows/
│       └── deploy.yml  # CI/CD pipeline
└── README.md           # This file
```

## 🔧 Configuration

### Environment Variables

The application supports the following environment variables:

- `NGINX_HOST`: Server hostname (default: localhost)
- `NGINX_PORT`: Internal nginx port (default: 80)

### Nginx Configuration

The application uses a custom Nginx configuration with:

- Gzip compression enabled
- Security headers configured
- Static asset caching
- Health check endpoint (`/health`)
- Error page handling

## 🚦 Health Monitoring

The application includes a health check endpoint:

```bash
curl http://localhost:8080/health
# Response: healthy
```

Docker health checks are configured to monitor application status.

## 🔐 Security Features

- Content Security Policy (CSP) headers
- X-Frame-Options protection
- XSS protection headers
- Content type sniffing protection
- Referrer policy configuration

## 📊 Monitoring and Logging

- Nginx access logs: `/var/log/nginx/access.log`
- Nginx error logs: `/var/log/nginx/error.log`
- Application logs accessible via: `docker logs cve-course-app`

## 🚀 Production Deployment

### Cloud Deployment Options

1. **AWS ECS/Fargate**
   ```bash
   # Tag and push to ECR
   docker tag cve-course:latest your-account.dkr.ecr.region.amazonaws.com/cve-course:latest
   docker push your-account.dkr.ecr.region.amazonaws.com/cve-course:latest
   ```

2. **Google Cloud Run**
   ```bash
   # Build and deploy
   gcloud builds submit --tag gcr.io/your-project/cve-course
   gcloud run deploy --image gcr.io/your-project/cve-course --port 80
   ```

3. **Azure Container Instances**
   ```bash
   # Create container group
   az container create --resource-group myResourceGroup --name cve-course --image cve-course:latest
   ```

4. **Kubernetes**
   ```yaml
   # deployment.yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: cve-course
   spec:
     replicas: 3
     selector:
       matchLabels:
         app: cve-course
     template:
       metadata:
         labels:
           app: cve-course
       spec:
         containers:
         - name: cve-course
           image: cve-course:latest
           ports:
           - containerPort: 80
   ```

### SSL/HTTPS Configuration

For production deployments, configure SSL certificates:

1. **Let's Encrypt with Certbot** (recommended)
2. **AWS Certificate Manager** (for AWS deployments)
3. **Custom SSL certificates**

## 🧪 Testing

The CI/CD pipeline includes:

- HTML validation
- CSS linting
- Docker build testing
- Security scanning with Trivy
- Health check validation

Run tests locally:
```bash
# Install dependencies
npm init -y
npm install -D html-validate stylelint

# Run tests
npx html-validate index.html
npx stylelint styles.css
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and ensure they pass
5. Submit a pull request

## 📄 License

This project is for educational purposes only.

## 🆘 Troubleshooting

### Common Issues

1. **Port already in use**
   ```bash
   ./deploy.sh stop
   ./deploy.sh run -p 3000  # Use different port
   ```

2. **Docker build fails**
   ```bash
   docker system prune -f  # Clean up Docker resources
   ./deploy.sh cleanup
   ./deploy.sh build
   ```

3. **Health check fails**
   ```bash
   ./deploy.sh logs  # Check application logs
   docker exec -it cve-course-app /bin/sh  # Access container shell
   ```

### Support

For issues and questions, please check the repository's issue tracker or contact the maintainers.

---

**Made with ❤️ for cybersecurity and medical device education**
