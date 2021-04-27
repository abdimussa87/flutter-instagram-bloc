import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc/config/size_config.dart';
import 'package:instagram_bloc/repositories/repositories.dart';
import 'package:instagram_bloc/screens/signup/signup_screen.dart';
import 'package:instagram_bloc/widgets/widgets.dart';

import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';
  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: LoginScreen(),
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
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  content: state.failure.message,
                ),
              );
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
                                hintText: 'Email',
                              ),
                              onChanged: (value) => context
                                  .read<LoginCubit>()
                                  .emailChanged(value.trim()),
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
                                  .read<LoginCubit>()
                                  .passwordChanged(value),
                              validator: (value) => value.length < 6
                                  ? 'Password must be at least 6 characters.'
                                  : null,
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier),
                            RaisedButton(
                              onPressed: () => _submitForm(context,
                                  state.status == LoginStatus.submitting),
                              elevation: 1,
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 1.5,
                                ),
                              ),
                            ),
                            SizedBox(height: SizeConfig.heightMultiplier),
                            RaisedButton(
                              onPressed: () => Navigator.of(context).pushNamed(
                                SignupScreen.routeName,
                              ),
                              elevation: 1,
                              color: Colors.grey[200],
                              textColor: Colors.black,
                              child: Text(
                                'No account? Sign up',
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
      context.read<LoginCubit>().loginWithCredentials();
    }
  }
}
