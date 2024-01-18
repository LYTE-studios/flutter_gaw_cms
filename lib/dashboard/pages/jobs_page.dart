import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/screens/base_layout_screen.dart';
import 'package:flutter_gaw_cms/core/widgets/utility_widgets/cms_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaw_ui/gaw_ui.dart';

const BeamPage jobsBeamPage = BeamPage(
  title: 'Jobs',
  key: ValueKey('jobs'),
  type: BeamPageType.noTransition,
  child: JobsPage(),
);

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  static const String route = '/dashboard/jobs';

  @override
  State<JobsPage> createState() => _JobsPageState();
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

class JobInfo {
  String details;
  String abbreviation;
  String name;
  String startdate;
  String enddate;
  String starttime;
  String endtime;
  List<String> places;
  String description;
  int washerCount;
  int maxWasherCount;
  JobStatus status;
  List<WasherInfo> washers;

  JobInfo({
    this.details = "",
    this.abbreviation = "",
    this.name = "",
    this.startdate = "",
    this.enddate = "",
    this.starttime = "",
    this.endtime = "",
    this.places = const ["", "", ""],
    this.description = "",
    this.washerCount = 0,
    this.maxWasherCount = 0,
    this.status = JobStatus.draft,
    this.washers = const [],
  });

  JobInfo copy() {
    return JobInfo(
      details: details,
      abbreviation: abbreviation,
      name: name,
      startdate: startdate,
      enddate: enddate,
      starttime: starttime,
      endtime: endtime,
      places: places.toList(),
      description: description,
      washerCount: washerCount,
      maxWasherCount: maxWasherCount,
      status: status,
      washers: washers.toList(),
    );
  }
}

enum JobStatus {
  draft,
  active,
  done,
}

final jobsProvider = StateProvider<List<JobInfo>>((ref) => [
      JobInfo(
        abbreviation: "SM",
        name: "Stieg Martens",
        startdate: "28/03/2023",
        enddate: "30/03/2023",
        starttime: "14:00",
        endtime: "18:00",
        places: ["Kortrijk", "Mellestraat 30", "8500"],
        description: "Garage Vandenplas needs 3 washers from 14-18pm",
        washerCount: 0,
        maxWasherCount: 3,
        status: JobStatus.draft,
      ),
      JobInfo(
        abbreviation: "SM",
        name: "Stieg Martens",
        startdate: "28/03/2023",
        enddate: "30/03/2023",
        starttime: "14:00",
        endtime: "18:00",
        places: ["Kortrijk", "Mellestraat 30", "8500"],
        description: "Garage Vandenplas needs 3 washers from 14-18pm",
        washerCount: 3,
        maxWasherCount: 3,
        status: JobStatus.active,
        washers: [
          WasherInfo(
            name: "Theresa Webb",
            profilePicture: Image.network(
              "https://i.pinimg.com/474x/cd/20/d6/cd20d6bc40d4a51b8a39daab77c44ecd.jpg",
            ),
            start: "11:30",
            end: "15:30",
          ),
          WasherInfo(
            name: "Theresa Webb",
            profilePicture: Image.network(
                "https://i.pinimg.com/474x/cd/20/d6/cd20d6bc40d4a51b8a39daab77c44ecd.jpg"),
            start: "12:30",
            end: "16:30",
          ),
        ],
      ),
    ]);

final currentlyEditingProvider = StateProvider<JobInfo?>((ref) => null);
final currentlyDeletingProvider = StateProvider<JobInfo?>((ref) => null);
final washerFocusProvider = StateProvider<WasherInfo?>((ref) => null);

class _JobsPageState extends State<JobsPage> {
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
                const Positioned(
                  top: 4,
                  right: 10,
                  child: GenericButton(
                    label: "Add",
                    fontSize: 10.4,
                    minHeight: 31,
                  ),
                ),
                TabbedView(
                  tabs: const [
                    'All jobs',
                    'Active jobs',
                    'Done jobs',
                    'Drafts'
                  ],
                  pages: const [
                    JobsListingPage(),
                    JobsListingPage(filter: JobStatus.active),
                    JobsListingPage(filter: JobStatus.done),
                    JobsListingPage(filter: JobStatus.draft),
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
          const JobDeletePopup(),
          const WasherPopup(),
        ],
      ),
    );
  }
}

class JobSettingsWidget extends ConsumerWidget {
  final JobInfo viewing;
  JobSettingsWidget({
    required this.viewing,
    super.key,
  });

  late final JobInfo newInfo = viewing.copy();

  void updateDetails(WidgetRef ref) {
    List<JobInfo> jobs = ref.read(jobsProvider);
    int index = jobs.indexWhere((element) => element == viewing);
    if (index == -1) {
      jobs.add(newInfo);
    } else {
      jobs[index] = newInfo;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget washerArea;
    if (viewing.status == JobStatus.active) {
      List<Widget> widgets = [];
      for (final washer in viewing.washers) {
        widgets.add(
          TextButton(
            onPressed: () {
              ref.read(washerFocusProvider.notifier).state = washer;
            },
            child: WasherWidget(info: washer),
          ),
        );
      }

      washerArea = Expanded(
        flex: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InputTitleText("Washers"),
            Row(children: widgets),
          ],
        ),
      );
    } else {
      washerArea = Expanded(
        flex: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InputTitleText("Needed washers for the job"),
            InputTextForm(
              hint: "#",
              text: viewing.maxWasherCount.toString(),
              fontSize: 14,
              callback: (value) =>
                  newInfo.maxWasherCount = int.tryParse(value) ?? 0,
            ),
          ],
        ),
      );
    }

    bool enabled = viewing.status == JobStatus.draft;

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
                  const InputTitleText("Job Details"),
                  InputTextForm(
                    hint: "Wash get driven 4 auto's",
                    text: viewing.details,
                    fontSize: 14,
                    enabled: enabled,
                    callback: (value) => newInfo.details = value,
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
                  InputTextForm(
                    hint: "Jul, 10 - Jul, 12",
                    text: "${viewing.startdate} - ${viewing.enddate}",
                    fontSize: 14,
                    enabled: enabled,
                    callback: (value) {
                      final split = value.split(" - ");
                      newInfo.startdate = split[0];
                      newInfo.enddate = split[1];
                    },
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
                      Expanded(
                        child: InputTextForm(
                          hint: "July 10",
                          text: viewing.startdate,
                          fontSize: 14,
                          enabled: enabled,
                          callback: (value) => newInfo.startdate = value,
                        ),
                      ),
                      const SizedBox(width: PaddingSizes.mainPadding),
                      Expanded(
                        child: InputTextForm(
                          hint: "12:00 - 13:00",
                          text: "${viewing.starttime} - ${viewing.endtime}",
                          fontSize: 14,
                          enabled: enabled,
                          callback: (value) {
                            final split = value.split(" - ");
                            newInfo.starttime = split[0];
                            newInfo.endtime = split[1];
                          },
                        ),
                      ),
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
                  InputTextForm(
                    hint: "Customer",
                    text: viewing.name,
                    fontSize: 14,
                    enabled: enabled,
                    callback: (value) => newInfo.name = value,
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
                    text: viewing.places[0],
                    fontSize: 14,
                    enabled: enabled,
                    callback: (value) => newInfo.places[0] = value,
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
                    text: viewing.places[1],
                    fontSize: 14,
                    enabled: enabled,
                    callback: (value) => newInfo.places[1] = value,
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
                    text: viewing.places[2],
                    fontSize: 14,
                    enabled: enabled,
                    callback: (value) => newInfo.places[2] = value,
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
          decoration: InputDecoration(labelText: viewing.description),
          enabled: enabled,
          onChanged: (value) => newInfo.description = value,
        ),
      ],
    );
  }
}

class JobDeletePopup extends ConsumerWidget {
  const JobDeletePopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    JobInfo? deleting = ref.watch(currentlyDeletingProvider);

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
                  ref.read(currentlyDeletingProvider.notifier).state = null;
                  ref.read(jobsProvider.notifier).state.remove(deleting);

                  // Force update
                  ref
                      .read(jobsProvider.notifier)
                      .update((state) => state.toList());
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
    JobInfo? viewing = ref.watch(currentlyEditingProvider);

    if (viewing == null && true) {
      return Container();
    }

    JobSettingsWidget settings = JobSettingsWidget(viewing: viewing);

    Widget title;
    if (viewing.status == JobStatus.draft) {
      title = const PopupTitleText("Job Draft",
          icon: SvgImage(PixelPerfectIcons.editNormal));
    } else {
      title = const PopupTitleText("Job Info",
          icon: SvgImage(PixelPerfectIcons.info));
    }

    Widget footer = Container();
    if (viewing.status == JobStatus.draft) {
      footer = Column(
        children: [
          const SizedBox(height: 41),
          Row(
            children: [
              GenericButton(
                label: "Save",
                onTap: () {
                  settings.updateDetails(ref);
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
  const JobCreatePopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    JobInfo viewing = JobInfo();

    Widget footer = Container();

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
              const PopupTitleText("Create Job"),
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
          JobSettingsWidget(viewing: viewing),
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

class JobsListingPage extends ConsumerWidget {
  final JobStatus? filter;

  const JobsListingPage({
    this.filter,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<JobInfo> infos = ref.watch(jobsProvider);

    List<Widget> widgets = [];
    for (final info in infos) {
      if (filter == null || info.status == filter) {
        widgets.add(Flexible(child: JobCard(info: info)));
      }
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
  final JobInfo info;
  const JobCard({
    required this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> locations = [];

    for (final location in info.places) {
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

    String statusString;
    Color statusColour;

    switch (info.status) {
      case JobStatus.active:
        {
          statusString = "Active";
          statusColour = GawTheme.success;
        }
        break;
      case JobStatus.draft:
        {
          statusString = "Draft";
          statusColour = GawTheme.error;
        }
        break;
      default:
        {
          statusString = "";
          statusColour = GawTheme.mainTint;
        }
        break;
    }

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
                    info.abbreviation,
                    color: GawTheme.clearText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "duplicate draft",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              child: MainText(
                info.startdate,
                color: GawTheme.secondaryTint,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(info.name, fontWeight: FontWeight.w600, fontSize: 14),
                MainText("${info.starttime} - ${info.endtime}",
                    color: GawTheme.secondaryTint,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.3),
              ],
            ),
            const SizedBox(height: PaddingSizes.mainPadding),
            Row(children: locations),
            const SizedBox(height: PaddingSizes.bigPadding),
            MainText(info.description, fontSize: 12.3),
            const SizedBox(height: PaddingSizes.bigPadding),
            Row(
              children: [
                const SvgImage(PixelPerfectIcons.personMedium),
                const SizedBox(width: PaddingSizes.extraSmallPadding),
                Text("${info.washerCount}/${info.maxWasherCount}"),
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
