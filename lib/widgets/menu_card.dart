import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cart_mate/models/items_model.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/widgets/alert_boxes.dart';
import 'package:cart_mate/widgets/animated_toggle.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';
import '../utils/app_strings.dart';
import 'network_image.dart';
import 'package:get/get.dart';

class MenuCard extends StatefulWidget {
  final bool isMate;
  final Data mate;
  final void Function() onDelete;
  final void Function() onEdit;
  final Future<bool> Function() onStatusUpdate;
  const MenuCard({
    super.key,
    required this.isMate,
    required this.onDelete,
    required this.mate, required this.onEdit, required this.onStatusUpdate,
  });
  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  final homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Dismissible(
        key: Key(widget.mate.sId ?? ''),
        direction: DismissDirection.endToStart,
        background: Container(
          color: AppColors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 24),
        ),
        confirmDismiss: (direction) async {
          if((widget.mate.createdBy!.sId??'') == homeController.id.value){
            return await AlertBoxes.okCancelDialog(
              context: context,
              header: "Confirm Deletion",
              content: "Are you sure you want to delete this item?",
              onOk: () {
                widget.onDelete();
                Navigator.of(context).pop(true);
              },
              onCancel: () {
                Navigator.of(context).pop(false);
              },
            );
          }else{

            SnackBarWidget.show(
              context,
              title: AppStrings.actionRestricted,
              message: AppStrings.creatorCanDelete,
              contentType: ContentType.warning,
            );
          }
        },
        onDismissed: (direction) {},
        child: Container(
          decoration: ShapeDecoration(
            color: /*isList ? AppColors.listBg : AppColors.menuBg*/
                AppColors.white,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(45.0),
              side: BorderSide(width: 0.5, color: AppColors.black),
            ),
            shadows: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          40.0,
                        ), // Same as container
                      ),
                    ),
                    child:
                        /*widget.mate.imageUrl == null ||
                            widget.mate.imageUrl == ''
                        ? Image.asset(
                            "assets/images/defaultMenuImage.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : */Base64ImageCommon(
                          base64String: widget.mate.imageUrl??'',
                          defaultImage: "assets/images/defaultMenuImage.png",
                          fit: BoxFit.cover
                        ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 105,
                      child: Text(
                        widget.mate.name ?? "",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Image.asset("assets/images/assign.png", height: 14),
                        SizedBox(width: 5),
                        Text(
                          widget.isMate?(widget.mate.mateId!.name ?? ""):(((widget.mate.createdBy!.sId??'') == (widget.mate.mateId!.sId??''))?AppStrings.you: widget.mate.createdBy!.name ?? ""),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2),
              Spacer(),
              // isList? Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              // children: [
              // Row(
              // children: [
              // Text("14/24", style: TextStyle(fontSize: 16),),
              // SizedBox(width: 10,),
              // AnimatedToggle(),
              // more()
              // ],
              // ),
              // Padding(
              // padding: const EdgeInsets.only(top: 3.0, right: 10, bottom: 4),
              // child: ProgressWidget(progress: 60,),
              // )
              // ],
              // ) :
              Row(
                children: [
                  Container(
                    width: 60,
                    padding: EdgeInsets.all(3),
                    decoration: ShapeDecoration(
                      color: AppColors.white,
                      shape: ContinuousRectangleBorder(
                        side: BorderSide(color: AppColors.black),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.mate.quantity} ${widget.mate.uomId!.code ?? ''}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return  AnimatedToggle(
                        isOn: widget.mate.status??false,
                        onChanged: (value) async {
                          if(widget.isMate){
                            SnackBarWidget.show(
                              context,
                              title: "Not Allowed",
                              message: "This item is assigned to another mate. Only they can update.",
                              contentType: ContentType.warning,
                            );
                          }else{
                            bool result = await widget.onStatusUpdate();
                            if(result){
                              setState(() {
                                widget.mate.status = value;
                              });
                            }
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(
                    width: 35,
                    child: PopupMenuButton<String>(
                      color: AppColors.white,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.more_vert_outlined),
                      tooltip: 'Menu',
                      elevation: 4,
                      onSelected: (String result) async {
                        switch (result) {
                          case AppStrings.notes:{
                            AlertBoxes.okDialog(context: context, header: AppStrings.notes, content: widget.mate.notes??'',
                                onOk: () {
                                  Navigator.of(context).pop(true);
                                },);
                            break;
                          }
                          case AppStrings.info:{
                            AlertBoxes.okDialogWithDialog(context: context, header: AppStrings.info, content: Column(
                              children: [
                                Row(children: [
                                  Text("Unit:   ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                  Text("${(widget.mate.uomId!.code ?? '')} - ${(widget.mate.uomId!.unit ?? '')}", style: TextStyle(fontSize: 16),),
                                ],),
                                Row(children: [
                                  Text("Updated time:   ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                  Text(DateFormat('hh:mm a').format(DateTime.parse(widget.mate.updatedAt??'').toLocal()), style: TextStyle(fontSize: 16),),
                                ],),
                                Row(children: [
                                  Text("Updated date:   ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                  Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.mate.updatedAt??'').toLocal()), style: TextStyle(fontSize: 16),),
                                ],),
                              ],
                            ),
                              onOk: () {
                                Navigator.of(context).pop(true);
                              },);
                            break;
                          }
                          case AppStrings.edit:{
                            widget.onEdit();
                            break;
                          }
                          case AppStrings.delete:{
                            await AlertBoxes.okCancelDialog(
                                context: context,
                                header: "Confirm Deletion",
                                content: "Are you sure you want to delete this item?",
                                onOk: () {
                                  widget.onDelete();
                                  Navigator.of(context).pop(true);
                                },
                                onCancel: () {
                                  Navigator.of(context).pop(false);
                                },
                              );
                            break;
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        if (((widget.mate.notes ?? '') != '' && (widget.mate.notes ?? '') != null))
                          const PopupMenuItem<String>(value: AppStrings.notes, child: Text(AppStrings.notes)),
                        const PopupMenuItem<String>(value: AppStrings.info, child: Text(AppStrings.info)),
                        if((widget.mate.createdBy!.sId??'') == homeController.id.value && (widget.mate.status??false) == false )
                          const PopupMenuItem<String>(value: AppStrings.edit, child: Text(AppStrings.edit)),
                        const PopupMenuItem<String>(value: AppStrings.delete, child: Text(AppStrings.delete)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
