package com.ayarohovich.flutter_begateway;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.util.Base64;

import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

/** FlutterBegatewayPlugin */
public class FlutterBegatewayPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_begateway");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("encryptData")) {
      String data = call.argument("data");
      String publicKey = call.argument("publicKey");
      if (data == null || data.isEmpty() || publicKey == null || publicKey.isEmpty()){
        result.error("-1", "Invalid input data", null);
      } else {
        result.success(encrypt(data, publicKey));
      }
    } else {
      result.notImplemented();
    }
  }

  private String encrypt(String text, String publicKey){
    // Copy-paste from https://github.com/begateway/begateway-android-sdk/blob/master/mobilepayments/src/main/java/com/begateway/mobilepayments/utils/RSA.java
    String encoded = "";
    byte[] encrypted;
    try {
      byte[] publicBytes = Base64.decode(publicKey, Base64.DEFAULT);
      X509EncodedKeySpec keySpec = new X509EncodedKeySpec(publicBytes);
      KeyFactory keyFactory = KeyFactory.getInstance("RSA");
      PublicKey pubKey = keyFactory.generatePublic(keySpec);
      Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1PADDING");
      cipher.init(Cipher.ENCRYPT_MODE, pubKey);
      encrypted = cipher.doFinal(text.getBytes());
      encoded = Base64.encodeToString(encrypted, Base64.DEFAULT);
    } catch (NoSuchAlgorithmException e) {
      e.printStackTrace();
    } catch (InvalidKeySpecException e) {
      e.printStackTrace();
    } catch (NoSuchPaddingException e) {
      e.printStackTrace();
    } catch (InvalidKeyException e) {
      e.printStackTrace();
    } catch (BadPaddingException e) {
      e.printStackTrace();
    } catch (IllegalBlockSizeException e) {
      e.printStackTrace();
    }
    return encoded.replaceAll("\n", "");
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
