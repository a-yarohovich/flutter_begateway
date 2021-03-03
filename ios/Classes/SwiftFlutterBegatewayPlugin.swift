import Flutter
import UIKit
import SwiftyRSA

public class SwiftFlutterBegatewayPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_begateway", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterBegatewayPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch (call.method) {
      case"encryptData":
          guard let args = call.arguments else {
              return
          }
          if let myArgs = args as? [String: Any],
          let data = myArgs["data"] as? String,
          let publicKey = myArgs["publicKey"] as? String {
              let res = encrypt(message: data, with: publicKey)
              if let error = res.error {
                  result(FlutterError(code: "-1", message: "\(error)", details: nil))
              } else if let message = res.message {
                  result(message)
              }
          } else {
              result(FlutterError(code: "-2", message: "iOS could not extract " + 
                  "flutter arguments in method: (sendParams)", details: nil))
          }
          break;
      default:
          result("Not Implemented!")
          break;
      }
  } 

  public func encrypt(message: String, with pemEncodedPublicKey: String) -> (message: String?, error: Error?) {
        do {
            let publicKey = try PublicKey(pemEncoded: pemEncodedPublicKey)
            let clear = try ClearMessage(string: message, using: .utf8)
            let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
            let base64String = encrypted.base64String
            return (base64String, nil)
        } catch let error {
            return (nil, error)
        }
    }
}
