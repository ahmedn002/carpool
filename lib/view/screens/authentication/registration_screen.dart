import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/services/authentication_services.dart';
import 'package:milestoneone/tools/request_handler.dart';
import 'package:milestoneone/view/global/colors.dart';
import 'package:milestoneone/view/global/lookups.dart';
import 'package:milestoneone/view/screens/authentication/components/animated_logo.dart';
import 'package:milestoneone/view/utilities/general_utilities.dart';
import 'package:milestoneone/view/widgets/action/main_button.dart';
import 'package:milestoneone/view/widgets/dialog/error_dialog.dart';
import 'package:milestoneone/view/widgets/input/app_text_field.dart';
import 'package:milestoneone/view/widgets/input/image_input.dart';
import 'package:milestoneone/view/widgets/input/multi_select_button.dart';
import 'package:milestoneone/view/widgets/misc/gradient_icon.dart';

import '../../global/text_styles.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  File? _image;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  late final List<MultiSelectItem> _items;
  late MultiSelectItem _selectedItem;

  @override
  void initState() {
    _items = GeneralUtilities.getItems();
    _selectedItem = _items.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SizedBox(
          height: 1.sh,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                10.verticalSpace,
                const AnimatedLogo(),
                65.verticalSpace,
                Row(
                  children: [
                    Text(
                      'Select your account type',
                      style: TextStyles.title,
                    ),
                  ],
                ),
                20.verticalSpace,
                MultiSelectButton(
                  items: _items,
                  onChanged: (item) {
                    setState(() {
                      _selectedItem = item!;
                    });
                  },
                ),
                40.verticalSpace,
                Row(
                  children: [
                    Text('Enter your data', style: TextStyles.title),
                  ],
                ),
                20.verticalSpace,
                ImageInput(
                  radius: 75.r,
                  onImageSelected: (image) => _image = image,
                ),
                20.verticalSpace,
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _firstNameController,
                        hintText: 'First Name',
                        prefixIcon: const Icon(Icons.person_rounded),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      20.verticalSpace,
                      AppTextField(
                        controller: _lastNameController,
                        hintText: 'Last Name',
                        prefixIcon: const Icon(Icons.person_rounded),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      20.verticalSpace,
                      AppTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email_rounded),
                        suffix: Text('@eng.asu.edu.eg', style: TextStyles.smallBodyThin.apply(fontSizeFactor: 1.15)),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value?.split('@').length == 2) {
                            return 'No need to enter email domain';
                          } else if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          return null;
                        },
                      ),
                      20.verticalSpace,
                      AppTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_rounded),
                        obscureText: !_passwordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        suffix: IconButton(
                          icon: GradientIcon(icon: _passwordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      20.verticalSpace,
                      AppTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_rounded),
                        obscureText: !_confirmPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        suffix: IconButton(
                          icon: GradientIcon(icon: _confirmPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible = !_confirmPasswordVisible;
                            });
                          },
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
                40.verticalSpace,
                MainButton(
                  text: 'Register',
                  icon: Icon(Icons.edit_note_rounded, color: AppColors.text, size: 20.r),
                  onPressed: _register,
                ),
                20.verticalSpace,
                MainButton(
                  text: 'Back to login',
                  icon: Icon(Icons.arrow_back_rounded, color: AppColors.text, size: 20.r),
                  hollow: true,
                  onPressed: () => Navigator.pop(context),
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    final bool? validation = _formKey.currentState?.validate();
    if (validation == null || !validation) return;

    if (_image == null) {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
          title: 'Error',
          message: 'Please select a profile picture',
        ),
      );
      return;
    }

    RequestHandler.handleRequest(
      context: context,
      service: () => AuthenticationServices.signUpWithEmailAndPassword(
        email: '${_emailController.text}@eng.asu.edu.eg${_selectedItem.title.toLowerCase() == Lookups.driver ? '.${Lookups.driver}' : '.${Lookups.passenger}'}',
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        profilePicture: _image!,
        balance: 20000,
      ),
      redirect: true,
      redirection: () => Navigator.pop(context),
    );
  }
}
