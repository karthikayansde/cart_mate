
import 'package:cart_mate/services/shared_pref_manager.dart';
import 'package:cart_mate/utils/app_colors.dart';
import 'package:cart_mate/views/login_view.dart';
import 'package:flutter/material.dart';

class OnboardingContents {
  final String image;

  OnboardingContents({
    required this.image,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    image: "assets/images/image1.png",
  ),
  OnboardingContents(
    image: "assets/images/image2.png",
  ),
  OnboardingContents(
    image: "assets/images/image3.png",
  ),
  OnboardingContents(
    image: "assets/images/image1.png", // reused
  ),
  OnboardingContents(
    image: "assets/images/image1.png", // reused
  ),
];


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;
  List colors = const [
    Color(0xffDAD3C8), // Beige
    Color(0xffFFE5DE), // Peach
    Color(0xffDCF6E6), // Mint
    Color(0xffE6E6FA), // Lavender
    Color(0xffD6EAF8), // Sky Blue
  ];

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: AppColors.primaryRed,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Expanded( // Wrap the Image.asset with Expanded
                          child: Image.asset(
                            contents[i].image,
                            // Remove fixed height here, let it be flexible
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    contents.length,
                        (int index) => _buildDots(
                      index: index,
                    ),
                  ),
                ),
                _currentPage + 1 == contents.length
                    ? Padding(
                  padding: const EdgeInsets.all(30),
                  child: ElevatedButton(
                    onPressed: () async {
                      await SharedPrefManager.instance.setBoolAsync(SharedPrefManager.isOnboardingComplete, true);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView()));
                    },
                    child: const Text("START", style: TextStyle(color: AppColors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 20),
                      textStyle:
                      TextStyle(fontSize: 13),
                    ),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          _controller.jumpToPage(4);
                        },
                        child: const Text(
                          "SKIP",
                          style: TextStyle(color: AppColors.primaryRed),
                        ),
                        style: TextButton.styleFrom(
                          elevation: 0,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Text("NEXT", style: TextStyle(color: AppColors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          textStyle: TextStyle(
                            fontSize: 13 ,
                          ),
                        ),)
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
