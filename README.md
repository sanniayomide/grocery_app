# Grocery App

Flutter customer app for grocery shopping, built with Riverpod, Firebase Authentication, and Cloud Firestore.

## Features

- Email/password account registration and sign-in
- Product catalogue, categories, search, and product details
- Cart with quantity controls
- Delivery details and pay-on-delivery checkout
- Firestore-backed order history and order details
- Payments and wallet information screen (no monetary wallet or online payment processing)

## Structure

```text
lib/
  core/                 Shared theme and widgets
  features/
    app_shell/          Customer navigation
    auth/               Firebase sign-in and profile management
    catalog/            Products, filtering, catalogue repository
    home/               Storefront
    cart/               Cart state and summary
    checkout/           Delivery form and order submission
    orders/             Firestore order repository, history and details
    wallet/             Payment options and future integration
test/                   Flutter tests
firestore.rules         Proposed database access policy
```

## Local setup

1. Install Flutter and Android Studio, then run `flutter doctor`.
2. Clone the repository and run `flutter pub get`.
3. Set up Firebase Authentication and Cloud Firestore. Regenerate platform configuration using `flutterfire configure --project=grocery-app-21838`.
4. Review and test `firestore.rules` against your current database rules before deploying them.
5. Run `flutter run` on an Android emulator or device.

## Quality checks

```sh
flutter analyze
flutter test
flutter run
```

## Order handling and payments

Checkout supports **pay on delivery** as a prototype. Retries reuse an order ID so a repeated request cannot create another document for the same checkout attempt. Orders are scoped to the authenticated customer in Firestore.

The app currently displays totals calculated on the device. This is **not sufficient for production transactions**: a trusted backend must verify prices, stock, delivery charges and order ownership before accepting an order. Firestore security rules alone cannot replace this verification.

The wallet page does not display an actual balance or offer funding. Card, bank transfer and stored-value payments require a payment provider, webhook verification, a trusted server and an auditable ledger. No real online payments are implemented.

## Remaining work

- Run analyzer, unit tests and Android checkout smoke tests
- Test Firestore access rules with Firebase Emulator Suite
- Implement server-authoritative pricing and stock validation
- Add administrative order status updates and delivery tracking
- Integrate a verified payment provider when backend support is available
