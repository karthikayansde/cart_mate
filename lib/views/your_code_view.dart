import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/widgets/alert_boxes.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/shared_pref_manager.dart';


class YourCodeView extends StatefulWidget {
  const YourCodeView({super.key});

  @override
  _YourCodeViewState createState() => _YourCodeViewState();
}

class _YourCodeViewState extends State<YourCodeView> {
  @override
  void initState() {
    init();
    super.initState();
  }
  Future<void> init() async {
    code = await SharedPrefManager.instance.getStringAsync(SharedPrefManager.code)??'';
    setState(() {});
  }
  String code = '';
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child:
      SizedBox(
        height: 200,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                "assets/images/animatedBg.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.maxFinite,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppStrings.yourCode, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      Text(code, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                      SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BasicButtonWidget(
                            width: 120,
                            elevation: true,
                            color: AppColors.listBg,
                            onPressed: () {

                              // Copy text to clipboard
                              Clipboard.setData(ClipboardData(text: code)).then((_) {
                                AlertBoxes.okDialog(context: context, header: "Text copied to clipboard!", content: '', onOk: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },);
                              });
                            },
                            labelColor: AppColors.black,
                            label: AppStrings.copy,
                          ),
                          SizedBox(height: 10,),
                          BasicButtonWidget(
                            width: 120,
                            elevation: true,
                            color: AppColors.menuBg,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            labelColor: AppColors.black,
                            label: AppStrings.ok,
                          ),
                        ],
                      ),
                      SizedBox(height: 10,)

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}