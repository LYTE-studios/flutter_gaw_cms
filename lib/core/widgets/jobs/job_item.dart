import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/jobs/address_block.dart';
import 'package:flutter_gaw_cms/core/widgets/user/cms_avatar.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class JobItem extends StatelessWidget {
  final Job job;

  const JobItem({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(
          PaddingSizes.mainPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CmsAvatar(
              initials: job.customer.initials ?? '',
            ),
            const SizedBox(
              height: PaddingSizes.smallPadding,
            ),
            Row(
              children: [
                MainText(
                  job.customer.getFullName(),
                  textStyleOverride: TextStyles.titleStyle,
                ),
                const Spacer(),
                MainText(
                  GawDateUtil.formatTimeInterval(
                    GawDateUtil.fromApi(job.startTime),
                    GawDateUtil.fromApi(job.endTime),
                  ),
                  color: GawTheme.mainTint,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: buildAddressWidgets(job.address),
            ),
            MainText(
              job.title ?? '',
              textStyleOverride: TextStyles.titleStyle,
            ),
            MainText(
              job.description ?? '',
              textStyleOverride: TextStyles.mainStyle,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildAddressWidgets(Address address) {
    List<Widget> widgets = [];

    if (address.streetName != null) {
      widgets.add(
        AddressBlock(
          label: address.streetName ?? '',
        ),
      );
    }

    if (address.houseNumber != null) {
      widgets.add(
        AddressBlock(
          label: address.houseNumber ?? '',
        ),
      );
    }

    if (address.city != null) {
      widgets.add(
        AddressBlock(
          label: address.city ?? '',
        ),
      );
    }
    if (address.postalCode != null) {
      widgets.add(
        AddressBlock(
          label: address.postalCode ?? '',
        ),
      );
    }
    if (address.country != null) {
      widgets.add(
        AddressBlock(
          label: address.country ?? '',
        ),
      );
    }

    return widgets;
  }
}
