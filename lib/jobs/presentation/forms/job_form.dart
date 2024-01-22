import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

class JobSettingsState extends StatefulWidget {
  final CreateJobRequestBuilder job;

  const JobSettingsState({
    super.key,
    required this.job,
  });

  @override
  State<JobSettingsState> createState() => JobSettingsWidget();
}

class JobSettingsWidget extends State<JobSettingsState> {
  // final Job viewing;
  // JobSettingsWidget({
  //   // required this.viewing,
  //   // required this.viewing,
  // });

  Map<String, String> customers = {};

  JobSettingsWidget() {
    updateCustomers();
  }

  void updateCustomers() async {
    CustomerApi.getCustomers().then((value) {
      setState(() {
        value?.customers.forEach((c) {
          if (c.id == null) return;

          customers[c.id!] = "${c.firstName} ${c.lastName}";
        });
      });
    });
  }

  void updateDetails(WidgetRef ref) {
    // JobsProviderState jobState = ref.read(jobsProvider);
    // List<Job>? jobs = jobState.upcomingJobs?.jobs?.toList();

    // if (jobs == null) {
    //   return;
    // }

    // int index = jobs.indexWhere((element) => element == viewing);
    // if (index == -1) {
    //   jobs.add(newInfo);
    // } else {
    //   jobs[index] = newInfo;
    // }
  }

  @override
  Widget build(BuildContext context) {
    CreateJobRequestBuilder job = widget.job;

    Widget washerArea;

    // if (job == JobState.pending) {
    //   List<Widget> widgets = [];
    //   // for (final washer in viewing.) {
    //   //   widgets.add(
    //   //     TextButton(
    //   //       onPressed: () {
    //   //         ref.read(washerFocusProvider.notifier).state = washer;
    //   //       },
    //   //       child: WasherWidget(info: washer),
    //   //     ),
    //   //   );
    //   // }

    //   washerArea = Expanded(
    //     flex: 1,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const InputTitleText("Washers"),
    //         Row(children: widgets),
    //       ],
    //     ),
    //   );
    // } else {
    washerArea = Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InputTitleText("Needed washers for the job"),
          InputTextForm(
            hint: "#",
            number: true,
            text: (job.maxWashers ?? 0).toString(),
            fontSize: 14,
            callback: (value) => job.maxWashers = int.tryParse(value),
          ),
        ],
      ),
    );
    // }

    bool enabled = job.isDraft ?? true;

    String startFormatted = GawDateUtil.formatReadableDate(
        (DateTime.fromMillisecondsSinceEpoch(job.startTime ?? 0)));

    String endFormatted = GawDateUtil.formatReadableDate(
        DateTime.fromMillisecondsSinceEpoch(job.endTime ?? 0));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InputTitleText("Job Title"),
                  InputTextForm(
                    hint: "Wash get driven 4 auto's",
                    text: job.title,
                    fontSize: 14,
                    enabled: enabled,
                    callback: (value) => job.title = value,
                  ),
                ],
              ),
            ),
            const SizedBox(width: PaddingSizes.extraBigPadding),
            washerArea,
            const SizedBox(width: PaddingSizes.extraBigPadding),
            const Spacer(),
          ],
        ),
        const SizedBox(height: PaddingSizes.extraBigPadding),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InputTitleText("Recruitment Period"),
                  GestureDetector(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ).then((value) {
                        setState(() {
                          job.startTime = value?.millisecondsSinceEpoch;
                        });

                        if (value == null) return;

                        showDatePicker(
                          context: context,
                          firstDate: DateTime.fromMillisecondsSinceEpoch(
                              job.startTime ?? 0),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        ).then((value) => setState(
                            () => job.endTime = value?.millisecondsSinceEpoch));
                      });
                    },
                    child: InputTextForm(
                      hint: "Jul, 10 - Jul, 12",
                      text: "$startFormatted - $endFormatted",
                      fontSize: 14,
                      enabled: false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: PaddingSizes.extraBigPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InputTitleText("Time Period"),
                  Row(
                    children: [
                      // Expanded(
                      //   child: InputTextForm(
                      //     hint: "July 10",
                      //     text: viewing.startdate,
                      //     fontSize: 14,
                      //     enabled: enabled,
                      //     callback: (value) => newInfo.startdate = value,
                      //   ),
                      // ),
                      const SizedBox(width: PaddingSizes.mainPadding),
                      // Expanded(
                      //   child: InputTextForm(
                      //     hint: "12:00 - 13:00",
                      //     text: "${viewing.starttime} - ${viewing.endtime}",
                      //     fontSize: 14,
                      //     enabled: enabled,
                      //     callback: (value) {
                      //       final split = value.split(" - ");
                      //       newInfo.starttime = split[0];
                      //       newInfo.endtime = split[1];
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: PaddingSizes.extraBigPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InputTitleText("Customer"),
                  DropdownInputField(
                    callback: (value) {
                      setState(() {
                        job.customerId = value;
                      });
                    },
                    value: job.customerId,
                    hint: "Customer",
                    options: customers,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: PaddingSizes.extraBigPadding),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InputTitleText("Street Address"),
                  InputTextForm(
                    hint: "Vinkstraat 55",
                    text: job.address.streetName,
                    fontSize: 14,
                    enabled: enabled,
                    callback: (value) => job.address.streetName = value,
                  ),
                ],
              ),
            ),
            const SizedBox(width: PaddingSizes.extraBigPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InputTitleText("City"),
                  InputTextForm(
                    hint: "Kortrijk",
                    text: job.address.city,
                    fontSize: 14,
                    enabled: enabled,
                    callback: (value) => job.address.city = value,
                  ),
                ],
              ),
            ),
            const SizedBox(width: PaddingSizes.extraBigPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InputTitleText("Postcode"),
                  InputTextForm(
                    hint: "8500",
                    text: job.address.postalCode,
                    fontSize: 14,
                    enabled: enabled,
                    callback: (value) => job.address.postalCode = value,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: PaddingSizes.extraBigPadding),
        const InputTitleText("Job description"),
        TextFormField(
          minLines: 2,
          maxLines: 2,
          initialValue: job.description,
          enabled: enabled,
          onChanged: (value) => job.description = value,
        ),
      ],
    );
  }
}
