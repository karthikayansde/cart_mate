import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cart_mate/controllers/home_controller.dart';
import 'package:cart_mate/controllers/item_controller.dart';
import 'package:cart_mate/models/items_model.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/utils/app_validators.dart';
import 'package:cart_mate/widgets/button_widgets.dart';
import 'package:cart_mate/widgets/dropdown_widget.dart';
import 'package:cart_mate/widgets/loading_widget.dart';
import 'package:cart_mate/widgets/snack_bar_widget.dart';
import 'package:cart_mate/widgets/text_field_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mates_controller.dart';
import '../utils/app_input_formatters.dart';
import '../widgets/network_image.dart';

class ItemView extends StatefulWidget {
  const ItemView({super.key, required this.isEdit, required this.mate});

  final bool isEdit;
  final Data mate;

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  late final ItemController controller;
  late final MatesController matesController;
  late final HomeController homeController;
  List<String> matesList = [];
  List<String> uomList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(ItemController());
    matesController = Get.put(MatesController());
    homeController = Get.put(HomeController());
    init();
  }

  Future<void> init() async {
    controller.isLoading.value = true;
    await matesController.getMateApi(context);
    matesList = [AppStrings.you + "mzqxv9rklt8ph2wj" + homeController.id.value];
    controller.selectedMate.value = matesList[0];
    if(matesController.matesList.value.data != null){
      matesList.addAll(
        matesController.matesList.value.data!
            .map((e) => ((e.name ?? '') + "mzqxv9rklt8ph2wj" + (e.sId ?? '')))
            .toList(),
      );
    }
    uomList.addAll(
      homeController.uomList
          .map(
            (e) =>
                (((e.code ?? '') + '-${e.unit}') +
                "mzqxv9rklt8ph2wj" +
                (e.sId ?? '')),
          )
          .toList(),
    );
    controller.selectedUom.value = uomList[0];
    //----------------------------------------
    if(widget.isEdit){
      controller.itemNameController.text = widget.mate.name??'';
      controller.unitController.text = widget.mate.quantity.toString();
      controller.notesController.text = widget.mate.notes ?? '';
      controller.selectedMate.value = (((widget.mate.mateId!.sId ?? '') == homeController.id.value?AppStrings.you:(widget.mate.mateId!.name ?? '')) + "mzqxv9rklt8ph2wj" + (widget.mate.mateId!.sId ?? ''));
      controller.selectedUom.value = ((widget.mate.uomId!.code ?? '') + '-${widget.mate.uomId!.unit}' + "mzqxv9rklt8ph2wj" + (widget.mate.uomId!.sId ?? ''));
      controller.base64Image = widget.mate.imageUrl;
    }else{
      controller.itemNameController.text = '';
      controller.unitController.text = '';
      controller.notesController.text = '';
      controller.selectedMate.value = matesList[0];
      controller.selectedUom.value = uomList[0];
      controller.base64Image = null;

    }
    controller.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.popupBG,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              height: 520,
              child: Obx(
                () => Stack(
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
                          Text(
                            widget.isEdit?AppStrings.editItem: AppStrings.addItem,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Form(
                                key: controller.formKey,
                                child: Column(
                                  children: [
                                    TextFieldWidget(
                                      fillBgColor: true,
                                      bgColor: AppColors.white,
                                      isBorderNeeded: true,
                                      hasHindOnTop: true,
                                      maxLines: 1,
                                      inputFormatters: [
                                        AppInputFormatters.limitedText(maxLength: 255),
                                        AppInputFormatters.lettersNumbersSpaceSymbolsFormat,
                                      ],
                                      validator: AppValidators.name,
                                      hint: AppStrings.itemName,
                                      controller: controller.itemNameController,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 140,
                                          child: TextFieldWidget(
                                            fillBgColor: true,
                                            bgColor: AppColors.white,
                                            isBorderNeeded: true,
                                            hasHindOnTop: true,
                                            keyboardType:
                                                TextInputType.numberWithOptions(
                                                  decimal: true,
                                                ),
                                            inputFormatters: [
                                              MaxNumericValueFormatter(maxValue: 1000, decimalPlaces: 2),
                                            ],
                                            validator: AppValidators.unit,
                                            hint: AppStrings.units,
                                            controller:
                                                controller.unitController,
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: EdgeInsetsGeometry.only(
                                            top: 30,
                                            left: 3,
                                          ),
                                          child: DropdownWidget(
                                            onChanged: (value) {
                                              controller.selectedUom.value =
                                                  value;
                                            },
                                            list: uomList,
                                            selectedTable:
                                                controller.selectedUom.value,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  1.0,
                                                ),
                                                child: Text(
                                                  AppStrings.tagMate,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                              ),

                                              DropdownWidget(
                                                width: 140,
                                                onChanged: (value) {
                                                  controller
                                                          .selectedMate
                                                          .value =
                                                      value;
                                                },
                                                list: matesList,
                                                selectedTable: controller
                                                    .selectedMate
                                                    .value,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () async {
                                            if (controller
                                                    .itemNameController
                                                    .text
                                                    .trim() ==
                                                '') {
                                              SnackBarWidget.show(
                                                context,
                                                message:
                                                    AppStrings.itemNameRequired,
                                                contentType:
                                                    ContentType.warning,
                                              );
                                            } else {
                                              await controller.getImageApi(
                                                context,
                                                controller
                                                    .itemNameController
                                                    .text,
                                              );
                                              if (controller
                                                          .imageList
                                                          .value
                                                          .hits ==
                                                      null ||
                                                  controller
                                                      .imageList
                                                      .value
                                                      .hits!
                                                      .isEmpty) {
                                                SnackBarWidget.show(
                                                  context,
                                                  message:
                                                      AppStrings.imageNotFound,
                                                  contentType:
                                                      ContentType.warning,
                                                );
                                              } else {
                                                _showImageGridSheet(context);
                                              }
                                            }
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 74,
                                                width: 74,
                                                decoration: ShapeDecoration(
                                                  shape:
                                                      ContinuousRectangleBorder(
                                                        side: BorderSide(
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              40.0,
                                                            ),
                                                      ),
                                                ),
                                                child: ClipPath(
                                                  clipper: ShapeBorderClipper(
                                                    shape: ContinuousRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            40.0,
                                                          ), // Same as container
                                                    ),
                                                  ),
                                                  child: Base64ImageCommon(
                                                      base64String: controller.base64Image,
                                                      defaultImage: "assets/images/defaultMenuImage.png",
                                                      fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                child: Container(
                                                  height: 22,
                                                  width: 22,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: AppColors.white
                                                  ),
                                                  child: Icon(
                                                    Icons.change_circle,
                                                    size: 22,
                                                  ),
                                                ),
                                                top: 0,
                                                right: 0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    TextFieldWidget(
                                      fillBgColor: true,
                                      bgColor: AppColors.white,
                                      isBorderNeeded: true,
                                      hasHindOnTop: true,
                                      hint: AppStrings.addNote,
                                      maxLines: 1,
                                      inputFormatters: [
                                        AppInputFormatters.limitedText(maxLength: 255),
                                        AppInputFormatters.lettersNumbersSpaceSymbolsFormat,
                                      ],
                                      controller: controller.notesController,
                                    ),
                                    SizedBox(height: 20),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        BasicButtonWidget(
                                          width: 120,
                                          elevation: true,
                                          color: AppColors.listBg,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          labelColor: AppColors.black,
                                          label: AppStrings.cancel,
                                        ),
                                        SizedBox(height: 10),
                                        BasicButtonWidget(
                                          width: 120,
                                          elevation: true,
                                          color: AppColors.menuBg,
                                          onPressed: () async {
                                            if (controller.formKey.currentState!
                                                .validate()) {
                                              if(widget.isEdit){
                                                await controller.editItemApi(
                                                  context,
                                                  widget.mate.sId??'',
                                                );
                                              }else{
                                                await controller.addItemApi(
                                                  context,
                                                );
                                              }
                                              homeController.getItemsApi(
                                                context,
                                              );
                                            }
                                          },
                                          labelColor: AppColors.black,
                                          label: AppStrings.save,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.isLoading.value)
                      Positioned.fill(
                        child: Container(
                          color: AppColors.popupBG,
                          child: LoadingWidget.loader(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to show the modal bottom sheet with the image grid.
  void _showImageGridSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (BuildContext context) {
        return Obx(
          () => SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Select an Image',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Use a Container with a fixed size and a Wrap for the grid.
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0, // horizontal spacing between items
                    runSpacing: 8.0, // vertical spacing between lines
                    children: controller.imageList.value.hits!.asMap().entries.map((
                      entry,
                    ) {
                      final index = entry.key;

                      // The core fix: use a ternary operator to choose between the asset
                      // and the network image based on the index.
                      final imageWidget = index == 0
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                "assets/images/defaultMenuImage.png",
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                controller
                                        .imageList
                                        .value
                                        .hits![index]
                                        .previewURL ??
                                    '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(child: Icon(Icons.error));
                                },
                              ),
                            );

                      return GestureDetector(
                        onTap: () async {
                          if(index == 0){
                            controller.base64Image = null;
                          }
                          else{
                            await controller.processImage(
                              controller
                                  .imageList
                                  .value
                                  .hits![index]
                                  .previewURL ??
                                  '',
                            );
                          }
                          Navigator.of(
                            context,
                          ).pop();
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: MediaQuery.of(context).size.width / 3.5,
                          child: imageWidget,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
