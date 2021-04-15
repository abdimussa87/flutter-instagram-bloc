import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:instagram_bloc/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<auth.User> _userSubscription;

  AuthBloc({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.unknown()) {
    // setting our _userSubscription to a listener from our auth repository
    // the user might be null when logging out or have a value when logging in and we will yield...
    // ... different states based on the user
    _userSubscription =
        _authRepository.user.listen((user) => add(AuthUserChanged(user: user)));
  }
  @override
  Future<void> close() {
    _userSubscription
        ?.cancel(); // question mark is to make sure the _userSubscription is not null and we don't want to call cancel on null(will be a error)
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthUserChanged) {
      yield* _mapAuthUserChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      // no need to yield anything because whenever there is a change our _userSubscription will have...
      // ... an AuthUserChanged event added to it with user being null: and will be taken care of by _mapAuthUserChangedToState method below
      await _authRepository.logout();
    }
  }

  Stream<AuthState> _mapAuthUserChangedToState(AuthUserChanged event) async* {
    // event is being added from the _userSubscription above
    yield event.user != null
        ? AuthState.authenticated(user: event.user)
        : AuthState.unauthenticated();
  }
}
