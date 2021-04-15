import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_bloc/models/models.dart';
import 'package:instagram_bloc/repositories/auth/auth_repository.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  SignupCubit({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  void onUsernameChanged(String username) {
    emit(state.copyWith(username: username, status: SignupStatus.initial));
  }

  void onEmailChanged(String email) {
    emit(state.copyWith(email: email, status: SignupStatus.initial));
  }

  void onPasswordChanged(String password) {
    emit(state.copyWith(password: password, status: SignupStatus.initial));
  }

  void signupWithCredentials() async {
    if (state.username.isEmpty ||
        state.email.isEmpty ||
        state.password.length < 6 ||
        state.status == SignupStatus.submitting) return;

    emit(state.copyWith(status: SignupStatus.submitting));

    try {
      await _authRepository.signupWithEmailAndPassword(
          username: state.username,
          email: state.email,
          password: state.password);
      emit(state.copyWith(status: SignupStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: SignupStatus.error));
    }
  }
}
