import 'package:flutter/material.dart';
import 'package:flutter_package_gaw_ui/flutter_package_gaw_ui.dart';

class CustomerCreateDialog extends StatefulWidget {
  const CustomerCreateDialog({super.key});

  @override
  State<CustomerCreateDialog> createState() => _CustomerCreateDialogState();
}

class _CustomerCreateDialogState extends State<CustomerCreateDialog>
    with SingleTickerProviderStateMixin {
  int index = 0;

  late final AnimationController page1Controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final Animation<double> page1Animation = CurvedAnimation(
    parent: page1Controller,
    curve: Curves.fastOutSlowIn,
  );

  late final AnimationController page2Controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final Animation<double> page2Animation = CurvedAnimation(
    parent: page1Controller,
    curve: Curves.fastOutSlowIn,
  );

  late final AnimationController page3Controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final Animation<double> page3Animation = CurvedAnimation(
    parent: page1Controller,
    curve: Curves.fastOutSlowIn,
  );

  late final AnimationController page4Controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final Animation<double> page4Animation = CurvedAnimation(
    parent: page1Controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    Future(() {
      page1Controller.forward();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 420,
        width: 560,
        decoration: BoxDecoration(
          color: GawTheme.clearBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                height: 360,
                width: constraints.maxWidth,
                child: Row(
                  children: [
                    SizeTransition(
                      axisAlignment: -1,
                      axis: Axis.horizontal,
                      sizeFactor: page1Animation,
                      child: Container(
                        height: 100,
                        width: index == 0 ? constraints.maxWidth : 0,
                        color: Colors.red,
                      ),
                    ),
                    SizeTransition(
                      axisAlignment: -1,
                      axis: Axis.horizontal,
                      sizeFactor: page1Animation,
                      child: Container(
                        height: 100,
                        width: index == 1 ? constraints.maxWidth : 0,
                        color: Colors.blue,
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: page3Animation,
                      child: Expanded(
                        child: Container(color: Colors.green),
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: page4Animation,
                      child: Expanded(
                        child: Container(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              child: InkWell(
                onTap: () {
                  switch (index) {
                    case 0:
                      {
                        setState(() {
                          index = 1;
                        });
                        return;
                      }
                  }
                },
                child: Container(
                  height: 42,
                  width: 120,
                  decoration: const BoxDecoration(
                    color: GawTheme.mainTint,
                  ),
                  child: const MainText('Press'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
