import 'dart:developer';
import 'dart:io';
import 'package:guest_allow/utils/extensions/date.extension.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'dart:math' as math;
import 'package:path_provider/path_provider.dart';

class FileHelper {
  FileHelper._();

  static File renameFileWithDateTime({
    required File file,
    String prefix = 'File',
  }) {
    String tempFileName = file.path.split('/').last;
    String formatFile = tempFileName.split(".").last;
    String fileDir = path.dirname(file.path);
    String newPath = path.join(fileDir,
        '$prefix-${DateTime.now().extToFormattedString(outputDateFormat: 'ddMMyy-HH:mm')}.$formatFile');

    return File(file.path).renameSync(newPath);
  }

  static File renameFile({
    required File file,
    required String customName,
  }) {
    String tempFileName = file.path.split('/').last;
    String formatFile = tempFileName.split(".").last;
    String fileDir = path.dirname(file.path);
    String newPath = path.join(fileDir, '$customName.$formatFile');
    return File(file.path).renameSync(newPath);
  }

  static String getFileExtension(String fileName) {
    return fileName.split('.').last;
  }

  static Future<File> urlToFile(String imageUrl) async {
    try {
      var random = math.Random();

      Directory tempDir = await getTemporaryDirectory();
      String fileType = getFileExtension(imageUrl);
      String tempPath = tempDir.path;
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(10000)}.$fileType';
      File file = File(
        '$tempPath/$fileName',
      );
      // add timeout to get method to avoid delay
      var response = await Dio()
          .get(
            imageUrl,
            options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ),
          )
          .timeout(
            const Duration(seconds: 10),
          );

      await file.writeAsBytes(response.data);

      return file;
    } on Exception catch (_) {
      rethrow;
    }
  }

  static String parseArgs(List<String> args) {
    final commandList = args.map((arg) => arg.replaceAll(' ', '\\ ')).toList();

    return commandList.join(' ');
  }

  static findFileExtension(String fileName) {
    // get extension from file name
    // but if the file name is empty, return .jpg
    // if not null and it's not in the list, return .jpg
    if (fileName.isEmpty) {
      return 'jpg';
    }

    final ext = fileName.split('.').last;
    if (_listOfAcceptedImageExtension.contains(ext)) {
      return ext;
    } else {
      return 'jpg';
    }
  }

  static final _listOfAcceptedImageExtension = [
    'jpg',
    'jpeg',
    'png',
    'bmp',
    'webp',
    'heic',
    'heif',
  ];

  static Future<File> getImageFileFromUrl(String url) async {
    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      final dir = await getTemporaryDirectory();
      int randomNumber = math.Random().nextInt(100000);
      final targetPath =
          '${dir.absolute.path}/${randomNumber}temp.${findFileExtension(url)}';

      final file = File(targetPath);
      await file.writeAsBytes(response.data);

      return file;
    } on Exception catch (_) {
      log(_.toString());
      rethrow;
    }
  }
}
