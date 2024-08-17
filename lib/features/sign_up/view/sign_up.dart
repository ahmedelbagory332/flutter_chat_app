import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_application/core/utils/app_utils.dart';
import 'package:chat_application/core/widget/custom_loading_dialog.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_router.dart';
import '../manager/sign_up_cubit.dart';
import '../manager/sign_up_state.dart';

class SignUp extends StatelessWidget {
    SignUp({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (BuildContext context, state) {
        switch (state.status) {
          case SignUpStatus.initial:
            {}
            break;
          case SignUpStatus.loading:
            {
              customLoadingDialog(context);
            }
            break;
          case SignUpStatus.success:
            {
              //To close dialogs
                Navigator.of(context).pop();
              // To go to the next screen and cancel all previous routes
                GoRouter.of(context).go(AppRouter.kSignIn);
                buildShowSnackBar(context, "Now you can login");
            }
            break;
          case SignUpStatus.error:
            {
                Navigator.of(context).pop();
              buildShowSnackBar(context, state.failure.errMessage);
            }
        }
      },
      builder: (BuildContext context, state) {
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/SignUp.png'), fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              backgroundColor: Colors.transparent,
              body:Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(right: 35, left: 35),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 35,
                                top: 10,
                                bottom: MediaQuery.of(context).size.height * 0.2),
                            child: const Text(
                              "Create\nAccount",
                              style: TextStyle(color: Colors.white, fontSize: 33),
                            ),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              context.read<SignUpCubit>().nameChanged(value);
                            },
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Field is empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              context.read<SignUpCubit>().emailChanged(value);
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Field is empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              context.read<SignUpCubit>().passwordChanged(value);
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Field is empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0xff4c505b),
                                  child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate() == true) {
                                        context.read<SignUpCubit>().signUp();
                                      }
                                    },
                                    icon: const Icon(Icons.arrow_forward),
                                  ),
                                ),
                              ]),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    GoRouter.of(context).go(AppRouter.kSignIn);
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ]),
                        ]),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
