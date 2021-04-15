part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final String username;
  final String email;
  final String password;
  final Failure failure;
  final SignupStatus status;

  const SignupState({
    @required this.username,
    @required this.email,
    @required this.password,
    @required this.failure,
    @required this.status,
  });

  factory SignupState.initial() {
    return SignupState(
      username: '',
      email: '',
      password: '',
      failure: Failure(),
      status: SignupStatus.initial,
    );
  }

  @override
  bool get stringify => true;
  @override
  List<Object> get props => [username, email, password];

  SignupState copyWith({
    String username,
    String email,
    String password,
    Failure failure,
    SignupStatus status,
  }) {
    return SignupState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }
}
