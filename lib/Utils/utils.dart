
import 'package:encrypt/encrypt.dart';

class EncryptUtil{
   static int keyLen = 16; //128 bits


  /* static encrypt(data,keyVal,ivStr)
  {
    final key = Key.fromUtf8(keyVal);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key,iv));
    return encrypter.encrypt(data).base64;
  }

  static decrypt(data,keyVal,ivStr)
  {
    final key = Key.fromUtf8(keyVal);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key,iv));
    //encrypter.decrypt64(encoded)
    return encrypter.decrypt64(data);
  }*/
  static encrypt1( data,keyVal,ivStr)
  {
    final key = Key.fromUtf8(fixKey(keyVal));
    final iv = IV.fromUtf8(fixKey(ivStr));
    final encrypter = Encrypter(AES(key,mode: AESMode.cbc,padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(data, iv: iv);
    print('encrypted:'+encrypted.base64.toString());
    return encrypted.base64 +":"+iv.base64;
  }
  static decrypt1( data,keyVal,ivStr)
  {
    final key = Key.fromUtf8(fixKey(keyVal));
    final iv = IV.fromUtf8(fixKey(ivStr));
    final encrypter = Encrypter(AES(key,mode: AESMode.cbc,padding: 'PKCS7'));
    final decrypted = encrypter.decrypt64(data, iv: iv);
    print('decrypted:'+decrypted);
    return decrypted.toString();
  }
   static String fixKey(String key) {

    if (key.length < keyLen) {
      int numPad = keyLen - key.length;

      for (int i = 0; i < numPad; i++) {
        key += "0"; //0 pad to len 16 bytes
      }

      return key;

    }

    if (key.length > keyLen) {
      return key.substring(0, keyLen); //truncate to 16 bytes
    }

    return key;
  }

}