# Etara Challenge

A restaurant discovery iOS app built with SwiftUI and Clean Architecture, featuring an interactive map view with advanced filtering capabilities.

## Architecture

This project follows Clean Architecture principles with MVVM pattern:

- **Data Layer**: Repository pattern with mock data (future: API integration + CoreData)
- **Domain Layer**: Use cases with business logic
- **Presentation Layer**: SwiftUI views with pure Swift ViewModels

### Key Decisions

- **Pure Swift ViewModels**: ViewModels have no SwiftUI/MapKit dependencies for better testability
- **Unidirectional Data Flow**: Clear separation between UI state and business logic
- **Client-side Filtering**: Filters applied locally for better performance with mocked data
- **Apple MapKit**: Native integration without requiring API keys

## Project Structure

```
Etara Challenge/
├── Data/
│   └── PlacesRepository.swift        # Mock data repository
├── Domain/
│   ├── PlacesRepoProtocol.swift      # Repository protocol
│   └── PlacesUseCase.swift           # Business logic
└── Presentation/
    ├── ContentView.swift             # Main UI
    └── MapViewModel.swift            # Pure Swift ViewModel
```

### 1. Whenever you see the need to explain the next steps you would take, feel free to add comments either in the code or in a separate file.

- implement Offline Mode so the app can work online and offline (offline storage in the repo)
- Proper Error Handleing based on the Response and status codes
- polish the ui
- use combine for future async tasks
- add some unit tests for the viewmodel


### 2. Document your thought process about challenges you see and how you would approach them.
- The main challenge here is having an interactive screeen with alot of functions. the main challenge here is the
- multi filters (text, categories, and location etc)
- Organaize the ui in a clean way
- i decided to mock the places (resturant data) and keep the filters cliend side

### 3. At what points would you challenge the designer in his UI/UX.
- The filters criteria are not clearly described as we have 2 different type of chips (with drop down arrow and without) this should be clarified in the design

- there is that filter chip (first one on the design) i thing when the user tap it it should show all criterias and and then when the user select on it should be added to the horizontal list so i can see my filters while searching and this stat is not shown in the design.

- The main Influence of this screen is to make the user book. however,"Book now" button doesn't stand out as a hero button CTA 

### 4. How would you code it? We would like to see some code from you.
- i worked with clean archetecture by implemting data domain and presentation layers. ( Uni Directional flow )
- applied mvvm with swiftui keeping the viewmodel pure swift without any frameworks for testability.
- used apple map kit for easier integrations without the neeed for api key


### Solutions Implemented

- **Mocked Data**: Restaurant data is mocked locally for rapid development and testing
- **Client-side Filtering**: Applied filters on the client to avoid multiple API calls
- **State Enums**: Used pure Swift enums for UI states (SheetDetent, MapRegion)
- **Bridging Pattern**: Extensions convert between pure Swift types and UI frameworks


## Technologies Used

- **SwiftUI** - UI framework
- **MapKit** - Map and location services
- **CoreLocation** - Location handling
- **Async/Await** - Asynchronous operations

## Setup & Installation

1. Clone the repository
2. Open `Etara Challenge.xcodeproj` in Xcode
3. Select a simulator (iPhone 16 recommended)
4. Build and run (⌘R)

No API keys or additional setup required!

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+


---

**Author**: Moe Salah
**Date**: December 2025
