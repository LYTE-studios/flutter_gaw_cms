import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/customers/dialogs/wizard_items/add_customer_wizard_item.dart';
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
        width: 720,
        decoration: BoxDecoration(
          color: GawTheme.clearBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingSizes.extraBigPadding * 2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              child: WizardHeader(
                items: const [
                  'Information',
                  'Address',
                  'Picture',
                  'Billing',
                ],
                selectedIndex: index,
              ),
            ),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                double width =
                    constraints.maxWidth - PaddingSizes.extraBigPadding;

                return SizedBox(
                  height: 360,
                  width: width,
                  child: Row(
                    children: [
                      SizeTransition(
                        axisAlignment: -1,
                        axis: Axis.horizontal,
                        sizeFactor: page1Animation,
                        child: SizedBox(
                          width: index == 0 ? width : 0,
                          child: const AddCustomerWizardItem(),
                        ),
                      ),
                      SizeTransition(
                        axisAlignment: -1,
                        axis: Axis.horizontal,
                        sizeFactor: page1Animation,
                        child: Container(
                          height: 100,
                          width: index == 1 ? width : 0,
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
            ),
            SizedBox(
              height: 120,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = index + 1;
                      });
                      return;
                    },
                    child: Container(
                      height: 42,
                      width: 156,
                      decoration: BoxDecoration(
                        color: GawTheme.mainTint,
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        boxShadow: const [
                          Shadows.lightShadow,
                        ],
                      ),
                      child: Center(
                        child: MainText(
                          'Next',
                          textStyleOverride: TextStyles.titleStyle.copyWith(
                            color: GawTheme.mainTintText,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: index > 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          index = index - 1;
                        });
                        return;
                      },
                      child: const SizedBox(
                        width: 72,
                        child: Center(
                          child: MainText(
                            'Back',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
