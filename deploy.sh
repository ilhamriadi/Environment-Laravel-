#!/bin/bash

# Laravel Docker Deployment Script
# Usage: ./deploy.sh [github-repo] [branch] [github-token]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists docker; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command_exists docker-compose; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_success "All prerequisites are met."
}

# Function to setup environment file
setup_env() {
    print_status "Setting up environment file..."
    
    if [ ! -f .env ]; then
        if [ -f .env.example ]; then
            cp .env.example .env
            print_success "Created .env from .env.example"
        else
            print_warning ".env.example not found. Creating basic .env file..."
            cat > .env << EOF
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8031

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel
DB_PASSWORD=secret

MYSQL_ROOT_PASSWORD=root
USER_ID=1000
GROUP_ID=1000
EOF
        fi
    else
        print_success ".env file already exists"
    fi
    
    # Setup GitHub deployment variables if provided
    if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]; then
        print_status "Configuring GitHub deployment..."
        
        # Update or add GitHub variables to .env
        grep -q "^GITHUB_REPO=" .env && sed -i "s|^GITHUB_REPO=.*|GITHUB_REPO=$1|" .env || echo "GITHUB_REPO=$1" >> .env
        grep -q "^GITHUB_BRANCH=" .env && sed -i "s|^GITHUB_BRANCH=.*|GITHUB_BRANCH=$2|" .env || echo "GITHUB_BRANCH=$2" >> .env
        grep -q "^GITHUB_TOKEN=" .env && sed -i "s|^GITHUB_TOKEN=.*|GITHUB_TOKEN=$3|" .env || echo "GITHUB_TOKEN=$3" >> .env
        
        print_success "GitHub deployment configured for repo: $1, branch: $2"
    fi
}

# Function to create necessary directories
create_directories() {
    print_status "Creating necessary directories..."
    
    mkdir -p laravel_app
    mkdir -p docker/php
    mkdir -p docker/nginx
    
    print_success "Directories created successfully"
}

# Function to build and start containers
deploy_containers() {
    print_status "Building and starting containers..."
    
    # Stop existing containers if running
    docker-compose down --remove-orphans 2>/dev/null || true
    
    # Build and start containers
    docker-compose up --build -d
    
    print_success "Containers started successfully"
}

# Function to wait for application to be ready
wait_for_app() {
    print_status "Waiting for application to be ready..."
    
    max_attempts=60
    attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s http://localhost:8031 >/dev/null 2>&1; then
            print_success "Application is ready!"
            return 0
        fi
        
        echo -n "."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    print_warning "Application might not be fully ready yet. Check logs with: docker-compose logs -f"
}

# Function to display deployment info
show_deployment_info() {
    echo
    print_success "🎉 Deployment completed successfully!"
    echo
    echo "📋 Application URLs:"
    echo "   • Laravel App: http://localhost:8031"
    echo "   • phpMyAdmin:  http://localhost:8032"
    echo
    echo "📊 Database Info:"
    echo "   • Host: localhost"
    echo "   • Port: 3307"
    echo "   • Database: laravel_db"
    echo "   • Username: laravel"
    echo "   • Password: secret"
    echo
    echo "🔧 Useful Commands:"
    echo "   • View logs:        docker-compose logs -f"
    echo "   • Restart:          docker-compose restart"
    echo "   • Stop:             docker-compose down"
    echo "   • Enter app:        docker-compose exec app bash"
    echo "   • Run artisan:      docker-compose exec app php artisan [command]"
    echo
}

# Function to show help
show_help() {
    echo "Laravel Docker Deployment Script"
    echo
    echo "Usage:"
    echo "  ./deploy.sh                                    # Deploy without GitHub integration"
    echo "  ./deploy.sh [repo] [branch] [token]           # Deploy with GitHub integration"
    echo
    echo "Examples:"
    echo "  ./deploy.sh"
    echo "  ./deploy.sh username/my-laravel-app main ghp_xxxxxxxxxxxx"
    echo
    echo "Parameters:"
    echo "  repo    - GitHub repository (username/repository-name)"
    echo "  branch  - Git branch to deploy (default: main)"
    echo "  token   - GitHub Personal Access Token"
    echo
}

# Main function
main() {
    echo "🚀 Laravel Docker Deployment"
    echo "=============================="
    
    # Show help if requested
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_help
        exit 0
    fi
    
    # Validate GitHub deployment parameters
    if [ -n "$1" ] && ([ -z "$2" ] || [ -z "$3" ]); then
        print_error "For GitHub deployment, you must provide all three parameters: repo, branch, and token"
        show_help
        exit 1
    fi
    
    # Run deployment steps
    check_prerequisites
    create_directories
    setup_env "$1" "$2" "$3"
    deploy_containers
    wait_for_app
    show_deployment_info
}

# Run main function with all arguments
main "$@"
