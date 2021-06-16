/*
 * Author : Johnny Cheung
 * Page: 网路检测
 *
 * 开源库地址：https://pub.dev/packages/connectivity_plus
 */

import 'package:connectivity_plus/connectivity_plus.dart';

enum SSNetworkType { none, WiFi, mobile }

class SSNetworkDetector {
  /* 1.获取网络类型
     调用示例：
     SSHttpRequestManager().getNetworkType().then((value) {
       print(value);
     });
   */
  Future<SSNetworkType> getNetworkType() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return SSNetworkType.mobile;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return SSNetworkType.WiFi;
    }
    return SSNetworkType.none;
  }

  /* 2.监听网络变化
   * 调用示例：
      subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {

      })
      subscription.cancel();
   * 
   */
}
