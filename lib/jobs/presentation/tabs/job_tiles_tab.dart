import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/jobs/presentation/widgets/job_info_card.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class JobTilesTab extends StatefulWidget {
  final List<Job> jobs;

  final bool loading;

  const JobTilesTab({
    super.key,
    required this.jobs,
    this.loading = false,
  });

  @override
  State<JobTilesTab> createState() => _JobTilesTabState();
}

class _JobTilesTabState extends State<JobTilesTab> {
  @override
  Widget build(BuildContext context) {
    return LoadingSwitcher(
      loading: widget.loading,
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Wrap(
            children: buildItems(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildItems() {
    List<Widget> items = [];

    for (Job job in widget.jobs) {
      items.add(
        JobInfoCard(
          info: job,
        ),
      );
    }

    return items;
  }
}