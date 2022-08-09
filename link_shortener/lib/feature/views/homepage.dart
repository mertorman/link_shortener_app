import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:link_shortener/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:link_shortener/feature/onboard/on_board_view.dart';
import 'package:link_shortener/model/model.dart';
import 'package:link_shortener/service/postservice.dart';
import 'package:validators/validators.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  List<Model>? liste;

  PostService service = PostService();

  TextEditingController _controller = TextEditingController();
  bool? validUrl;
  double _opacity = 0;
  final colorizeColors = [
    Colors.white,
    Colors.white,
    Colors.transparent,
  ];

  final colorizeTextStyle = TextStyle(
      fontSize: 30.0, fontFamily: 'Avenir', fontWeight: FontWeight.w900);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacity = 1;
      });
    });
    super.initState();
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  

  Future<void> _launchUrl() async {
    var uri = Uri.parse(service.link!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Hata';
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('');

    bool firstTimeState = box.get('introduction') ?? true;
     
    return firstTimeState ? const OnBoardView() : Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: gradientEndColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [gradientStartColor, gradientEndColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 0.7])),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Center(
              child: Column(
                children: [
                  AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(seconds: 2),
                    child: SvgPicture.asset(
                      alignment: Alignment.topCenter,
                      'images/homepage.svg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText(
                            'MeoLink Shorter',
                            textAlign: TextAlign.center,
                            textStyle: colorizeTextStyle,
                            colors: colorizeColors,
                          ),
                        ],
                        totalRepeatCount: 1,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        children: [
                          Center(
                            child: Text('-Please enter a link-',
                                style: TextStyle(
                                    fontFamily: 'Avenir',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green)),
                          ),
                          Text('Example: http://meosoftware.com',style: TextStyle(fontFamily: 'Avenir',fontSize: 13,fontWeight: FontWeight.bold),),
                          SizedBox(
                            height: 9,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (!isURL(value)) {
                                  return 'Please enter a valid URL';
                                }
                                return null;
                              },
                              controller: _controller,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  hintText: 'Enter a link',
                                  prefixIcon: Icon(Icons.add_link)),
                            )),
                          ),
                        ],
                      ),
                    ),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_controller.text.isNotEmpty) {
                                changeLoading();
                                final model =
                                    Model(resultUrl: _controller.text);

                                await service.postItemService(model);
                                changeLoading();
                                if (service.link!.isNotEmpty) {
                                  // ignore: avoid_single_cascade_in_expression_statements
                                  AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.SUCCES,
                                      title: 'Succes!',
                                      btnCancelText: 'Copy Link!',
                                      btnOkText: 'Go to Link!',
                                      btnCancelOnPress: (){
                                        Clipboard.setData(ClipboardData(text: service.link)).then((_){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Link copied to clipboard!")));
});
                                      },
                                      desc:
                                          'The short link has been successfully created.\n' +
                                              service.link.toString(),
                                      btnOkOnPress: () {
                                        _launchUrl();
                                      })
                                    ..show();
                                }
                              }
                            },
                            child: isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 24,
                                      ),
                                      Text('Please Wait...')
                                    ],
                                  )
                                : Text('Start!',style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                                
                                primary: Colors.red,
                                shape: StadiumBorder(),
                                minimumSize: Size.fromHeight(50),
                                textStyle: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
