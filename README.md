# My Contacts

My Contacts is an iOS application built with a hybrid approach using Objective-C for the main UI and SwiftUI for secondary views. It uses Core Data as the local database and Kingfisher for efficient image downloading and caching.

## Architecture & Design Patterns

The project follows **Clean Architecture** principles with a clear separation of concerns and layers:

- **Domain Layer:** Contains core business logic and protocols.
- **Infrastructure Layer:** Implements data sources and repositories.
- **Presentation Layer:** Includes UI components, ViewModels, and SwiftUI Views.
- **Utilities:** Helper classes and extensions.

The design leverages **MVVM (Model-View-ViewModel)** pattern for UI state management and interaction with the domain/repository layers.

## Project Structure

```
My Contacts
│
├── Assets
│
├── Domain
│   └── Protocols                  # Protocol definitions for repositories and data sources
│
├── Infrastructure
│   ├── Datasources
│   │   └── CoreData               # Core Data implementation for local persistence
│   └── Repositories               # Repository implementations conforming to domain protocols
│
├── Presentation
│   ├── Components                 # Reusable UI components
│   ├── ViewModels                 # ObservableObjects managing UI logic and state
│   └── View                       # SwiftUI Views for secondary screens
│
└── Utils                         # Utility helpers and extensions
```

## Dependencies

- **Kingfisher**  
  Used for asynchronous image downloading and caching in SwiftUI views and Objective-C views through a helper wrapper. Kingfisher provides smooth and efficient image loading, caching, and placeholder support.

## Contact Images
Contact images are fetched randomly from the API:  
`https://picsum.photos/600/600`  
This service delivers random 600x600 pixel images used as placeholders or contact pictures.


## Key Features

- Hybrid Objective-C and SwiftUI integration  
- Local persistence with Core Data  
- Clean Architecture & MVVM pattern  
- Dependency Injection for modularity and testability  
- Search functionality with UISearchController  
- Efficient image loading with Kingfisher  

## Getting Started

1. Clone the repository.  
2. Open the `.xcworkspace` file in Xcode.  
3. Build and run the app on a simulator or device.


## Notes
- The app supports searching contacts by name or phone number.
- Swipe-to-delete functionality is implemented with proper data syncing.
- Core Data handles the persistent storage of contacts, including UUID identifiers.
- The app is designed for scalability and maintainability, following SOLID principles.
