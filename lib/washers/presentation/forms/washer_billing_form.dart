import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/location_picker_dialog.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class WasherBillingForm extends StatelessWidget {
  final TextEditingController tecVat;

  final TextEditingController tecCompany;

  final Address? billingAddress;

  final Function(Address)? onUpdateBillingAddress;

  const WasherBillingForm({
    super.key,
    required this.tecCompany,
    required this.tecVat,
    this.billingAddress,
    this.onUpdateBillingAddress,
  });

  @override
  Widget build(BuildContext context) {
    return GawForm(
      rows: [
        FormRow(
          formItems: [
            FormItem(
              child: InputTextForm(
                label: 'Company',
                hint: 'Washer company',
                controller: tecCompany,
              ),
            ),
            FormItem(
              child: InputTextForm(
                label: 'Vat number',
                hint: 'Customer Vat number',
                controller: tecVat,
              ),
            ),
          ],
        ),
        FormRow(
          formItems: [
            FormItem(
              child: InputStaticTextForm(
                label: 'Billing address',
                onTap: () {
                  DialogUtil.show(
                    dialog: LocationPickerDialog(
                      address: billingAddress,
                      onAddressSelected: onUpdateBillingAddress,
                    ),
                    context: context,
                  );
                },
                text: billingAddress?.formattedAddres(),
                icon: PixelPerfectIcons.placeIndicator,
                hint: 'Customer billing address',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
