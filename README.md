# Grocery App

A Flutter grocery shopping application with Firebase Authentication, Cloud Firestore, and Riverpod state management.

The customer app supports browsing products, filtering by category, searching, managing a cart, and submitting pay-on-delivery orders. Checkout and persisted order history are under development.

## Technology

- Flutter and Dart
- Riverpod for application state
- Firebase Authentication for customer accounts
- Cloud Firestore for product data and orders
- Google Fonts and SVG assets for the design system

## Project structure

```text
lib/
  core/
    theme/                  Shared colors, typography, spacing and themes
    widgets/                Reusable UI components
  features/
    app_shell/              Main navigation
    auth/                   Account registration and sign-in
    catalog/                Product models, repository and product details
    home/                   Storefront, search and category browsing
    cart/                   Cart state and screen
    checkout/               Delivery details and order submission
    orders/                 Order models, Firestore access and order history
    wallet/                 Future wallet integration
  firebase_options.dart     Firebase platform configuration
  main.dart                 Application entry point
test/
  orders/                   Order model tests
```

## Getting started

### Prerequisites

- Flutter SDK and a configured Android toolchain
- A Firebase project with Authentication and Firestore enabled
- Firebase CLI and FlutterFire CLI for Firebase setup

### Installation

```bash
git clone https://github.com/sanniayomide/grocery_app.git
cd grocery_app
flutter pub get
flutter doctor
```

Configure the Firebase project for your supported platforms:

```bash
flutterfire configure --project=grocery-app-21838
```

Ensure the Android Firebase application matches the Android application ID in `android/app/build.gradle.kts`. Enable an appropriate Authentication provider in Firebase Console and deploy reviewed Firestore security rules.

Run the application:

```bash
flutter run
```

## Development checks

```bash
flutter analyze
flutter test
```

## Current functionality

| Area | Status |
| --- | --- |
| Customer registration and sign-in | Implemented |
| Product listing, search and categories | Implemented |
| Product details and cart | Implemented |
| Delivery information and checkout | In development |
| Firestore order history | In development |
| Wallet and online payments | Not implemented |

Checkout currently supports a pay-on-delivery prototype. Do not treat client-calculated totals as authoritative: production order creation must verify product prices, stock, delivery fees and payment status in trusted backend code. Firestore rules in this repository require review alongside rules for existing collections before deployment.

## Architecture

Features are grouped by responsibility. Domain models describe business data, repositories handle Firebase access, and Riverpod providers connect data to presentation widgets. Shared visual tokens and controls live under `lib/core/`.

## Roadmap

- Complete order validation, Firestore security tests, and Android checkout testing
- Add saved addresses and order details
- Integrate delivery status updates
- Evaluate payment processing and wallet functionality
