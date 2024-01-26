import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_gaw_cms/customers/forms/customer_basic_details_form.dart';
import 'package:flutter_gaw_cms/customers/forms/customer_billing_form.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class CustomerCreateDialog extends StatefulWidget {
  const CustomerCreateDialog({super.key});

  @override
  State<CustomerCreateDialog> createState() => _CustomerCreateDialogState();
}

class _CustomerCreateDialogState extends State<CustomerCreateDialog>
    with TickerProviderStateMixin, ScreenStateMixin {
  final TextEditingController tecFirstName = TextEditingController();
  final TextEditingController tecLastName = TextEditingController();
  final TextEditingController tecEmail = TextEditingController();
  final TextEditingController tecPhoneNumber = TextEditingController();
  final TextEditingController tecCompany = TextEditingController();
  final TextEditingController tecVat = TextEditingController();

  Address? address;
  Address? billingAddress;

  int index = 0;

  bool valid = false;

  void _next() {
    if (index == 2) {
      setLoading(true);
      CustomerApi.createCustomer(
          request: CreateCustomerRequest(
        (b) => b
          ..firstName = tecFirstName.text
          ..lastName = tecLastName.text
          ..email = tecEmail.text
          ..address = address?.toBuilder()
          ..billingAddress = billingAddress?.toBuilder()
          ..taxNumber = tecVat.text,
      )).then((_) {
        Navigator.of(context).pop();
      }).catchError((error) {
        ExceptionHandler.show(error);
        Navigator.of(context).pop();
      }).whenComplete(
        () => setLoading(false),
      );

      return;
    }

    setState(() {
      index = index + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    late List<Widget> pages = [
      CustomerBasicDetailsForm(
        onValidationChange: (bool value) {
          setState(() {
            valid = value;
          });
        },
        onUpdateAddress: (Address address) {
          setState(() {
            this.address = address;
            billingAddress = address;
          });
        },
        address: address,
        tecFirstName: tecFirstName,
        tecLastName: tecLastName,
        tecEmail: tecEmail,
        tecPhoneNumber: tecPhoneNumber,
      ),
      CustomerBillingForm(
        onUpdateBillingAddress: (Address address) {
          setState(() {
            billingAddress = address;
          });
        },
        billingAddress: billingAddress,
        tecCompany: tecCompany,
        tecVat: tecVat,
      ),
      SizedBox(),
    ];

    return BaseDialog(
      height: 480,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              height: 100,
              width: 720,
              child: WizardHeader(
                items: const [
                  'Information',
                  'Billing',
                  'Picture',
                ],
                selectedIndex: index,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingSizes.bigPadding,
              ),
              child: pages[index],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSizes.extraBigPadding,
            ),
            child: SizedBox(
              height: 86,
              child: Row(
                children: [
                  ColorlessInkWell(
                    onTap: !valid ? null : _next,
                    child: Container(
                      height: 42,
                      width: 156,
                      decoration: BoxDecoration(
                        color: !valid
                            ? GawTheme.unselectedMainTint
                            : GawTheme.mainTint,
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        boxShadow: const [
                          Shadows.lightShadow,
                        ],
                      ),
                      child: Center(
                        child: LoadingSwitcher(
                          loading: loading,
                          child: MainText(
                            index == 2 ? 'Create' : 'Next',
                            textStyleOverride: TextStyles.titleStyle.copyWith(
                              color: GawTheme.mainTintText,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: index > 0,
                    child: ColorlessInkWell(
                      onTap: () {
                        setState(() {
                          index = index - 1;
                        });
                        return;
                      },
                      child: const SizedBox(
                        width: 72,
                        child: Center(
                          child: MainText(
                            'Back',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
