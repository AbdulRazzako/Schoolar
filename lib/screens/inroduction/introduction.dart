import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:schoolar/screens/authenticate/sign_in.dart';
// import 'package:schoolar/screens/homepage.dart';

class OnBoardingscreen extends StatefulWidget {
  @override
  _OnBoardingscreenState createState() => _OnBoardingscreenState();
}

class _OnBoardingscreenState extends State<OnBoardingscreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    List<PageViewModel> pages = [
      PageViewModel(
        title: "Title of first page",
        body:
            "Here you can write the description of the page, to explain someting...",
        image: Center(
          child: Image.network("https://domaine.com/image.png", height: 175.0),
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Title of first page",
        body:
            "Here you can write the description of the page, to explain someting...",
        image: Center(
          child: Image.network("https://domaine.com/image.png", height: 175.0),
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Title of first page",
        body:
            "Here you can write the description of the page, to explain someting...",
        image: Center(
          child: Image.network("https://domaine.com/image.png", height: 175.0),
        ),
        decoration: pageDecoration,
      ),
      PageViewModel(
        title: "Title of last page",
        bodyWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Click on ", style: bodyStyle),
          ],
        ),
        decoration: pageDecoration,
      ),
    ];

    return IntroductionScreen(
      key: introKey,
      pages: pages,
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      showNextButton: true,
      showSkipButton: true,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      onDone: () => _onIntroEnd(context),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
