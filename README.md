# TaskMaster

TaskMaster is a experimental Flutter To-Do List application which using claude.ai for all of the development

## Features

- Create, read, update, and delete tasks
- Set task priorities (low, medium, high)
- Add due dates to tasks
- Mark tasks as complete/incomplete
- Add custom tags to tasks for better organization
- Search functionality to quickly find tasks
- Dark mode support for comfortable usage in low-light environments
- Local storage to persist tasks on the device

## Screenshots

![image](https://github.com/ericlamdev/claude-to-do-list/assets/54704086/43622f8a-f4d7-44a6-afc5-36b59d83b4e6)
![image](https://github.com/ericlamdev/claude-to-do-list/assets/54704086/411769c5-24a9-4f8d-a031-0eeb1f9477ba)
![image](https://github.com/ericlamdev/claude-to-do-list/assets/54704086/9c097186-9d90-48b3-a3fe-fef59ae437bd)

## Getting Started

### Prerequisites

- Flutter (latest version)
- Dart (latest version)
- Android Studio / VS Code

### Installation

1. Clone the repository:
2. Navigate to the project directory:
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`

## Project Structure

- `lib/main.dart`: Entry point of the application
- `lib/models/`: Contains the data models (Task)
- `lib/screens/`: Contains all the UI screens
- `lib/providers/`: Contains state management logic using Riverpod
- `lib/services/`: Contains services like storage service
- `lib/theme/`: Contains app theme configuration

## Dependencies

- flutter_riverpod: ^2.4.0
- hive: ^2.2.3
- hive_flutter: ^1.1.0
- path_provider: ^2.0.11
- intl: ^0.18.0

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License

## Acknowledgments

- Flutter team for the amazing framework
- Riverpod for efficient state management
- Hive for local storage solution