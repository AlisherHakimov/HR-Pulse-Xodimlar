import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(ImageSource imageSource) async {
  try {
    final xFile = await ImagePicker().pickImage(source: imageSource);
    if (xFile != null) {
      return File(xFile.path);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
