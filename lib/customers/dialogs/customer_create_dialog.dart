import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/dialogs/base_dialog.dart';
import 'package:flutter_gaw_cms/customers/dialogs/wizard_items/add_customer_wizard_item.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:tuple/tuple.dart';

class CustomerCreateDialog extends StatefulWidget {
  const CustomerCreateDialog({super.key});

  @override
  State<CustomerCreateDialog> createState() => _CustomerCreateDialogState();
}

class _CustomerCreateDialogState extends State<CustomerCreateDialog>
    with TickerProviderStateMixin {
  int index = 0;

  List<Tuple2<AnimationController, Animation>> pageControllers = [];

  void _createControllers() {
    for(int i = 0; i < 4; i++) {
      AnimationController controller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );

      pageControllers.add(
        Tuple2(
        controller,
        CurvedAnimation(
        parent: controller,
          curve: Curves.fastOutSlowIn,
        ),
      ),);
    }
  }

  @override
  void initState() {
    Future(() {
      pageControllers.first.item1.forward();
    });
    _createControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
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
                      sizeFactor: pageControllers[0].item1,
                      child: SizedBox(
                        width: index == 0 ? width : 0,
                        child: const AddCustomerWizardItem(),
                      ),
                    ),
                    SizeTransition(
                      axisAlignment: -1,
                      axis: Axis.horizontal,
                      sizeFactor: pageControllers[1].item1,
                      child: Container(
                        height: 100,
                        width: index == 1 ? width : 0,
                        color: Colors.blue,
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: pageControllers[2].item1,
                      child: Expanded(
                        child: Container(color: Colors.green),
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: pageControllers[3].item1,
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
    );
  }
}
