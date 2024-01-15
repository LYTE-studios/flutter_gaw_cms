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
  });
}

enum JobStatus {
  draft,
  active,
  done;
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
      ),
    ]);

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
          JobPopup(),
        ],
      ),
    );
  }
}

class JobPopup extends StatelessWidget {
  const JobPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupSheet(
      maxWidth: 700,
      maxHeight: 500,
      visible: false,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: SvgImage("TODO"),
          ),
          Row(
            children: [
              SvgImage("TODO"),
              Text("Job Info"),
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
                      children: [
                        const MainText("Job Details"),
                        AppInputField(
                          hint: "Wash get driven 4 auto's",
                          controller: TextEditingController(text: ""),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [Text("Washers"), Text("Something else ")],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const MainText("Recruitment Period"),
                        AppInputField(
                          hint: "Wash get driven 4 auto's",
                          controller: TextEditingController(text: ""),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const MainText("Time Period"),
                        Row(
                          children: [
                            Expanded(
                              child: AppInputField(
                                hint: "Wash get driven 4 auto's",
                                controller: TextEditingController(text: ""),
                              ),
                            ),
                            Expanded(
                              child: AppInputField(
                                hint: "Wash get driven 4 auto's",
                                controller: TextEditingController(text: ""),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const MainText("Customer"),
                        AppInputField(
                          hint: "Jan Van den Steen",
                          controller: TextEditingController(text: ""),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [],
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

    List<JobCard> widgets = [];
    for (final info in infos) {
      if (filter == null || info.status == filter) {
        widgets.add(JobCard(info: info));
      }
    }

    return Row(
      children: [
        Column(
          children: widgets,
        ),
      ],
    );
  }
}

class JobCard extends StatelessWidget {
  final JobInfo info;
  const JobCard({
    required this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
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
                MainText(
                  info.name,
                  fontWeight: FontWeight.w600,
                ),
                MainText(
                  "${info.start} - ${info.end}",
                  color: GawTheme.secondaryTint,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            const SizedBox(height: PaddingSizes.mainPadding),
            Row(children: locations),
            const SizedBox(height: PaddingSizes.bigPadding),
            MainText(info.description),
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
                ),
                GenericButton(
                  label: "Edit",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
