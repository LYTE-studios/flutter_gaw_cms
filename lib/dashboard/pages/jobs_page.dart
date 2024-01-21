import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage jobsBeamPage = BeamPage(
  title: 'Jobs',
  key: ValueKey('jobs'),
  type: BeamPageType.noTransition,
  child: JobsPage(),
);

class JobsPage extends ConsumerStatefulWidget {
  const JobsPage({super.key});

  static const String route = '/dashboard/jobs';

  @override
  ConsumerState<JobsPage> createState() => _JobsPageState();
}

class WasherInfo {
  String name;
  Image profilePicture;
  String start;
  String end;

  WasherInfo({
    required this.name,
    required this.profilePicture,
    required this.start,
    required this.end,
  });
}

final currentlyCreatingProvider = StateProvider<bool>((ref) => false);
final currentlyEditingProvider = StateProvider<Job?>((ref) => null);
final currentlyDeletingProvider = StateProvider<Job?>((ref) => null);
final washerFocusProvider = StateProvider<WasherInfo?>((ref) => null);

class _JobsPageState extends ConsumerState<JobsPage> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return BaseLayoutScreen(
      child: Stack(
        children: [
          ScreenSheet(
            hasBackground: false,
            topPadding: CmsHeader.headerHeight + 8,
            child: Stack(
              children: [
                Positioned(
                  top: 4,
                  right: 10,
                  child: GenericButton(
                    label: "Add",
                    onTap: () {
                      ref.read(currentlyCreatingProvider.notifier).state = true;
                    },
                    fontSize: 10.4,
                    minHeight: 31,
                  ),
                ),
                TabbedView(
                  tabs: const [
                    'All jobs',
                    // 'Active jobs',
                    // 'Done jobs',
                    // 'Drafts'
                  ],
                  pages: const [
                    JobsListingPage(),
                    // JobsListingPage(filter: JobState.ac),
                    // JobsListingPage(filter: JobStatus.done),
                    // JobsListingPage(filter: JobStatus.draft),
                  ],
                  selectedIndex: selectedPage,
                  onPageIndexChange: (int index) {
                    setState(() {
                      selectedPage = index;
                    });
                  },
                ),
              ],
            ),
          ),
          const JobPopup(),
          JobCreatePopup(),
          const JobDeletePopup(),
          const WasherPopup(),
        ],
      ),
    );
  }
}

class JobSettingsState extends StatefulWidget {
  JobSettingsState({super.key});

  final CreateJobRequestBuilder job = CreateJobRequestBuilder();

  void createJob(bool draft) {
    job.isDraft = draft;
    JobsApi.createJob(request: job.build());
  }

  @override
  State<JobSettingsState> createState() => JobSettingsWidget();
}

class JobSettingsWidget extends State<JobSettingsState> {
  // final Job viewing;
  // JobSettingsWidget({
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

    String startFormatted = DateFormat("dd-MM-yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(job.startTime ?? 0));

    String endFormatted = DateFormat("dd-MM-yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(job.endTime ?? 0));

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

class JobDeletePopup extends ConsumerWidget {
  const JobDeletePopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Job? deleting = ref.watch(currentlyDeletingProvider);

    return PopupSheet(
      maxWidth: 421,
      maxHeight: 231,
      visible: deleting != null,
      child: Column(
        children: [
          const PopupTitleText(
            "Are you sure you want to delete this job?",
            fontWeight: FontWeight.w600,
            fontSize: 17,
            paddingBottom: 36,
          ),
          const MainText(
              "This will delete this job permanently. You cannot undo this action."),
          Row(
            children: [
              GenericButton(
                label: "Delete",
                color: GawTheme.error,
                onTap: () {
                  // ref.read(currentlyDeletingProvider.notifier).state = null;
                  // ref.read(jobsProvider.notifier).state.remove(deleting);

                  // Force update
                  // ref
                  //     .read(jobsProvider.notifier)
                  //     .update((state) => state.toList());
                },
              ),
              const SizedBox(width: PaddingSizes.mainPadding),
              GenericButton(
                label: "Cancel",
                onTap: () {
                  ref.read(currentlyDeletingProvider.notifier).state = null;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WasherWidget extends StatelessWidget {
  final WasherInfo info;

  const WasherWidget({
    required this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(color: GawTheme.border, width: 1),
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: info.profilePicture,
                  ),
                  const SizedBox(width: PaddingSizes.mainPadding),
                  MainText(
                    info.name,
                    color: GawTheme.specialText,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: PaddingSizes.mainPadding),
      ],
    );
  }
}

class JobPopup extends ConsumerWidget {
  const JobPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Job? viewing = ref.watch(currentlyEditingProvider);

    if (viewing == null && true) {
      return Container();
    }

    // JobSettingsWidget settings = JobSettingsWidget(viewing: viewing);
    JobSettingsState settings = JobSettingsState();

    Widget title;
    bool draft = viewing.isDraft ?? true;
    if (draft) {
      title = const PopupTitleText("Job Draft",
          icon: SvgImage(PixelPerfectIcons.editNormal));
    } else {
      title = const PopupTitleText("Job Info",
          icon: SvgImage(PixelPerfectIcons.info));
    }

    Widget footer = Container();
    if (draft) {
      footer = Column(
        children: [
          const SizedBox(height: 41),
          Row(
            children: [
              GenericButton(
                label: "Save",
                onTap: () {
                  //settings.updateDetails(ref);
                  ref.read(currentlyEditingProvider.notifier).state = null;
                },
              ),
              const SizedBox(width: PaddingSizes.mainPadding),
              GenericButton(
                label: "Cancel",
                onTap: () {
                  ref.read(currentlyEditingProvider.notifier).state = null;
                },
              ),
            ],
          ),
        ],
      );
    }

    return PopupSheet(
      maxWidth: 1131,
      maxHeight: 689,
      visible: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: title,
              ),
              Container(
                alignment: Alignment.topRight,
                child: TextButton(
                  child: const SvgIcon(
                    PixelPerfectIcons.xNormal,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    ref.read(currentlyEditingProvider.notifier).state = null;
                  },
                ),
              ),
            ],
          ),
          settings,
          footer,
        ],
      ),
    );
  }
}

class JobCreatePopup extends ConsumerWidget {
  JobCreatePopup({super.key});

  final settings = JobSettingsState(/*viewing: viewing*/);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget footer = Row(
      children: [
        GenericButton(
          onTap: () {
            settings.createJob(false);
          },
          label: "Create",
        ),
        GenericButton(
          onTap: () {
            settings.createJob(true);
          },
          label: "Safe as draft",
        ),
      ],
    );

    return PopupSheet(
      maxWidth: 1131,
      maxHeight: 689,
      visible: ref.watch(currentlyCreatingProvider),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PopupTitleText("Create Job"),
              Container(
                alignment: Alignment.topRight,
                child: TextButton(
                  child: const SvgIcon(
                    PixelPerfectIcons.xNormal,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    ref.read(currentlyCreatingProvider.notifier).state = false;
                  },
                ),
              ),
            ],
          ),
          settings,
          footer,
        ],
      ),
    );
  }
}

class WasherPopup extends ConsumerWidget {
  const WasherPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WasherInfo? info = ref.watch(washerFocusProvider);

    if (info == null) {
      return Container();
    }

    return PopupSheet(
      maxWidth: 1131,
      maxHeight: 689,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          children: [
            TextButton(
              child: const Row(
                children: [
                  SvgIcon(PixelPerfectIcons.arrowBack),
                  SizedBox(width: 15),
                  MainText("Back"),
                ],
              ),
              onPressed: () {
                ref.read(washerFocusProvider.notifier).state = null;
              },
            ),
            const SizedBox(height: 68),
            Text(info.name),
            const SizedBox(height: 54),
            Row(
              children: [
                const MainText(
                  "From:",
                  color: GawTheme.text,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
                MainText(
                  info.start,
                  color: GawTheme.mainTint,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(width: 42),
                const MainText(
                  "Until:",
                  color: GawTheme.text,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
                MainText(
                  info.end,
                  color: GawTheme.mainTint,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            SizedBox(height: 66),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 450,
                  height: 255,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: GawTheme.toolBarItem),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: const Text("Washer Signature"),
                ),
                Container(
                  width: 450,
                  height: 255,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: GawTheme.toolBarItem),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: const Text("Client Signature"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class JobsListingPage extends StatefulWidget {
  const JobsListingPage({super.key});

  @override
  State<JobsListingPage> createState() => JobsListingPageWidget();
}

class JobsListingPageWidget extends State<JobsListingPage> {
  // final JobState? filter;

  // const JobsListingPage({
  //   // this.filter,
  //   super.key,
  // });

  JobsListingPageWidget() {
    updateJobs();
  }

  List<Job> jobs = [];

  void updateJobs() {
    JobsApi.getJobs(request: UserBasedJobsRequest()).then((value) {
      setState(() {
        print(value);
        value?.jobs?.forEach((j) {
          jobs.add(j);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (final info in jobs) {
      // if (filter == null || info.status == filter) {
      widgets.add(Flexible(child: JobCard(info: info)));
      // }
    }

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        direction: Axis.horizontal,
        children: widgets,
      ),
    );
  }
}

class JobCard extends ConsumerWidget {
  final Job info;
  const JobCard({
    required this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> locations = [];

    for (final location in info.address.formattedAddres().split(" ")) {
      locations.add(
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: GawTheme.unselectedMainTint,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingSizes.mainPadding,
                vertical: PaddingSizes.extraSmallPadding,
              ),
              child: MainText(
                location,
                color: GawTheme.clearText,
                fontWeight: FontWeight.w600,
                fontSize: 9,
              ),
            ),
            const SizedBox(width: PaddingSizes.extraSmallPadding),
          ],
        ),
      );
    }

    String statusString = "";
    Color statusColour = GawTheme.mainTint;

    if (info.isDraft ?? true) {
      statusString = "Draft";
      statusColour = GawTheme.error;
    } else if (info.state == JobState.pending) {
      statusString = "Active";
      statusColour = GawTheme.success;
    }

    String abbreviation =
        (info.title ?? " ").split(" ").map((e) => e[0]).join();

    return Padding(
      padding: const EdgeInsets.all(PaddingSizes.mainPadding),
      child: Container(
        width: 307,
        padding: const EdgeInsets.all(PaddingSizes.extraBigPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: GawTheme.clearText,
          border: Border.all(color: GawTheme.background),
          boxShadow: const [BoxShadow(color: GawTheme.shadow)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: GawTheme.darkBackground,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: MainText(
                    abbreviation,
                    color: GawTheme.clearText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  "duplicate draft",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              child: MainText(
                DateFormat("dd/MM/yyyy").format(
                    DateTime.fromMillisecondsSinceEpoch(info.startTime)),
                color: GawTheme.secondaryTint,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(info.title ?? "",
                    fontWeight: FontWeight.w600, fontSize: 14),
                MainText(
                    "${DateFormat("hh:mm").format(DateTime.fromMillisecondsSinceEpoch(info.startTime))} - ${DateFormat("hh:mm").format(DateTime.fromMillisecondsSinceEpoch(info.endTime))}",
                    color: GawTheme.secondaryTint,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.3),
              ],
            ),
            const SizedBox(height: PaddingSizes.mainPadding),
            Row(children: locations),
            const SizedBox(height: PaddingSizes.bigPadding),
            MainText(info.description ?? "", fontSize: 12.3),
            const SizedBox(height: PaddingSizes.bigPadding),
            Row(
              children: [
                const SvgImage(PixelPerfectIcons.personMedium),
                const SizedBox(width: PaddingSizes.extraSmallPadding),
                Text("${info.selectedWashers}/${info.maxWashers}"),
                const SizedBox(width: PaddingSizes.extraBigPadding),
                Container(
                  width: 72,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.79),
                    border: Border.all(
                      color: statusColour,
                      width: 1.758,
                    ),
                  ),
                  child: MainText(
                    statusString,
                    color: statusColour,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: PaddingSizes.mainPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GenericButton(
                  label: "Delete",
                  fontSize: 10.5,
                  minHeight: 35,
                  color: GawTheme.error,
                  onTap: () {
                    ref.read(currentlyDeletingProvider.notifier).state = info;
                  },
                ),
                EditButton(
                  onTap: () {
                    ref.read(currentlyEditingProvider.notifier).state = info;
                  },
                  label: "Edit",
                  fontSize: 10.5,
                  minHeight: 35,
                  color: Colors.transparent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
