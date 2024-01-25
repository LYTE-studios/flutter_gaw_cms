import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/location_picker_dialog.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class CustomerDetailsForm extends StatefulWidget {
  final Customer? customer;

  final bool canEdit;

  final Function()? cancelEdit;

  const CustomerDetailsForm({
    super.key,
    required this.customer,
    this.canEdit = false,
    this.cancelEdit,
  });

  @override
  State<CustomerDetailsForm> createState() => _CustomerDetailsFormState();
}

class _CustomerDetailsFormState extends State<CustomerDetailsForm>
    with ScreenStateMixin {
  late TextEditingController tecFirstname = TextEditingController(
    text: widget.customer?.firstName,
  );

  late TextEditingController tecLastName = TextEditingController(
    text: widget.customer?.lastName,
  );

  late TextEditingController tecEmail = TextEditingController(
    text: widget.customer?.email,
  );

  late TextEditingController tecInitials = TextEditingController(
    text: widget.customer?.initials,
  );

  late TextEditingController tecPhoneNumber = TextEditingController(
    text: widget.customer?.phoneNumber,
  );

  late TextEditingController tecVatNumber = TextEditingController(
    text: widget.customer?.taxNumber,
  );

  late TextEditingController tecCompany = TextEditingController(
    text: widget.customer?.company,
  );

  void _update() {
    setLoading(true);

    CustomerApi.updateCustomer(
      id: widget.customer!.id!,
      request: UpdateCustomerRequest(
        (b) => b
          ..firstName = tecFirstname.text
          ..lastName = tecLastName.text
          ..email = tecEmail.text
          ..taxNumber = tecVatNumber.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GawForm(
      rows: [
        FormRow(
          formItems: [
            FormItem(
              child: InputTextForm(
                label: 'First name',
                controller: tecFirstname,
                frozen: !widget.canEdit,
              ),
            ),
            FormItem(
              child: InputTextForm(
                label: 'Last name',
                controller: tecLastName,
                frozen: !widget.canEdit,
              ),
            ),
            FormItem(
              flex: 2,
              child: InputTextForm(
                label: 'Email',
                controller: tecEmail,
                frozen: !widget.canEdit,
              ),
            ),
          ],
        ),
        FormRow(
          formItems: [
            FormItem(
              child: InputTextForm(
                label: 'Initials',
                controller: tecInitials,
                frozen: !widget.canEdit,
              ),
            ),
            FormItem(
              child: InputTextForm(
                label: 'Phone number',
                controller: tecPhoneNumber,
                frozen: !widget.canEdit,
              ),
            ),
            FormItem(
              flex: 2,
              child: InputStaticTextForm(
                label: 'Address',
                onTap: () {
                  if (!widget.canEdit) {
                    return;
                  }
                  DialogUtil.show(
                    dialog: const LocationPickerDialog(),
                    context: context,
                  );
                },
                frozen: !widget.canEdit,
                text: widget.customer?.address?.formattedAddres(),
                icon: PixelPerfectIcons.placeIndicator,
                hint: 'Customer address',
              ),
            ),
          ],
        ),
        FormRow(
          formItems: [
            FormItem(
              child: InputTextForm(
                label: 'VAT number',
                controller: tecVatNumber,
                frozen: !widget.canEdit,
              ),
            ),
            FormItem(
              child: InputTextForm(
                label: 'Company',
                controller: tecCompany,
                frozen: !widget.canEdit,
              ),
            ),
            FormItem(
              flex: 2,
              child: InputStaticTextForm(
                label: 'Billing address',
                onTap: () {
                  if (!widget.canEdit) {
                    return;
                  }
                  DialogUtil.show(
                    dialog: const LocationPickerDialog(),
                    context: context,
                  );
                },
                frozen: !widget.canEdit,
                text: widget.customer?.billingAddress?.formattedAddres(),
                icon: PixelPerfectIcons.placeIndicator,
                hint: 'Customer billing address',
              ),
            ),
          ],
        ),
        Visibility(
          visible: widget.canEdit,
          child: Padding(
            padding: const EdgeInsets.only(
              top: PaddingSizes.bigPadding,
              left: PaddingSizes.mainPadding,
              right: PaddingSizes.mainPadding,
              bottom: PaddingSizes.mainPadding,
            ),
            child: FormRow(
              formItems: [
                GenericButton(
                  label: 'Save changes',
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    color: GawTheme.clearText,
                  ),
                  onTap: () {},
                ),
                const SizedBox(
                  width: PaddingSizes.mainPadding,
                ),
                GenericButton(
                  outline: true,
                  label: 'Cancel',
                  color: GawTheme.clearText,
                  textColor: GawTheme.text,
                  textStyleOverride: TextStyles.mainStyle.copyWith(
                    fontSize: 12,
                  ),
                  onTap: widget.cancelEdit,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
