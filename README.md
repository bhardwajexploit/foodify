# 🍽️ Foodify — Restaurant Table Booking App (Flutter)

Foodify is a **restaurant table booking mobile application** built using **Flutter and GetX**.  
The app allows users to browse restaurants, view menus, check real-time availability, and book tables for a selected date and time — similar to apps like **Zomato Dining, Dineout, or OpenTable**.

This project was developed as a **production-style Flutter application** with real API integration, business logic, and clean architecture.

---

## 🚀 Features

- User authentication (Login / Signup)  
- Browse restaurants  
- Restaurant detail screen  
- Menu listing  
- Date & time slot selection  
- Seat / table availability checking  
- Table booking flow  
- Booking history  
- Clean Material-based UI  
- Fully reactive state management  

---

## 🧠 Architecture

Foodify follows a **clean GetX architecture**:

lib/
├── core/
│ ├── constants/
│ ├── colors.dart
│ └── utils/
│
├── data/
│ ├── models/
│ │ ├── restaurant_model.dart
│ │ ├── booking_model.dart
│ │ └── user_model.dart
│ │
│ ├── services/
│ │ └── api_service.dart
│ │
│ └── repositories/
│ └── restaurant_repository.dart
│
├── modules/
│ ├── auth/
│ ├── home/
│ ├── restaurant/
│ └── booking/
│
└── main.dart




UI → Controller → Repository → API  
This separation makes the app scalable and maintainable.

---

## 🌐 API-Driven Data

Foodify is **100% backend driven**.

The API provides:
- Restaurants  
- Menus  
- Available time slots  
- Table capacity  
- Booking data  

All screens are rendered using live API responses.  
No static or hardcoded data is used.

---

## 📅 Table Booking Logic

Each restaurant has:
- Tables  
- Seat capacity  
- Time slots  

Booking flow:

1. User selects a restaurant  
2. Chooses a date  
3. Selects a time slot  
4. Enters number of guests  
5. App validates availability  
6. Booking request is sent to the backend  
7. Backend confirms and returns booking details  

The app prevents overbooking by validating capacity before confirming.

---

## 🔐 Authentication

Foodify includes:
- User signup  
- User login  

Flow:
1. User enters credentials  
2. API validates them  
3. A user session is created  
4. Only logged-in users can book tables  

---

## 🔄 State Management

Foodify uses **GetX** for:
- Reactive UI  
- Controllers  
- Navigation  
- Dependency injection  

Any change in:
- Selected restaurant  
- Time slot  
- Booking status  

automatically updates the UI without manual refresh.

---

## 🧭 Navigation

Navigation is handled using **GetX routing**:
/login
/home
/restaurant
/booking
/history


---

## 🎨 UI

Foodify uses:
- Material widgets  
- Custom color palette  
- Rounded cards  
- Sliver-based layouts  
- Responsive UI  

The design follows modern restaurant booking applications.

---

## 📦 Packages Used

- get  
- http / dio  
- cached_network_image  
- flutter_svg  
- intl  

---

## 📸 Demo

Screenshots & videos:  
https://drive.google.com/drive/folders/1RVx3op7zFMhM_FyebM6oIUSNzB_AMW-u  

---

## 🎯 Why This Project Matters

Foodify demonstrates:
- Real-world API integration  
- Table booking business logic  
- GetX state management  
- Clean Flutter architecture  
- Production-ready UI  

This is how real restaurant booking apps are built.
