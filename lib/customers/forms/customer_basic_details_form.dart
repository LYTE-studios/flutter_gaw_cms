import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/location_picker_dialog.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class CustomerBasicDetailsForm extends StatelessWidget {
  final TextEditingController tecFirstName;

  final TextEditingController tecLastName;

  final TextEditingController tecEmail;
  final TextEditingController tecPhoneNumber;

  final Address? address;

  final Function(Address)? onUpdateAddress;

  final Function(bool)? onValidationChange;

  const CustomerBasicDetailsForm({
    super.key,
    required this.tecFirstName,
    required this.tecLastName,
    required this.tecEmail,
    required this.tecPhoneNumber,
    this.address,
    this.onUpdateAddress,
    this.onValidationChange,
  });

  void validate() {
    bool valid = true;

    for (TextEditingController controller in [
      tecFirstName,
      tecLastName,
      tecEmail,
    ]) {
      if (controller.text.isEmpty) {
        valid = false;
      }
    }

    if (address == null) {
      valid = false;
    }

    onValidationChange?.call(valid);
  }

  @override
  Widget build(BuildContext context) {
    Future(() {
      validate();
    });

    return GawForm(
      rows: [
        FormRow(
          formItems: [
            FormItem(
              child: InputTextForm(
                label: 'First name',
                hint: 'Customer first name',
                controller: tecFirstName..addListener(validate),
              ),
            ),
            FormItem(
              child: InputTextForm(
                label: 'Last name',
                hint: 'Customer last name',
                controller: tecLastName..addListener(validate),
              ),
            ),
            FormItem(
              flex: 2,
              child: InputTextForm(
                label: 'Email',
                hint: 'Customer email',
                controller: tecEmail..addListener(validate),
              ),
            )
          ],
        ),
        FormRow(
          formItems: [
            FormItem(
              child: InputTextForm(
                label: 'Phone number',
                hint: 'Customer phone number',
                controller: tecPhoneNumber..addListener(validate),
              ),
            ),
          ],
        ),
        FormRow(
          formItems: [
            FormItem(
              child: InputStaticTextForm(
                label: 'Address',
                onTap: () {
                  DialogUtil.show(
                    dialog: LocationPickerDialog(
                      address: address,
                      onAddressSelected: (Address address) {
                        onUpdateAddress?.call(address);
                      },
                    ),
                    context: context,
                  );
                },
                text: address?.formattedAddress(),
                icon: PixelPerfectIcons.placeIndicator,
                hint: 'Customer address',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
