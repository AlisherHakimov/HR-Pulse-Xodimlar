import 'package:flutter/material.dart';
import 'package:hr_plus/core/resources/colors.dart';
import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

class CustomPinPut extends StatefulWidget {
  const CustomPinPut({
    super.key,
    required this.pinController,
    this.onCompleted,
    this.validator,
  });

  final ValueChanged<String>? onCompleted;

  final FormFieldValidator<String>? validator;

  final TextEditingController pinController;

  @override
  State<CustomPinPut> createState() => _CustomPinPutState();
}

class _CustomPinPutState extends State<CustomPinPut> {
  late final SmsRetriever smsRetriever;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();

    smsRetriever = SmsRetrieverImpl(SmartAuth.instance);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 53,
      height: 53,
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.woodSmoke50,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.cEEEEF0,
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Pinput(
      length: 6,
      smsRetriever: smsRetriever,
      controller: widget.pinController,
      focusNode: focusNode,
      autofocus: true,
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) => const SizedBox(width: 8),
      validator: widget.validator,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onTapOutside: (event) => focusNode.unfocus(),
      onCompleted: widget.onCompleted,
      onChanged: (value) {
        debugPrint('onChanged: $value');
      },
      onSubmitted: (value) {
        debugPrint('onSubmitted: $value');
      },
      cursor: Container(height: 18, width: 1.5, color: AppColors.primary),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: AppColors.primary),
        ),
      ),
      disabledPinTheme: defaultPinTheme,
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: AppColors.cEEEEF0,
          border: Border.all(color: AppColors.primary),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyBorderWith(
        border: Border.all(color: Colors.redAccent),
      ),
    );
  }
}

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeUserConsentApiListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final signature = await smartAuth.getAppSignature();
    debugPrint('App Signature: $signature');
    final res = await smartAuth.getSmsWithUserConsentApi();
    if (res.hasData) {
      return res.data?.code;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}
