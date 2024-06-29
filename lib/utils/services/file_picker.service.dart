import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:guest_allow/utils/helpers/file.helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FilePickerServices {
  static Future<File?> selectFile({
    List<String> allowedExtension = const [
      'pdf',
      'png',
      'jpg',
      'jpeg',
    ],
    String customFileName = '',
  }) async {
    var checkPermission = await Permission.storage.status;
    if (!checkPermission.isGranted) {
      await Permission.storage.request();
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtension,
    );
    if (result != null) {
      if (customFileName.isEmpty) {
        return File(result.files.single.path.toString());
      } else {
        var renamedImg = FileHelper.renameFile(
          file: File(result.files.single.path.toString()),
          customName: customFileName,
        );
        return renamedImg;
      }
    } else {
      return null;
    }
  }

  static Future<File?> selectImage({
    ImageSource source = ImageSource.gallery,
    String customImageName = '',
  }) async {
    // ask permission
    var checkPermission = await Permission.photos.status;
    if (!checkPermission.isGranted) {
      await Permission.photos.request();
    }

    final ImagePicker picker = ImagePicker();
    var xFile = await picker.pickImage(
        source: source, maxWidth: 1080, maxHeight: 1080, imageQuality: 100);
    if (xFile != null) {
      var pickedFile = File(xFile.path);
      if (customImageName.isNotEmpty) {
        pickedFile = FileHelper.renameFile(
            file: pickedFile, customName: customImageName);
      } else {
        String tempFileName = pickedFile.path.split('/').last;
        String formatFile = tempFileName.split(".").last;
        pickedFile = FileHelper.renameFile(
          file: pickedFile,
          customName: xFile.name
              .replaceAll('scaled_', '')
              .replaceAll('.$formatFile', ''),
        );
      }
      return pickedFile;
    } else {
      return null;
    }
  }
}
