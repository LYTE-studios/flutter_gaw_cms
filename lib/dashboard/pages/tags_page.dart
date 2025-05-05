import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/utils/exception_handler.dart';
import 'package:flutter_gaw_cms/jobs/presentation/dialogs/application_details_dialog.dart';
import 'package:flutter_gaw_cms/tags/dialogs/tag_details_dialog.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage tagsBeamPage = BeamPage(
  title: 'Tags',
  key: ValueKey('tags'),
  type: BeamPageType.noTransition,
  child: TagsPage(),
);

class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  static const String route = '/dashboard/tags';

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> with ScreenStateMixin {
  TagListResponse? tagListResponse;

  @override
  Future<void> loadData({
    int? page,
    int? itemCount,
  }) async {
    tagListResponse = await JobsApi.getTags();

    setState(() {
      tagListResponse = tagListResponse;
    });
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
    return BaseLayoutScreen(
      mainRoute: 'Settings',
      subRoute: 'Tags',
      extraActionButtonPadding: 128,
      actionWidget: ActionButton(
        label: 'Create new tag',
        onTap: () {
          DialogUtil.show(
            dialog: const TagDetailsDialog(),
            context: context,
          ).whenComplete(setData);
        },
      ),
      child: ScreenSheet(
        topPadding: 156,
        child: GenericListView(
          showFooter: false,
          loading: loading,
          canDelete: false,
          title: 'Tags',
          valueName: 'tags',
          header: BaseListHeader(
            selected: false,
            items: {
              const BaseHeaderItem(
                label: 'Name',
              ): ListUtil.lColumn - PaddingSizes.smallPadding,
              const BaseHeaderItem(
                label: 'Icon',
              ): ListUtil.sColumn,
              const BaseHeaderItem(
                label: 'Contract',
              ): ListUtil.hugeColumn,
              const BaseHeaderItem(
                label: '',
              ): ListUtil.mColumn,
            },
          ),
          rows: tagListResponse?.tags?.map(
                (tag) {
                  return BaseListItem(
                    onSelected: () {
                      DialogUtil.show(
                        dialog: TagDetailsDialog(
                          tag: tag,
                        ),
                        context: context,
                      ).whenComplete(setData);
                    },
                    items: {
                      Padding(
                          padding: const EdgeInsets.only(
                            left: PaddingSizes.smallPadding,
                          ),
                          child: TextRowItem(
                            value: tag.title,
                          )): ListUtil.lColumn,
                      BaseRowItem(
                        child: CircleAvatar(
                          backgroundColor: HexColor.fromHex(tag.color),
                          child: SvgIcon(
                            tag.icon,
                            useRawCode: true,
                            color: Colors.white,
                          ),
                        ),
                      ): ListUtil.sColumn,
                      TextRowItem(
                        value: toCommittee(tag.specialCommittee),
                      ): ListUtil.hugeColumn,
                      IconRowItem(
                        icon: PixelPerfectIcons.customEye,
                        onTap: () {
                          DialogUtil.show(
                            dialog: TagDetailsDialog(
                              tag: tag,
                            ),
                            context: context,
                          ).whenComplete(setData);
                        },
                      ): ListUtil.mColumn,
                    },
                  );
                },
              ).toList() ??
              [],
        ),
      ),
    );
  }
}
