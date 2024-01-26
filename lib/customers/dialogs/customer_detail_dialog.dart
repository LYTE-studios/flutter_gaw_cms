import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_gaw_cms/customers/forms/customer_details_form.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class CustomerDetailDialog extends StatefulWidget {
  final String customerId;

  const CustomerDetailDialog({
    super.key,
    required this.customerId,
  });

  @override
  State<CustomerDetailDialog> createState() => _CustomerDetailDialogState();
}

class _CustomerDetailDialogState extends State<CustomerDetailDialog>
    with ScreenStateMixin {
  Customer? customer;

  bool canEdit = false;

  Uint8List? bytes;

  void loadData() {
    setLoading(true);

    CustomerApi.getCustomer(id: widget.customerId).then((Customer? customer) {
      setState(() {
        this.customer = customer;
      });
    }).catchError(
      (error) {
        ExceptionHandler.show(error);
      },
    ).whenComplete(() => setLoading(false));
  }

  @override
  void initState() {
    Future(() {
      loadData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      height: 680,
      child: Padding(
        padding: const EdgeInsets.all(
          PaddingSizes.bigPadding,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(
                PaddingSizes.mainPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MainText(
                    'Customer profile',
                    textStyleOverride: TextStyles.mainStyleTitle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: PaddingSizes.mainPadding,
                    ),
                    child: ColorlessInkWell(
                      onTap: () {
                        setState(() {
                          canEdit = !canEdit;
                        });
                      },
                      child: const SizedBox(
                        width: 21,
                        height: 21,
                        child: SvgIcon(
                          PixelPerfectIcons.editNormal,
                          color: GawTheme.text,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: PaddingSizes.bigPadding,
              ),
              child: Container(
                height: 180,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: Borders.mainSide,
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: ProfilePictureAvatar(
                      canEdit: true,
                      showCircle: true,
                      imageUrl:
                          FormattingUtil.formatUrl(customer?.profilePictureUrl),
                      onEditPressed: () {
                        FilePicker.platform
                            .pickFiles(
                          type: FileType.image,
                        )
                            .then((FilePickerResult? result) {
                          if (result?.files.isEmpty ?? true) {
                            return;
                          }
                          setLoading(true);

                          UsersApi.uploadProfilePicture(
                            result!.files[0].bytes!,
                            userId: customer!.id,
                          ).then((_) {
                            loadData();
                          }).catchError((error) {
                            ExceptionHandler.show(error);
                          }).whenComplete(() => setLoading(false));
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            LoadingSwitcher(
              loading: loading || customer == null,
              child: CustomerDetailsForm(
                customer: customer,
                canEdit: canEdit,
                onUpdate: loadData,
                cancelEdit: () {
                  setState(() {
                    canEdit = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
