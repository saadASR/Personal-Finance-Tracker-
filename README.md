# Personal Finance Tracker

A modern, robust, and beautifully designed Personal Finance Tracker application built with Flutter. Keep track of your income, expenses, and overall financial health with intuitive charts, local data persistence, and multilingual support.

## Features

- **Dashboard & Analytics:** Visual representations of your finances using interactive charts (`fl_chart`).
- **Income & Expense Tracking:** Add, edit, and delete transactions with ease.
- **Local Storage:** Lightning-fast local database using `hive` to keep your financial data secure on your device.
- **State Management:** Reactive and scalable state management powered by `flutter_riverpod`.
- **Dark & Light Themes:** Seamlessly switch between dark and light modes.
- **Internationalization (i18n):** Dynamic language support for English (en), French (fr), and Arabic (ar), including full Right-to-Left (RTL) layout support.
- **Smooth Animations:** Delightful user experience with elegant UI transitions and micro-animations using `flutter_animate`.

##  Tech Stack & Dependencies

- **Framework:** [Flutter](https://flutter.dev/)
- **State Management:** Riverpod (`flutter_riverpod`)
- **Database:** Hive (`hive`, `hive_flutter`)
- **Charts:** FL Chart (`fl_chart`)
- **Animations:** Flutter Animate (`flutter_animate`)
- **Localization:** `flutter_localizations`, `intl`
- **Utilities:** `uuid`, `path_provider`, `equatable`

##  Getting Started

### Prerequisites

Ensure you have the following installed on your machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version ^3.11.1 or higher)
- An IDE such as Android Studio, IntelliJ IDEA, or VS Code with the Flutter extension.

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/saadASR/Personal-Finance-Tracker-.git
   cd Personal-Finance-Tracker-
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

##  Core Structure

```text
lib/
├── core/         # Core specifications, themes, and styling
├── data/         # Hive database configurations and data sources
├── presentation/ # UI screens (MainNavigation, etc.) and reusable widgets
├── providers/    # Riverpod providers for state logic
└── main.dart     # Entry point of the application
```

##  Contributing

Contributions, issues, and feature requests are welcome!
Feel free to check out the [issues page](https://github.com/saadASR/Personal-Finance-Tracker-/issues) if you want to contribute.
