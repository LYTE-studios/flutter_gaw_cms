import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class TagDetailsDialog extends ConsumerWidget {
  final Tag? tag;

  const TagDetailsDialog({
    super.key,
    this.tag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseDialog(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: PaddingSizes.bigPadding,
              horizontal: PaddingSizes.smallPadding,
            ),
            child: FormTitle(
              label: tag == null ? 'Create new tag' : 'Edit tag',
            ),
          ),
          Expanded(
            child: _TagDetailsDialog(tag: tag),
          ),
        ],
      ),
    );
  }
}

class _TagDetailsDialog extends ConsumerStatefulWidget {
  final Tag? tag;

  const _TagDetailsDialog({required this.tag});

  @override
  ConsumerState<_TagDetailsDialog> createState() => _TagDetailsDialogState();
}

class _TagDetailsDialogState extends ConsumerState<_TagDetailsDialog>
    with ScreenStateMixin {
  late final TextEditingController tecName =
      TextEditingController(text: widget.tag?.title)
        ..addListener(() {
          tag = tag.rebuild((b) => b..title = tecName.text);
        });

  late String? icon = widget.tag?.icon;

  late String? color = widget.tag?.color;

  List<String> icons = [];

  late Tag tag = widget.tag ??
      Tag(
        (b) => b
          ..title = ''
          ..specialCommittee = ''
          ..color = ''
          ..icon = '',
      );

  @override
  Future<void> loadData() async {
    icons = [];

    List<String> items = [
      'lib/assets/tag_icons/eat.svg',
      'lib/assets/tag_icons/horeca.svg',
      'lib/assets/tag_icons/wash.svg',
    ];

    for (String item in items) {
      String icon = await rootBundle.loadString(item);
      icons.add(icon);
    }

    setState(() {
      icons = icons;
    });
  }

  Future<void> createTag() async {
    validate();
    if (!validated) {
      return;
    }

    setLoading(true);

    tag = tag.rebuild(
      (b) => b
        ..color = color
        ..icon = icon,
    );

    try {
      if (widget.tag == null) {
        await JobsApi.createTag(tag);
      } else {
        await JobsApi.updateTag(tag);
      }

      Navigator.of(context).pop();
    } finally {
      setLoading(false);
    }
  }

  void validate() {
    validated = true;
    List<TextEditingController> controllers = [tecName];

    for (TextEditingController controller in controllers) {
      if (controller.text.isEmpty) {
        validated = false;
      }
    }

    if (icon == null) {
      validated = false;
    }

    if (color == null) {
      validated = false;
    }

    setState(() {
      validated = validated;
    });
  }

  bool validated = false;

  @override
  Widget build(BuildContext context) {
    validate();

    return GawForm(
      rows: [
        FormRow(
          formItems: [
            FormItem(
              child: InputTextForm(
                label: 'Name',
                controller: tecName,
                hint: 'Enter a tag name',
              ),
            ),
            FormItem(
              child: InputSelectionForm(
                enableText: false,
                label: 'Contract Type',
                value: tag.specialCommittee,
                onSelected: (value) {
                  setState(() {
                    tag = tag
                        .rebuild((b) => b..specialCommittee = value as String);
                  });
                },
                hint: 'Enter needed workers',
                options: const {
                  '121': 'Automotive',
                  'h121': 'Hospitality',
                  '302': 'Horeca',
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        FormRow(
          formItems: [
            FormItem(
              child: _SelectionPanel(
                selectedValue: icon,
                onSelected: (String? value) {
                  setState(() {
                    icon = value;
                  });
                },
                color: color == null ? null : HexColor.fromHex(color!),
                options: icons,
                builder: (
                  context,
                  value,
                ) {
                  return Center(
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: color == null
                          ? GawTheme.mainTint
                          : HexColor.fromHex(color!),
                      child: Center(
                        child: SvgIcon(
                          value,
                          size: 24,
                          useRawCode: true,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            FormItem(
              child: _SelectionPanel(
                selectedValue: color,
                onSelected: (String? value) {
                  setState(() {
                    color = value;
                  });
                },
                useColor: true,
                options: const [
                  '0B1956',
                  'FB9EBB',
                  '3264FF',
                  '465289',
                  'F3A389',
                  'E8A7F7',
                ],
                builder: (
                  context,
                  value,
                ) {
                  return CircleAvatar(
                    radius: 12,
                    backgroundColor: HexColor.fromHex(value),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        FormRow(
          formItems: [
            Padding(
              padding: const EdgeInsets.all(
                PaddingSizes.smallPadding,
              ),
              child: GenericButton(
                loading: loading,
                color: validated
                    ? GawTheme.mainTint
                    : GawTheme.unselectedBackground,
                onTap: createTag,
                minWidth: 156,
                label: 'Save',
                textStyleOverride: TextStyles.mainStyle.copyWith(
                  color: GawTheme.mainTintText,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SelectionPanel extends StatelessWidget {
  final List<String> options;
  final String? selectedValue;
  final Function(String?)? onSelected;
  final Widget Function(BuildContext context, String value) builder;
  final bool useColor;
  final Color? color;

  const _SelectionPanel({
    super.key,
    required this.options,
    this.selectedValue,
    this.onSelected,
    required this.builder,
    this.useColor = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: const Border.fromBorderSide(Borders.mainSide),
        borderRadius: BorderRadius.circular(12),
        color: GawTheme.clearText,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: options
              .map((e) => ClearInkWell(
                    onTap: () {
                      onSelected?.call(e);
                    },
                    child: CircleAvatar(
                      radius: useColor ? 20 : 32,
                      backgroundColor: e == selectedValue
                          ? useColor
                              ? HexColor.fromHex(e)
                                  .withAlpha((.2 * 255).round())
                              : color?.withAlpha((.25 * 255).round()) ??
                                  GawTheme.mainTint
                                      .withAlpha((.25 * 255).round())
                          : Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: builder(context, e),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
