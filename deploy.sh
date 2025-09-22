#!/bin/bash

# CVE Course Deployment Script
# This script provides various deployment options for the CVE course application

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
ENVIRONMENT="development"
PORT="8080"
IMAGE_NAME="cve-course"
CONTAINER_NAME="cve-course-app"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_warning "Docker Compose is not installed. Some features may not work."
    fi
}

# Function to build Docker image
build_image() {
    print_status "Building Docker image..."
    docker build -t $IMAGE_NAME:latest .
    print_status "Docker image built successfully!"
}

# Function to run the application
run_app() {
    print_status "Starting CVE Course application..."
    
    # Stop existing container if running
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true
    
    # Run new container
    docker run -d \
        --name $CONTAINER_NAME \
        -p $PORT:80 \
        --restart unless-stopped \
        $IMAGE_NAME:latest
    
    print_status "Application is running at http://localhost:$PORT"
    print_status "Health check available at http://localhost:$PORT/health"
}

# Function to deploy with docker-compose
deploy_compose() {
    print_status "Deploying with Docker Compose..."
    
    if [ "$ENVIRONMENT" = "production" ]; then
        docker-compose --profile production up -d
    else
        docker-compose up -d
    fi
    
    print_status "Application deployed successfully!"
}

# Function to stop the application
stop_app() {
    print_status "Stopping CVE Course application..."
    
    if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        docker stop $CONTAINER_NAME
        docker rm $CONTAINER_NAME
        print_status "Application stopped successfully!"
    else
        print_warning "No running container found."
    fi
}

# Function to show logs
show_logs() {
    if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        docker logs -f $CONTAINER_NAME
    else
        print_error "Container is not running."
        exit 1
    fi
}

# Function to run health check
health_check() {
    print_status "Running health check..."
    
    if curl -f http://localhost:$PORT/health &>/dev/null; then
        print_status "Health check passed! Application is healthy."
    else
        print_error "Health check failed! Application may not be running or healthy."
        exit 1
    fi
}

# Function to clean up Docker resources
cleanup() {
    print_status "Cleaning up Docker resources..."
    
    # Stop and remove container
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true
    
    # Remove image
    docker rmi $IMAGE_NAME:latest 2>/dev/null || true
    
    # Clean up unused resources
    docker system prune -f
    
    print_status "Cleanup completed!"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  build       Build Docker image"
    echo "  run         Run the application"
    echo "  deploy      Deploy with docker-compose"
    echo "  stop        Stop the application"
    echo "  logs        Show application logs"
    echo "  health      Run health check"
    echo "  cleanup     Clean up Docker resources"
    echo "  help        Show this help message"
    echo ""
    echo "Options:"
    echo "  -e, --env       Environment (development|production) [default: development]"
    echo "  -p, --port      Port to run on [default: 8080]"
    echo "  -n, --name      Container name [default: cve-course-app]"
    echo ""
    echo "Examples:"
    echo "  $0 build"
    echo "  $0 run -p 3000"
    echo "  $0 deploy -e production"
    echo "  $0 health"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--env)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -n|--name)
            CONTAINER_NAME="$2"
            shift 2
            ;;
        build)
            COMMAND="build"
            shift
            ;;
        run)
            COMMAND="run"
            shift
            ;;
        deploy)
            COMMAND="deploy"
            shift
            ;;
        stop)
            COMMAND="stop"
            shift
            ;;
        logs)
            COMMAND="logs"
            shift
            ;;
        health)
            COMMAND="health"
            shift
            ;;
        cleanup)
            COMMAND="cleanup"
            shift
            ;;
        help|--help|-h)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Check if command is provided
if [ -z "$COMMAND" ]; then
    print_error "No command provided."
    show_usage
    exit 1
fi

# Main execution
print_status "CVE Course Deployment Script"
print_status "Environment: $ENVIRONMENT"
print_status "Port: $PORT"
print_status "Container: $CONTAINER_NAME"
echo ""

check_docker

case $COMMAND in
    build)
        build_image
        ;;
    run)
        build_image
        run_app
        ;;
    deploy)
        deploy_compose
        ;;
    stop)
        stop_app
        ;;
    logs)
        show_logs
        ;;
    health)
        health_check
        ;;
    cleanup)
        cleanup
        ;;
    *)
        print_error "Unknown command: $COMMAND"
        show_usage
        exit 1
        ;;
esac