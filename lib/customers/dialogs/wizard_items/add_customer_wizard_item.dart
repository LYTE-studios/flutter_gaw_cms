import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';

class AddCustomerWizardItem extends StatelessWidget {
  const AddCustomerWizardItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormTitle(
          label: 'Add a new customer',
        ),
        SizedBox(
          height: PaddingSizes.extraBigPadding,
        ),
        FormSubTitle(
          label: 'Customer information',
        ),
        Padding(
          padding: EdgeInsets.only(
            top: PaddingSizes.mainPadding,
          ),
          child: SizedBox(
            height: 42,
            child: Row(
              children: [
                Expanded(
                  child: InputTextForm(
                    hint: 'First name',
                  ),
                ),
                SizedBox(
                  width: PaddingSizes.mainPadding,
                ),
                Expanded(
                  child: InputTextForm(
                    hint: 'Last name',
                  ),
                ),
                SizedBox(
                  width: PaddingSizes.mainPadding,
                ),
                Expanded(
                  child: InputTextForm(
                    hint: 'Username',
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(),
      ],
    );
  }
}
