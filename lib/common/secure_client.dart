import 'dart:io';
import 'package:flutter/services.dart';

Future<SecurityContext> get globalContext async {
  final sslCert = await rootBundle.load('certificates/certificate.pem');
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
  return securityContext;
}
