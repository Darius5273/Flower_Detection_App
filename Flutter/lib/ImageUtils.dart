import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';


class ImageUtils {
  final ImagePicker _picker = ImagePicker();

  Future<File?> takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      Future<File?> savedImage=saveImageWithTimestamp(File(image.path));
      return savedImage;
    }
    return null;
  }

  Future<File?> selectFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
     return await cropImage(image.path);

    }
  }

  Future<File?> cropImage(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          minimumAspectRatio: 1.0,
        ),
      ],
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio4x3,
      ],
    );

    if (croppedFile != null) {
      Future<File?> savedImage=saveImageWithTimestamp(File(croppedFile.path));
      return savedImage;
    }
    return null;
  }
  Future<File?> saveImageWithTimestamp(File croppedFile) async {

    Directory appDocDir = await getApplicationDocumentsDirectory();

    String photoDir = '${appDocDir.path}/photos';

    final Directory photoDirectory = Directory(photoDir);
    if (!await photoDirectory.exists()) {
      await photoDirectory.create(recursive: true);
    }

      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      String filePath = '$photoDir/IMG_$timestamp.jpg';

      File savedImage = await croppedFile.copy(filePath);
      return savedImage;
  }

}