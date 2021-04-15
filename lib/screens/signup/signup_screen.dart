import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc/config/size_config.dart';
import 'package:instagram_bloc/repositories/repositories.dart';

import 'cubit/signup_cubit.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (_) =>
            SignupCubit(authRepository: context.read<AuthRepository>()),
        child: SignupScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text(state.failure.message)));
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomPadding: false,
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(
                    SizeConfig.heightMultiplier * 4,
                  ),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.heightMultiplier * 3),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Instagram',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Username',
                              ),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .onUsernameChanged(value),
                              validator: (value) => value.trim().isEmpty
                                  ? 'Please enter a username.'
                                  : null,
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Email',
                              ),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .onEmailChanged(value),
                              validator: (value) => !value.contains('@')
                                  ? 'Please enter a valid email.'
                                  : null,
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Password',
                              ),
                              obscureText: true,
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .onPasswordChanged(value),
                              validator: (value) => value.length < 6
                                  ? 'Password must be at least 6 characters.'
                                  : null,
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier),
                            RaisedButton(
                              onPressed: () => _submitForm(context,
                                  state.status == SignupStatus.submitting),
                              elevation: 1,
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text(
                                'Signup',
                                style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ),
                              ),
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier),
                            RaisedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              elevation: 1,
                              color: Colors.grey[200],
                              textColor: Colors.black,
                              child: Text(
                                'Back to login',
                                style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<SignupCubit>().signupWithCredentials();
    }
  }
}
