import 'package:equatable/equatable.dart';
import '../../domain/entities/profile.dart';

/// Base class for all profile states
abstract class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object?> get props => [];
}

/// Initial profile state
class ProfileInitial extends ProfileState {}

/// Loading state
class ProfileLoading extends ProfileState {}

/// Loaded state with profile
class ProfileLoaded extends ProfileState {
  final Profile profile;
  
  const ProfileLoaded(this.profile);
  
  @override
  List<Object?> get props => [profile];
}

/// Error state
class ProfileError extends ProfileState {
  final String message;
  
  const ProfileError(this.message);
  
  @override
  List<Object?> get props => [message];
}

