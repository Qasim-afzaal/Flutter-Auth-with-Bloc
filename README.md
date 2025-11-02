# Flutter Counter BLoC Demo

A simple Flutter application demonstrating the BLoC (Business Logic Component) pattern for state management.

## Features

- Basic counter functionality (increment, decrement, reset)
- Clean BLoC architecture pattern
- Event-driven state management
- Easy to understand for learning BLoC

## Architecture

This project follows Clean Architecture principles with BLoC pattern for state management.

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`

## BLoC Structure

- **Events**: `IncreaseNumber`, `DecreaseNumber`, `ResetNumber`
- **States**: `CounterInitial`, `CounterValueChanged`
- **Bloc**: `CounterBloc` - handles all counter logic

