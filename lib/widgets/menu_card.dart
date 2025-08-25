import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/widgets/alert_boxes.dart';
import 'package:cart_mate/widgets/animated_toggle.dart';
import 'package:cart_mate/widgets/progress_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final bool isList;
  final String name;
  final String? image;
  final String mateName;
  final void Function() onDelete;

  const MenuCard({
    super.key,
    required this.isList,
    required this.name,
    this.image,
    required this.mateName, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Dismissible(
          key: Key(name),
          direction: DismissDirection.endToStart,
          background: Container(
            color: AppColors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 24,
            ),
          ),
          confirmDismiss:
              (direction) async {
            return await AlertBoxes.okCancelDialog(context: context, header: "Confirm Deletion", content: "Are you sure you want to delete this item?", onOk: (){onDelete(); Navigator.of(context).pop(true);}, onCancel: (){Navigator.of(context).pop(false);});

          },
          onDismissed: (direction) {
          },
        child: Container(
          decoration: ShapeDecoration(
            color: isList ? AppColors.listBg : AppColors.menuBg,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(45.0),
            ),
            shadows: const [
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
               Container(
                      height: 75,
                      width: 75,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipPath(
                          clipper: ShapeBorderClipper(
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                40.0,
                              ), // Same as container
                            ),
                          ),
                          child:image == null || image == ''
                              ? Image.asset(
                            "assets/images/defaultMenuImage.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ): Image.asset(
                            "assets/images/defaultMenuImage.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(name, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Image.asset("assets/images/assign.png", height: 14),
                      SizedBox(width: 5),
                      Text(mateName, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
              Spacer(),
              isList? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text("14/24", style: TextStyle(fontSize: 16),),
                      SizedBox(width: 10,),
                      AnimatedToggle(),
                      more()
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, right: 10, bottom: 4),
                    child: ProgressWidget(progress: 60,),
                  )
                ],
              ) : Row(
                children: [
                  uom(),
                  SizedBox(width: 10,),
                  AnimatedToggle(),
                  more()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget more() {
    return
      InkWell(onTap: (){},  child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.more_vert_outlined, size: 24,),
      ));
  }

  Widget uom(){
    return
      Container(
        child: Text("50kg"),
        padding: EdgeInsets.all(9),
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      );
  }
}
