# Self Checkout App

A Flutter application built with GetX and MVVM architecture for self-checkout functionality.

## Features

- **8 Main Screens**: Start, Item Scan, Payment, Processing, Printing, Error, Alert, Assistant
- **gRPC Communication**: Real-time communication with backend services
- **MQTT Alerts**: Priority alert system with video playback
- **State Management**: Reactive state management using GetX
- **MVVM Architecture**: Clean separation of concerns

## Architecture

### Models
- `ScannedItem`: Represents scanned items with price and quantity
- `PaymentRequest/Response`: Handles payment processing
- `AlertMessage`: MQTT alert messages with video support
- `AppState`: Global application state

### Services
- `GrpcService`: Handles gRPC communication
- `MqttService`: Manages MQTT connections and alerts

### Controllers
- `AppController`: Main application controller managing state and navigation
- `NavigationController`: Handles screen transitions based on app state

### Views
- `StartPage`: Welcome screen with connection status
- `ItemScanPage`: Item scanning and cart management
- `PaymentPage`: Payment method selection
- `ProcessingPage`: Payment processing with animations
- `PrintingPage`: Receipt printing with preview
- `ErrorPage`: Error handling and connection status
- `AlertPage`: MQTT alert display with video player
- `AssistantPage`: Testing and debugging interface

## Key Features

### Alert Priority System
- MQTT alerts override gRPC responses
- Alert screen takes priority over other screens
- Video playback support for alerts

### Connection Management
- Automatic reconnection for both gRPC and MQTT
- Connection status monitoring
- Graceful error handling

### State Management
- Reactive UI updates using GetX observables
- Centralized state management
- Screen transitions based on app state

## Getting Started

1. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

2. Run the application:
   ```bash
   flutter run
   ```

## Configuration

Update the following in the services:
- gRPC server address in `GrpcService`
- MQTT broker address in `MqttService`
- Video URLs for alerts

## Testing

Use the Assistant page to test various functionalities:
- Connection tests
- Payment simulation
- Alert simulation
- Navigation testing

## Dependencies

- `get`: State management and navigation
- `grpc`: gRPC communication
- `mqtt_client`: MQTT messaging
- `video_player`: Video playback for alerts
- `printing`: Receipt printing
- `qr_code_scanner`: Item scanning
- `logger`: Logging and debugging
