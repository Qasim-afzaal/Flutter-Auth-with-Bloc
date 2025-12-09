import 'package:equatable/equatable.dart';

/// Base class for all profile events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to load profile
class ProfileRequested extends ProfileEvent {
  const ProfileRequested();
}

