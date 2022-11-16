import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:umeng_verify_sdk/umeng_verify_sdk.dart';
import 'dart:io' show Platform;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _VerifyVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    UmengCommonSdk.setPageCollectionModeManual();
    UmengCommonSdk.initCommon('android appkey', 'ios appkey', 'Umeng');
    initPlatformState();
    UmengVerifySdk.setVerifySDKInfo('android 秘钥', 'ios 秘钥').then((map) {
      print("sdkInfo:${map}");
    });

    UmengVerifySdk.getLoginTokenCallback((result) {
      print("resultDic:${result}");
      print("token:${result["token"]}");
      if (result['token'] != null) {
        bool isTrue = true;

        UmengVerifySdk.cancelLoginVCAnimated(isTrue);
      }
    });

    UmengVerifySdk.getWidgetEventCallback((result) {
      print("resultDic:${result}");
    });

    UmengVerifySdk.setTokenResultCallback_android((result) {
      print("setTokenResultCallback_android: $result");
      if (result["code"] == "600000") {
        UmengVerifySdk.quitLoginPage_android();
      }
    });

    UmengVerifySdk.setUIClickCallback_android((result) {
      print("setUIClickCallback_android: $result");
    });

    //TODO: ios only
    // UmengVerifySdk.checkEnvAvailableWithAuthType_ios('UMPNSAuthTypeLoginToken')
    //     .then((map) {
    //   print("check:${map}");
    // });

    //TODO: android only
    UmengVerifySdk.checkEnvAvailable_android(UMEnvCheckType.type_login);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    UmengVerifySdk.register_android();

    String? VerifyId = await UmengVerifySdk.getVerifyId();
    print('VerifyId：' + VerifyId!);
    String? carrierName = await UmengVerifySdk.getCurrentCarrierName();
    print('carrierName：' + carrierName!);

    String platformVersion;
    String VerifyVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = (await UmengCommonSdk.platformVersion)!;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    VerifyVersion = (await UmengVerifySdk.VerifyVersion)!;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _VerifyVersion = VerifyVersion;
    });
  }

  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('os: $_platformVersion SDK: $_VerifyVersion'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            new TextField(
              controller: _controller,
              decoration: new InputDecoration(
                hintText: '手机号码',
              ),
            ),
            OutlinedButton(
                child: Text("号码验证"),
                onPressed: () {
                  print("手机 ${_controller.text}");
                  // UmengVerifySdk.accelerateVerifyWithTimeout(3).then((map) {
                  //   print("加速结果 ${map}");
                  //   if (map['resultCode'] == '600000') {
                  //     UmengVerifySdk.getVerifyTokenWithTimeout(3).then((map) {
                  //       print("号码验证 ${map}");
                  //     });
                  //   }
                  // });

                  UmengVerifySdk.accelerateVerifyWithTimeout(3).then((result) {
                    print("Android 号码验证加速结果 $result");
                    UmengVerifySdk.getVerifyTokenWithTimeout_android(3);
                  });
                }),
            OutlinedButton(
                child: Text("一键登录（快）"),
                onPressed: () {
                  UMCustomModel uiConfig = UMCustomModel();
                  if (Platform.isIOS) {
                    uiConfig.backgroundColor_ios = Colors.orange.value;
                    UMCustomWidget customButton =
                        UMCustomWidget("button1", UMCustomWidgetType.button);
                    //  customButton.widgetId="button1";
                    // customButton.type=UMCustomWidgetType.button;
                    customButton.title = "Btn";
                    customButton.titleFont = 20;
                    customButton.textAlignment =
                        UMCustomWidgetTextAlignmentType.right;
                    customButton.left = 100;
                    customButton.top = 480;
                    customButton.width = 200;
                    customButton.height = 50;
                    customButton.backgroundColor = Colors.red.value;
                    customButton.titleColor = Colors.black.value;
                    customButton.isClickEnable = false;
                    customButton.rootViewId = UMRootViewId.body;
                    UMCustomWidget customButton1 =
                        UMCustomWidget("button2", UMCustomWidgetType.button);
                    //   customButton1.widgetId="button2";
                    //  customButton1.type=UMCustomWidgetType.button;
                    customButton1.left = 100;
                    customButton1.top = 550;
                    customButton1.width = 200;
                    customButton1.height = 50;
                    customButton1.titleColor = Colors.red.value;
                    customButton1.title = "自定义控件2";
                    customButton1.backgroundColor = Colors.blue.value;
                    customButton1.rootViewId = UMRootViewId.title_bar;

                    UMCustomWidget customTextView =
                        UMCustomWidget("textView", UMCustomWidgetType.textView);
                    //  customButton2.widgetId="textView";
                    //  customButton2.type=UMCustomWidgetType.textView;
                    customTextView.left = 100;
                    customTextView.top = 620;
                    customTextView.width = 200;
                    customTextView.height = 200;
                    customTextView.title = "自\n定\n义\n控\n件\nTV";
                    customTextView.titleFont = 50;
                    customTextView.textAlignment =
                        UMCustomWidgetTextAlignmentType.center;
                    customTextView.titleColor = Colors.black.value;
                    customTextView.backgroundColor = Colors.red.value;
                    customTextView.isClickEnable = false;
                    customTextView.isShowUnderline = true;
                    customTextView.isSingleLine = false;
                    customTextView.lines = 3;
                    customTextView.rootViewId = UMRootViewId.number;

                    uiConfig.customWidget = [
                      customButton.toJsonMap(),
                      customButton1.toJsonMap(),
                      customTextView.toJsonMap()
                    ];
                  } else {
                    uiConfig.contentViewFrame = [-1, -1, 320, 640];
                    uiConfig.alertTitleBarFrame_ios = [80, 100, 260, 500];
//uiConfig.animationDuration_ios=0;
                    uiConfig.alertBlurViewColor_ios = Colors.red.value;
                    uiConfig.alertBlurViewAlpha_ios = 0.8;
                    uiConfig.alertTitle_ios = ["aaaabbb", Colors.red.value, 20];
                    uiConfig.navColor = Colors.orange.value;
                    uiConfig.loginBtnText = ["一键登录1", Colors.orange.value, 20];
                    uiConfig.privacyOne = ["协议1", "https://www.umeng.com"];
                    UMCustomWidget customButton =
                        UMCustomWidget("button1", UMCustomWidgetType.button);
                    //  customButton.widgetId="button1";
                    // customButton.type=UMCustomWidgetType.button;
                    customButton.title = "Btn";
                    customButton.titleFont = 20;
                    customButton.textAlignment =
                        UMCustomWidgetTextAlignmentType.right;
                    customButton.left = 20;
                    customButton.top = 20;
                    customButton.width = 200;
                    customButton.height = 50;
                    customButton.backgroundColor = Colors.red.value;
                    customButton.titleColor = Colors.black.value;
                    customButton.isClickEnable = false;
                    customButton.btnBackgroundResource_android = "btn_selector";
                    customButton.rootViewId = UMRootViewId.body;
                    UMCustomWidget customButton1 =
                        UMCustomWidget("button2", UMCustomWidgetType.button);
                    //   customButton1.widgetId="button2";
                    //  customButton1.type=UMCustomWidgetType.button;
                    customButton1.left = 100;
                    customButton1.top = 530;
                    customButton1.width = 200;
                    customButton1.height = 50;
                    customButton1.titleColor = Colors.red.value;
                    customButton1.title = "自定义控件2";
                    customButton1.backgroundColor = Colors.blue.value;
                    customButton1.rootViewId = UMRootViewId.title_bar;

                    UMCustomWidget customTextView =
                        UMCustomWidget("textView", UMCustomWidgetType.textView);
                    //  customButton2.widgetId="textView";
                    //  customButton2.type=UMCustomWidgetType.textView;
                    customTextView.left = 20;
                    customTextView.top = 20;
                    customTextView.width = 200;
                    customTextView.height = 200;
                    customTextView.title = "自\n定\n义\n控\n件\nTV";
                    customTextView.titleFont = 50;
                    customTextView.textAlignment =
                        UMCustomWidgetTextAlignmentType.center;
                    customTextView.titleColor = Colors.black.value;
                    customTextView.backgroundColor = Colors.red.value;
                    customTextView.isClickEnable = false;
                    customTextView.isShowUnderline = true;
                    customTextView.isSingleLine = false;
                    customTextView.lines = 3;
                    customTextView.rootViewId = UMRootViewId.number;

                    uiConfig.customWidget = [
                      customButton.toJsonMap(),
                      customButton1.toJsonMap(),
                      customTextView.toJsonMap()
                    ];

                    // UmengVerifySdk.accelerateLoginPageWithTimeout(3).then((map) {
                    //   print("加速结果 ${map}");
                    //   if (map['resultCode'] == '600000') {
                    //     UmengVerifySdk.getLoginTokenWithTimeout(3, uiConfig);
                    //   }
                    // });

                  }

                  UmengVerifySdk.accelerateLoginPageWithTimeout(3)
                      .then((result) {
                    print("Android 登录加速结果 $result");
                    UmengVerifySdk.getLoginTokenWithTimeout(3, uiConfig);
                  });
                }),
            OutlinedButton(
                child: Text("一键登录（慢）"),
                onPressed: () {
                  UMCustomModel uiConfig = UMCustomModel();
                  uiConfig.navColor = Colors.red.value;
                  uiConfig.logoImage = "checked";

                  if (Platform.isIOS) {
                    uiConfig.privacyOne = [
                      "privacyOne",
                      "https://www.taobao.com"
                    ];
                    uiConfig.privacyTwo = [
                      "privacyTwo",
                      "https://www.baidu.com"
                    ];
                    uiConfig.privacyThree = [
                      "privacyThree",
                      "https://www.alibaba.com"
                    ];
                    uiConfig.privacyConectTexts = ["& ", "、", "and "];
                    uiConfig.privacyColors = [
                      Colors.red.value,
                      Colors.blue.value
                    ];
                    uiConfig.checkBoxImages = ["unchecked", "checked"];
                    uiConfig.loginBtnText = [
                      "loginBtnText-登录",
                      Colors.black.value,
                      20
                    ];
                  } else {
                    uiConfig.isAutorotate = false;
                    uiConfig.navIsHidden = false;
                    uiConfig.navColor = Colors.red.value;
                    uiConfig.navTitle = ["Title", Colors.black.value, 20];
                    uiConfig.navBackImage = "icon_close";
                    uiConfig.hideNavBackItem = false;
                    uiConfig.navBackButtonFrame = [-1, -1, 20, 20];
                    uiConfig.prefersStatusBarHidden = false;
                    uiConfig.backgroundImage = "page_background_color";
                    uiConfig.logoImage = "alipay";
                    uiConfig.logoIsHidden = false;
                    uiConfig.logoFrame = [20, -1, 100, 100];
                    uiConfig.sloganText = ["sloganText", Colors.red.value, 20];
                    uiConfig.sloganIsHidden = false;
                    uiConfig.sloganFrame = [150, -1, -1, -1];
                    uiConfig.numberColor = Colors.black.value;
                    uiConfig.numberFont = 20;
                    uiConfig.numberFrame = [10, 200, -1, -1];
                    uiConfig.loginBtnText = [
                      "loginBtnText-登录",
                      Colors.black.value,
                      20
                    ];
                    uiConfig.loginBtnBgImg_android = "login_btn_bg";
                    uiConfig.autoHideLoginLoading = false;
                    uiConfig.loginBtnFrame = [10, -1, -1, -1, -1];
                    uiConfig.checkBoxImages = ["unchecked", "checked"];
                    uiConfig.checkBoxIsChecked = true;
                    uiConfig.checkBoxIsHidden = false;
                    uiConfig.checkBoxWH = 15;
                    uiConfig.privacyOne = [
                      "privacyOne",
                      "https://www.taobao.com"
                    ];
                    uiConfig.privacyTwo = [
                      "privacyTwo",
                      "https://www.baidu.com"
                    ];
                    uiConfig.privacyThree = [
                      "privacyThree",
                      "https://www.alibaba.com"
                    ];
                    uiConfig.privacyConectTexts = ["& ", "、", "and "];
                    uiConfig.privacyColors = [
                      Colors.red.value,
                      Colors.blue.value
                    ];
                    uiConfig.privacyAlignment = UMTextAlignment.Center;
                    uiConfig.privacyPreText = "Pre-";
                    uiConfig.privacySufText = "-Suf";
                    uiConfig.privacyOperatorPreText = "<";
                    uiConfig.privacyOperatorSufText = ">";
                    uiConfig.privacyOperatorIndex = 1;
                    uiConfig.privacyFont = 12;
                    uiConfig.privacyFrame = [10, -1, 10, -1];
                    uiConfig.changeBtnTitle = ["切换登录方式", Colors.blue.value, 20];
                    uiConfig.changeBtnIsHidden = false;
                    uiConfig.changeBtnFrame = [-1, 300, -1, -1];
                    uiConfig.protocolAction_android =
                        "com.aliqin.mytel.protocolWeb";
                    uiConfig.privacyNavColor = Colors.red.value;
                    uiConfig.privacyNavTitleFont = 16;
                    uiConfig.privacyNavTitleColor = Colors.blue.value;
                    uiConfig.privacyNavBackImage = "icon_back";
                  }

                  UmengVerifySdk.getLoginTokenWithTimeout(3, uiConfig);
                }),
          ]),
        ),
      ),
    );
  }
}
