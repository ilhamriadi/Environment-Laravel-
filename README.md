# Laravel Docker dengan Nginx - Auto Deployment

Setup Docker lengkap untuk Laravel dengan Nginx, MySQL, dan phpMyAdmin. Mendukung deployment otomatis dari GitHub repository.

## 🚀 Quick Start

### 1. Deployment Lokal (Tanpa GitHub)
```bash
# Clone atau download project ini
git clone <your-docker-setup-repo>
cd <project-directory>

# Jalankan deployment script
chmod +x deploy.sh
./deploy.sh
```

### 2. Deployment dari GitHub Repository
```bash
# Deploy dengan GitHub integration
./deploy.sh username/laravel-repo main ghp_your_github_token

# Contoh:
./deploy.sh johndoe/my-laravel-app main ghp_xxxxxxxxxxxxxxxxxxxx
```

## 📋 Struktur Project

```
project/
├── docker/
│   ├── nginx/
│   │   └── nginx.conf
│   └── php/
│       ├── Dockerfile
│       ├── init.sh
│       ├── php.ini
│       └── opcache.ini
├── laravel_app/          # Laravel code akan ada di sini
├── docker-compose.yml
├── .env.example
├── deploy.sh
└── README.md
```

## 🛠 Konfigurasi Manual

### 1. Setup Environment
```bash
# Copy template environment
cp .env.example .env

# Edit sesuai kebutuhan
nano .env
```

### 2. Konfigurasi GitHub Deployment (Opsional)
Tambahkan ke file `.env`:
```env
GITHUB_REPO=username/repository-name
GITHUB_BRANCH=main
GITHUB_TOKEN=ghp_your_personal_access_token
```

### 3. Jalankan Container
```bash
docker-compose up --build -d
```

## 🌐 URL Akses

- **Laravel App**: http://localhost:8031
- **phpMyAdmin**: http://localhost:8032
- **MySQL**: localhost:3307

## 🔑 Kredensial Database

- **Host**: localhost (atau `mysql` dari dalam container)
- **Port**: 3307 (eksternal) / 3306 (internal)
- **Database**: laravel_
