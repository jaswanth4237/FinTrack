# FinTrack - Personal Finance & Budget Tracker

FinTrack is a robust, production-ready full-stack application designed to help users manage their personal finances with ease. It emphasizes an **offline-first** architecture, ensuring users can track expenses and manage budgets even without an internet connection.

## 🚀 The Problem & Solution

### The Problem
Most finance apps rely heavily on a constant internet connection, leading to data loss or "app freezes" in low-connectivity areas. Additionally, managing budgets across categories and tracking progress against savings goals can be fragmented and difficult to visualize.

### Our Solution
FinTrack solves this by:
- **Offline-First Synchronization**: All data is stored locally in a high-performance SQLite database (Drift) and automatically synced to a secure PostgreSQL backend when the connection is restored.
- **Automated Budgeting**: Real-time spending analysis with automated alerts when budget thresholds (80%/100%) are hit.
- **Secure Financial Data**: Industry-standard JWT authentication and biometric (Fingerprint/FaceID) support for mobile security.
- **Actionable Insights**: Visual Spending Analytics and Savings Goal tracking to help users reach their financial milestones.

---

## 🛠 Tech Stack

### Mobile (Track A - Flutter)
- **Framework**: Flutter (Dart)
- **State Management**: BLoC / Cubit (for scalable business logic)
- **Local Database**: Drift (SQLite) with SyncStatus tracking
- **Networking**: Dio (with JWT Auth Interceptors)
- **Security**: Flutter Secure Storage & Local Auth (Biometrics)
- **Dependency Injection**: GetIt & Injectable

### Backend (Node.js)
- **Runtime**: Node.js with TypeScript
- **Framework**: Express.js
- **ORM**: Prisma (PostgreSQL)
- **Authentication**: JWT (Access & Refresh Token rotation)
- **Validation**: Zod (strict API contract enforcement)
- **Automation**: Node-Cron (for budget alert calculations)

---

## ⚙️ Setup & Installation

### Prerequisites
- Node.js (v18+)
- Flutter SDK (v3.0+)
- PostgreSQL Database

### 1. Backend Setup
1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file from the template:
   ```bash
   cp .env.example .env
   # Update the DATABASE_URL with your PostgreSQL credentials
   ```
4. Run migrations and start the server:
   ```bash
   npx prisma migrate dev
   npm run dev
   ```

### 2. Mobile Setup
1. Navigate to the mobile directory:
   ```bash
   cd mobile
   ```
2. Install Flutter packages:
   ```bash
   flutter pub get
   ```
3. Generate generated files (Drift/Injectable):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Run the application:
   ```bash
   # Make sure backend is running first
   flutter run --dart-define=API_BASE_URL=http://your-ip-address:4000/api/v1
   ```

---

## 🧪 Testing
- **Backend**: `npm test` (Uses Jest for Service and Utility logic)
- **Mobile**: `flutter test` (Tests Cubits, Validators, and Export Logic)

## 📄 License
This project is developed as part of the GPP evaluation suite.
