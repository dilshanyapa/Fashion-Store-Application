## 🛠️ Firebase Setup Instructions

To successfully run and test this application locally, you need to configure your own Firebase project. Follow the steps below:

### 1. Create a Firebase Project
* Go to the [Firebase Console](https://console.firebase.google.com/).
* Click on **Add Project** and name it `Dilshan Fashion`.
* Enable or disable Google Analytics based on your preference and click **Create Project**.

### 2. Configure Firestore Database
* In the Firebase left sidebar, navigate to **Build > Firestore Database**.
* Click **Create Database** and start in **Test Mode** (to allow instant read/write permissions for evaluation).
* Choose your database location and click **Enable**.
* **CRITICAL REQUIREMENT:** Create a collection named `products` and pre-load at least 3-5 items with the following fields:
  * `name` (String) - e.g., "Polo T-Shirt"
  * `price` (String or Number) - e.g., "1900"
  * `originalPrice` (String) - e.g., "2500"
  * `imageUrl` (String) - Web URL of the product image
  * `description` (String) - Product features and details

### 3. Enable Authentication
* Navigate to **Build > Authentication** and click **Get Started**.
* Under the **Sign-in method** tab, select **Email/Password**, enable it, and save.

### 4. Connect Flutter App via FlutterFire CLI
Make sure you have the Firebase CLI installed on your machine, then run the following commands in your project terminal:
```bash
# Log in to your Google Account linked with Firebase
firebase login

# Activate FlutterFire CLI globally
dart pub global activate flutterfire_cli

# Configure the project to generate 'firebase_options.dart'
flutterfire configure
