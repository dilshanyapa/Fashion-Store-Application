## 🛠️ Firebase Setup Instructions

To successfully run, test, and evaluate this application locally, you must configure your own Firebase backend project. Follow the detailed step-by-step instructions below:

### 1. Create a Firebase Project
* Navigate to the official [Firebase Console](https://console.firebase.google.com/).
* Click on **Add Project** and specify the project name as `Dilshan Fashion`.
* Toggle Google Analytics based on your operational preference and click **Create Project**.

### 2. Configure Authentication Backend
* In the Firebase left sidebar, expand the **Build** menu and click on **Authentication**, then click **Get Started**.
* Under the **Sign-in method** tab, select the **Email/Password** provider.
* Toggle the **Email/Password** switch to **Enable** and click **Save**. 
*(Note: This is mandatory to handle the application's user registration, login, and logout routines safely).*

### 3. Setup Cloud Firestore Database
* In the left sidebar, navigate to **Build > Firestore Database** and click **Create Database**.
* Select **Start in Test Mode** to grant instant read/write permissions for evaluation purposes, choose your preferred cloud database location, and click **Enable**.

#### 📂 Critical Data Pre-loading Requirements:
As per the strict coursework constraints, you must manually populate the database with structural product data before launching the application:

1. Create a root collection exactly named: **`products`**
2. Ingest at least **3 to 5 item documents** into the `products` collection with the following exact field mapping keys (Case-Sensitive):
   * `name` (String) — e.g., `"Polo T-Shirt"`
   * `price` (String) — e.g., `"1900"` *(Must be stored as a string; mapped automatically inside the code)*
   * `originalPrice` (String) — e.g., `"2500"`
   * `image` (String) — A valid HTTPS web resource URL pointing to the product graphic asset
   * `description` (String) — Detailed garment/apparel features and sizing notes

3. Create another separate root collection exactly named: **`orders`**
   *(Note: This collection will automatically capture, store, and persist delivery states and checkouts generated dynamically during client order placements).*

### 4. Bind Flutter Frontend via FlutterFire CLI
Ensure that the Firebase CLI tool suite is installed globally on your local workstation. Open your terminal at the root path of the Flutter project and execute the following sequencing commands:

```bash
# 1. Log into the Google Account associated with your active Firebase Console
firebase login

# 2. Activate the FlutterFire Command Line Interface globally on your OS
dart pub global activate flutterfire_cli

# 3. Initialize the configuration workflow to build 'firebase_options.dart'
flutterfire configure
