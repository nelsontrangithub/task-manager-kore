import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import './s3bucketPolicy.dart';

class S3bucketUploader {
  void uploadFile(String pathToFile, String fileName, String bucketName) {
    const _accessKeyId = 'AKIAI7VGATG6RF6KV6CA';
    const _secretKeyId = 'Ky8ImCeRiz5iBoFi0Zrgo5oB2JWPWuuRTc+q7spH';
    const _region = 'us-east-2';
    const _s3Endpoint =
        'https://koretaskmanagermediabucket.s3.amazonaws.com';

    final file = File(path.join(pathToFile, fileName));
    final stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    final length = await file.length();

    final uri = Uri.parse(_s3Endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(file.path));

    final policy = S3bucketPolicy.fromS3PresignedPost('uploaded/' + fileName,
        bucketName, _accessKeyId, 15, length,
        region: _region);
    final key =
        SigV4.calculateSigningKey(_secretKeyId, policy.datetime, _region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode());

    req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    req.fields['acl'] = 'public-read';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    try {
      final res = await req.send();
      await for (var value in res.stream.transform(utf8.decoder)) {
        print(value);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}