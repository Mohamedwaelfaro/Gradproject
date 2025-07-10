
# Graduation Project - Smart Transportation App

This is a full-stack graduation project that consists of a **Flutter frontend** and a **Django backend**. The system is designed to facilitate smart transportation booking, including user authentication, vehicle selection, and online payment through Paymob.

## 🧩 Project Structure

- **Frontend (Flutter)**: Mobile application for users to register, login, book transport, and pay.
- **Backend (Django)**: Handles user data, authentication, database management, and API endpoints.

---

## 🚀 Features

### Frontend (Flutter)
- Splash screen & onboarding.
- User authentication (Sign up, login, forgot password, verification).
- Smart transportation UI with available vehicles.
- Online payment integration with **Paymob**.
- Organized code structure with separation of concerns.

### Backend (Django)
- RESTful API for user authentication and data handling.
- SQLite3 database (development).
- Requirements listed for easy setup.
- Secure environment setup using `.env`.

---

## 🛠️ Installation & Setup

### Backend (Django)
```bash
# Navigate to the backend folder
cd GradProject

# Create and activate a virtual environment
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Start the server
python manage.py runserver
```

### Frontend (Flutter)
```bash
# Navigate to the flutter project root
cd your_flutter_project_path

# Get packages
flutter pub get

# Run the app
flutter run
```

> ⚠️ Make sure the backend server is running and accessible from the Flutter app (update base URLs in your API service files accordingly).

---

## 💳 Payment Integration
The app uses **Paymob** for online transactions. The integration is done in the Flutter app using custom service files and APIs.

---

## 📦 Dependencies

### Flutter
- `dio`
- `flutter_bloc`
- `get`
- `paymob_flutter`
- ... and others

### Django
- `djangorestframework`
- `python-dotenv`
- `corsheaders`
- ... listed in `requirements.txt`

---

## 📸 Screenshots
_Add screenshots or screen recordings here if available._

---

## 👥 Team & Contribution

This project was developed as a graduation project by:

- [Your Name] – Mobile App Developer
- [Your Team Member(s)] – Backend Developer, Designer, etc.

---

## 📬 Contact

Feel free to connect on [LinkedIn](https://linkedin.com) or email me at [your-email@example.com].

---

## 🏁 License

MIT License (or specify your own)

