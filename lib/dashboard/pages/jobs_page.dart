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

  WasherInfo({
    required this.name,
    required this.profilePicture,
  });
}

class JobInfo {
  String abbreviation;
  String name;
  String date;
  String start;
  String end;
  List<String> places;
  String description;
  int washerCount;
  int maxWasherCount;
  JobStatus status;
  List<WasherInfo> washers;

  JobInfo({
    required this.abbreviation,
    required this.name,
    required this.date,
    required this.start,
    required this.end,
    required this.places,
    required this.description,
    required this.washerCount,
    required this.maxWasherCount,
    required this.status,
    this.washers = const [],
  });
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
        date: "28/03/2023",
        start: "14:00",
        end: "18:00",
        places: ["Kortrijk", "Mellestraat 30", "8500"],
        description: "Garage Vandenplas needs 3 washers from 14-18pm",
        washerCount: 0,
        maxWasherCount: 3,
        status: JobStatus.draft,
      ),
      JobInfo(
        abbreviation: "SM",
        name: "Stieg Martens",
        date: "28/03/2023",
        start: "14:00",
        end: "18:00",
        places: ["Kortrijk", "Mellestraat 30", "8500"],
        description: "Garage Vandenplas needs 3 washers from 14-18pm",
        washerCount: 3,
        maxWasherCount: 3,
        status: JobStatus.active,
        washers: [
          WasherInfo(
            name: "Theresa Webb",
            profilePicture: Image.network(
                "https://i.pinimg.com/474x/cd/20/d6/cd20d6bc40d4a51b8a39daab77c44ecd.jpg"),
          ),
          WasherInfo(
            name: "Theresa Webb",
            profilePicture: Image.network(
                "https://i.pinimg.com/474x/cd/20/d6/cd20d6bc40d4a51b8a39daab77c44ecd.jpg"),
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
            child: Column(
              children: [
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

    Widget title;
    Widget washerArea;
    if (viewing.status == JobStatus.active) {
      title = const Row(
        children: [
          SvgImage(PixelPerfectIcons.washers),
          PopupTitleText("Job Info"),
        ],
      );

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
            Row(
              children: widgets,
            )
          ],
        ),
      );
    } else {
      title = const Row(
        children: [
          SvgImage(PixelPerfectIcons.editNormal),
          PopupTitleText("Job Draft"),
        ],
      );

      washerArea = const Expanded(
        flex: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputTitleText("Needed washers for the job"),
            InputTextForm(
              hint: "#",
              fontSize: 14,
            ),
          ],
        ),
      );
    }

    bool enabled = viewing.status == JobStatus.draft;

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
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputTitleText("Job Details"),
                        InputTextForm(
                          hint: "Wash get driven 4 auto's",
                          fontSize: 14,
                          enabled: enabled,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: PaddingSizes.extraBigPadding),
                  washerArea,
                  SizedBox(width: PaddingSizes.extraBigPadding),
                  Spacer(),
                ],
              ),
              SizedBox(height: PaddingSizes.extraBigPadding),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputTitleText("Recruitment Period"),
                        InputTextForm(
                          hint: "Jul, 10 - Jul, 12",
                          fontSize: 14,
                          enabled: enabled,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: PaddingSizes.extraBigPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputTitleText("Time Period"),
                        Row(
                          children: [
                            Expanded(
                              child: InputTextForm(
                                hint: "July 10",
                                fontSize: 14,
                                enabled: enabled,
                              ),
                            ),
                            SizedBox(width: PaddingSizes.mainPadding),
                            Expanded(
                              child: InputTextForm(
                                hint: "12:00 - 13:00",
                                fontSize: 14,
                                enabled: enabled,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: PaddingSizes.extraBigPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputTitleText("Customer"),
                        InputTextForm(
                          hint: "Customer",
                          fontSize: 14,
                          enabled: enabled,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: PaddingSizes.extraBigPadding),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputTitleText("Street Address"),
                        InputTextForm(
                          hint: "Vinkstraat 55",
                          fontSize: 14,
                          enabled: enabled,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: PaddingSizes.extraBigPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputTitleText("City"),
                        InputTextForm(
                          hint: "Kortrijk",
                          fontSize: 14,
                          enabled: enabled,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: PaddingSizes.extraBigPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputTitleText("Postcode"),
                        InputTextForm(
                          hint: "8500",
                          fontSize: 14,
                          enabled: enabled,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: PaddingSizes.extraBigPadding),
              const InputTitleText("Job description"),
              // InputTextForm(fontSize: 14),
              TextFormField(
                minLines: 6,
                maxLines: 6,
                enabled: enabled,
              ),
            ],
          ),
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
      child: Column(
        children: [
          TextButton(
            child: MainText("Back"),
            onPressed: () {
              ref.read(washerFocusProvider.notifier).state = null;
            },
          ),
          SizedBox(height: 68),
          Text(info.name),
          SizedBox(height: 54),
          Row(
            children: [
              Text("From: AAA"),
              SizedBox(width: 42),
              Text("To: AAA"),
            ],
          ),
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
                child: Text("Washer Signature"),
              ),
              Container(
                width: 450,
                height: 255,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: GawTheme.toolBarItem),
                ),
                child: Text("Client Signature"),
              ),
            ],
          )
        ],
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
                info.date,
                color: GawTheme.secondaryTint,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(info.name, fontWeight: FontWeight.w600, fontSize: 14),
                MainText("${info.start} - ${info.end}",
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
