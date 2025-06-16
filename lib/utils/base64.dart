import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

MemoryImage base64ToImage(String base64String) {
  // Remove o prefixo data:image/png;base64, ou similar, se existir
  final cleanedBase64 = base64String.contains(',')
      ? base64String.split(',').last
      : base64String;

  Uint8List bytes = base64Decode(cleanedBase64);
  return MemoryImage(bytes);
}
