import 'package:collection/collection.dart';
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

  TagListResponse? tags;

  @override
  Future<void> loadData() async {
    setLoading(true);

    tags = await JobsApi.getTags();

    await CustomerApi.getCustomer(id: widget.customerId)
        .then((Customer? customer) {
      setState(() {
        this.customer = customer;
        this.tags = tags;
      });
    }).catchError(
      (error) {
        ExceptionHandler.show(error);
      },
    ).whenComplete(() => setLoading(false));
  }

  String toCommittee(String pc) {
    switch (pc) {
      case '121':
        return 'Automotive';
      case 'h121':
        return 'Hospitality';
      case '302':
        return 'Horeca';
    }

    return 'Automotive';
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: PaddingSizes.mainPadding),
                      child: SizedBox(
                        height: 120,
                        width: 120,
                        child: ProfilePictureAvatar(
                          canEdit: true,
                          showCircle: true,
                          imageUrl: FormattingUtil.formatUrl(
                              customer?.profilePictureUrl),
                          onEditPressed: () {
                            setLoading(true);

                            FilePicker.platform
                                .pickFiles(
                              type: FileType.image,
                            )
                                .then((FilePickerResult? result) {
                              if (result?.files.isEmpty ?? true) {
                                setLoading(false);

                                return;
                              }

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
                    SizedBox(
                      width: 256,
                      child: LoadingSwitcher(
                        loading: loading,
                        child: InputMultiSelectionForm(
                          selectedOptions: customer?.tag == null
                              ? []
                              : [customer!.tag!.title],
                          options: Map.fromEntries(
                            tags?.tags?.map(
                                  (e) => MapEntry(
                                    e.title,
                                    CircleAvatar(
                                      backgroundColor:
                                          HexColor.fromHex(e.color),
                                      child: SvgIcon(
                                        e.icon,
                                        useRawCode: true,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ) ??
                                [],
                          ),
                          onUpdate: (String value) async {
                            setLoading(true);

                            Tag tag = tags!.tags!.firstWhere(
                              (e) => e.title == value,
                            );

                            await CustomerApi.updateCustomer(
                              id: customer!.id!,
                              request: UpdateCustomerRequest(
                                (b) => b..tagId = tag.id,
                              ),
                            );

                            setData();
                          },
                        ),
                      ),
                    ),
                  ],
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
