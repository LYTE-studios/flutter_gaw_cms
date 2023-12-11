import 'package:flutter/material.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

class SelectAddressWizardItem extends StatefulWidget {
  const SelectAddressWizardItem({super.key});

  @override
  State<SelectAddressWizardItem> createState() =>
      _SelectAddressWizardItemState();
}

class _SelectAddressWizardItemState extends State<SelectAddressWizardItem> {
  final TextEditingController tecAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CmsInputField(
          controller: tecAddress,
        ),
      ],
    );
  }
}
