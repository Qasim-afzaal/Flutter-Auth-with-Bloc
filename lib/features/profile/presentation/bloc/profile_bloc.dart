import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// Profile BLoC
/// Manages profile state and handles profile events
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({
    required ProfileRepository profileRepository,
  })  : _profileRepository = profileRepository,
        super(ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
  }

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      Logger.info('Profile requested');
      final profile = await _profileRepository.getProfile();
      Logger.info('Profile loaded successfully: ${profile.email}');
      emit(ProfileLoaded(profile));
    } on Exception catch (e) {
      Logger.error('Profile failed', e);
      emit(ProfileError(e.toString()));
    } catch (e) {
      Logger.error('Unexpected error loading profile', e);
      emit(ProfileError('Failed to load profile: $e'));
    }
  }
}

