# FinTrack

FinTrack is a full-stack personal finance tracker built with a Node.js backend and a Flutter mobile application.

## Mobile Track
This project uses the **Flutter** track (Track A).

## Project Structure
- `backend/`: Node.js + Express + Prisma + PostgreSQL
- `mobile/`: Flutter + Bloc + Drift + Dio

## Setup Instructions

### Backend
1. Navigate to the `backend/` directory.
2. Install dependencies: `npm install`
3. Create a `.env` file based on `.env.example`.
4. Initialize the database and run migrations: `npx prisma migrate dev`
5. Start the server: `npm run dev`

### Mobile
1. Navigate to the `mobile/` directory.
2. Install dependencies: `flutter pub get`
3. Running with local API: `flutter run` (Ensure the backend is running)
4. To run tests: `flutter test`
