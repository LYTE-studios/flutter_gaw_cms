import 'package:flutter/material.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class WasherBillingForm extends StatelessWidget {
  final TextEditingController tecVat;

  const WasherBillingForm({
    super.key,
    required this.tecVat,
  });

  @override
  Widget build(BuildContext context) {
    return GawForm(
      rows: [
        FormRow(
          formItems: [
            FormItem(
              child: InputTextForm(
                label: 'IBAN',
                hint: 'Washers Bank account',
                controller: tecVat,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
