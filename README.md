# Laravel Lightweight CMS

A clean and beginner-friendly content management system built with **Laravel 12** and **Filament 4**, featuring a modern frontend powered by **Tailwind CSS, DaisyUI, and Lucide Icons**.  
Designed as a practical starter project and reference implementation for developers learning Laravel-based CMS development.

---

## Overview

This project provides a minimal yet functional CMS with an elegant admin panel and a simple editorial-style frontend. It is suitable for blogs, documentation sites, and small content-focused applications.

### Core Features

- Admin Panel powered by Filament
- Articles & Pages management
- Categories for content organization
- Media Library using Spatie Media Library
- Admin and Editor roles
- Article view analytics
- Modern UI with Tailwind CSS, DaisyUI, and Lucide icons

---

## Requirements
- Docker
- PHP 8.3+
- Composer
- Node.js 18+
- npm or yarn

---

## Download & Installation

### Download

Clone the repository from GitHub:

```bash
git clone https://github.com/sathishocs/Laravel-12-Filament-CMS-Back-office-and-website-Demo.git
cd Laravel-12-Filament-CMS-Back-office-and-website-Demo
```

Or download the ZIP directly from GitHub using **Code → Download ZIP**.

---

### Setup

```bash
composer install
npm install

cp .env.example .env
php artisan key:generate
```

### Database

```bash
php artisan migrate
php artisan db:seed
```

---

### Storage & Assets

```bash
php artisan storage:link
npm run dev
php artisan serve
```

---

## Usage

- Admin Panel: `/admin`
- Admin: Full access
- Editor: Content management only

---

## Frontend Routes

| Route | Description |
|-----|------------|
| `/` | Homepage |
| `/articles` | Article listing |
| `/article/{slug}` | Single article |
| `/category/{slug}` | Category articles |
| `/page/{slug}` | Static page |

---

## Developer

**Sathish**  
GitHub: https://github.com/sathishocs  

---

## License

MIT License