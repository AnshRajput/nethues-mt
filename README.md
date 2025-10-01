# 📱 QR & Barcode Scanner App

The app implements a QR and Barcode scanner with GetX state management and routing, demonstrating proficiency in Flutter development, state management, and mobile app architecture.

## ✨ Assignment Requirements Fulfilled

- **QR Code & Barcode Scanning**: Supports scanning of both QR codes and barcodes using mobile_scanner
- **GetX State Management**: Implemented GetX for efficient state management and routing as requested
- **Clean UI Design**: Modern, user-friendly interface matching the provided reference image
- **Validation Logic**: Validates scanned codes against "login123" as specified
- **Error Handling**: Comprehensive error handling for failed scans and invalid codes
- **Cross-Platform**: Works on both Android and iOS with proper permissions

## 🎯 Assignment Flow Implementation

1. **Home Page**: Displays a "Scan Code" button and clear instructions
2. **Scanner Page**: Camera view with white border overlay and blurred background (matching reference image)
3. **Dashboard Page**: Success page for valid scans ("login123")
4. **Error Handling**: Invalid scans redirect back to home with error message

## 📦 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/AnshRajput/nethues-mt.git
cd scanner
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Platform Configuration

#### Android Setup

Camera permission is configured in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
```

#### iOS Setup

Camera usage description is included in `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to camera to scan QR codes and barcodes</string>
```

## 🏃‍♂️ Running the Application

### Android

```bash
flutter run
```

### iOS

```bash
flutter run
```

For production build:

```bash
flutter run --release
```

## 🧪 Testing the Implementation

### Valid Code Testing

1. Create a QR code or barcode with the text "login123"
2. Open the app and tap "Scan Code"
3. Point the camera at the code within the white frame
4. App should navigate to Dashboard page showing success message

### Invalid Code Testing

1. Create a QR code or barcode with any text other than "login123"
2. Scan the code using the app
3. App should display error message and return to Home page

## 📁 Project Architecture

```
lib/
├── main.dart                 # Application entry point with GetX routing
├── routes/
│   └── app_routes.dart      # Route definitions and navigation
├── controllers/
│   └── scanner_controller.dart # Scanner logic and state management
└── pages/
    ├── home_page.dart       # Home page with scan button
    ├── scanner_page.dart    # Camera scanner with overlay UI
    └── dashboard_page.dart  # Success page for valid scans
```

## 🔧 Technology Stack

### Dependencies Used

- **mobile_scanner**: ^5.0.0 - QR and barcode scanning functionality
- **get**: ^4.6.6 - State management and routing (as requested)
- **permission_handler**: ^11.3.1 - Camera permission handling

## 🎨 Implementation Details

### 1. GetX State Management

- Implemented `GetMaterialApp` for routing
- Used `GetxController` for state management
- Navigation with `Get.toNamed()`, `Get.offNamed()`, etc.
- Snackbar notifications for error feedback

### 2. Scanner Controller

The `ScannerController` handles:

- QR code scanning logic using mobile_scanner
- Code validation against "login123"
- Navigation based on scan results
- Error handling and user feedback

### 3. UI Implementation

- **Home Page**: Clean interface with scan button and instructions
- **Scanner Page**: Camera view with white border overlay matching reference image
- **Dashboard Page**: Success confirmation with scanned code display

### 4. Error Handling

- Camera permission handling
- Invalid scan detection with user feedback
- Proper navigation flow and error messages

## 🐛 Troubleshooting

### Common Issues

1. **Camera Permission Denied**

   - Ensure camera permission is granted in device settings
   - Check platform-specific permission configurations

2. **Scanner Not Working**

   - Test on physical device (camera doesn't work in most emulators)
   - Ensure camera is not being used by another app

3. **Build Errors**
   ```bash
   flutter clean
   flutter pub get
   ```
