import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:milestoneone/services/authentication_services.dart';
import 'package:milestoneone/tools/response_wrapper.dart';
import 'package:milestoneone/view/global/colors.dart';
import 'package:milestoneone/view/global/text_styles.dart';
import 'package:milestoneone/view/screens/authentication/components/animated_logo.dart';
import 'package:milestoneone/view/screens/authentication/providers/authentication_provider.dart';
import 'package:milestoneone/view/utilities/general_utilities.dart';
import 'package:milestoneone/view/widgets/action/main_button.dart';
import 'package:milestoneone/view/widgets/action/text_button.dart';
import 'package:milestoneone/view/widgets/dialog/error_dialog.dart';
import 'package:milestoneone/view/widgets/misc/gradient_icon.dart';
import 'package:provider/provider.dart';

import '../../widgets/input/app_text_field.dart';
import '../../widgets/input/multi_select_button.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;

  late final List<MultiSelectItem> _items;
  late MultiSelectItem _selectedItem;

  bool _loading = false;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedLogo(),
            65.verticalSpace,
            MultiSelectButton(
              items: _items,
              onChanged: (item) {
                setState(() {
                  _selectedItem = item!;
                });
              },
            ),
            20.verticalSpace,
            AppTextField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: const Icon(Icons.email_rounded),
              suffix: Text('@eng.asu.edu.eg', style: TextStyles.smallBodyThin.apply(fontSizeFactor: 1.15)),
            ),
            20.verticalSpace,
            AppTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: !_passwordVisible,
              prefixIcon: const Icon(Icons.lock_rounded),
              suffix: IconButton(
                icon: GradientIcon(icon: _passwordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
                padding: EdgeInsets.zero,
              ),
            ),
            20.verticalSpace,
            MainButton(
              text: 'Login',
              onPressed: _login,
              icon: Icon(
                Icons.login_rounded,
                color: AppColors.text,
                size: 20.r,
              ),
              loading: _loading,
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: TextStyles.body,
                ),
                10.horizontalSpace,
                AppTextButton(
                  text: 'Sign Up',
                  onPressed: () => Navigator.pushNamed(context, '/registration'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    final AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);

    setState(() {
      _loading = true;
    });

    final FirebaseResponseWrapper<bool> response = await AuthenticationServices.signInWithEmailAndPassword(
      '${_emailController.text}@eng.asu.edu.eg.${_selectedItem.title.toLowerCase()}',
      _passwordController.text,
    );

    setState(() {
      _loading = false;
    });

    if (!context.mounted) return;
    if (response.data) {
      Navigator.pushNamedAndRemoveUntil(context, '/gate', (route) => false);
    } else {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(title: 'Invalid Credentials', message: 'Please enter a valid email and password.'),
      );
    }
  }
}
