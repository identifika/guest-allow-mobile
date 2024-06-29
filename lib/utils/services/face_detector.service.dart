import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as image_lib;
import 'package:path_provider/path_provider.dart';

class FaceDetectorService {
  FaceDetectorOptions options = FaceDetectorOptions(
    enableClassification: true,
    enableLandmarks: true,
    enableContours: true,
    enableTracking: true,
  );

  late FaceDetector faceDetector;

  FaceDetectorService({FaceDetectorOptions? options}) {
    options = FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableContours: true,
      enableTracking: true,
    );
    faceDetector = FaceDetector(options: options);
  }

  ///* Function To Crop Faces From Image File
  ///* Return List Of File And List Of Face
  ///* If No Face Detected Return Empty List
  Future<
      (
        List<File> resultCroppedFile,
        List<Face> resultFace,
      )> cropFacesFromImageFile({
    required File file,
    bool useBakeOrientation = true,
  }) async {
    var resFace = await detectFacesFromImageFile(
      source: file,
    );
    if (resFace.isEmpty) return (<File>[], <Face>[]);

    List<File> result = [];
    try {
      final Directory temp = await getTemporaryDirectory();
      image_lib.Image convertedImage =
          image_lib.decodeImage(file.readAsBytesSync())!;
      if (useBakeOrientation) {
        convertedImage = image_lib.bakeOrientation(convertedImage);
      }

      for (int i = 0; i < resFace.length; i++) {
        var element = resFace[i];

        image_lib.Image rotatedFaceImage = _alignFace(element, convertedImage);
        File file2 = File(
            '${temp.path}/${DateTime.now().toIso8601String()}_${i + 1}.png');
        file2.writeAsBytesSync(image_lib.encodePng(rotatedFaceImage));

        // detect face again from rotated image
        var resFace2 = await detectFacesFromImageFile(
          source: file2,
        );

        if (resFace2.isEmpty) return (<File>[], <Face>[]);

        image_lib.Image convertedImage2 =
            image_lib.decodeImage(file2.readAsBytesSync())!;
        if (useBakeOrientation) {
          convertedImage2 = image_lib.bakeOrientation(convertedImage2);
        }

        image_lib.Image convertedImage3 =
            _cropFaceArea(element, convertedImage2);
        if (useBakeOrientation) {
          convertedImage3 = image_lib.bakeOrientation(convertedImage3);
        }
        File file3 = File(
            '${temp.path}/${DateTime.now().toIso8601String()}_${i + 2}.png');
        file3.writeAsBytesSync(image_lib.encodePng(convertedImage3));

        // detect face again from cropped image
        var resFace3 = await detectFacesFromImageFile(
          source: file3,
        );

        if (resFace3.isEmpty) return (<File>[], <Face>[]);
        var convertedImage4 = image_lib.decodeImage(file3.readAsBytesSync())!;

        var element3 = resFace3[0];

        var leftEyeBrowTop = element3.contours[FaceContourType.leftEyebrowTop]!;
        var rightEyeBrowTop =
            element3.contours[FaceContourType.rightEyebrowTop]!;

        var ovalFace = element3.contours[FaceContourType.face]!;
        // added first point as last point to make a closed loop
        ovalFace.points.add(ovalFace.points[0]);

        // //  from point to point in ovalFace, create a line and make it black
        for (int i = 0; i < ovalFace.points.length; i++) {
          var point = ovalFace.points[i];
          if (i == ovalFace.points.length - 1) {
            break;
          }
          var nextPoint = ovalFace.points[i + 1];
          var line = image_lib.drawLine(
            convertedImage3,
            x1: point.x.round(),
            y1: point.y.round(),
            x2: nextPoint.x.round(),
            y2: nextPoint.y.round(),
            color: image_lib.ColorFloat32.rgb(0, 0, 0),
          );
          convertedImage3 = line;
        }

        // draw a line from leftEyeBrowTop to rightEyeBrowTop
        for (int i = 0; i < leftEyeBrowTop.points.length; i++) {
          var point = leftEyeBrowTop.points[i];
          if (i == leftEyeBrowTop.points.length - 1) {
            break;
          }
          var nextPoint = leftEyeBrowTop.points[i + 1];
          var line = image_lib.drawLine(
            convertedImage3,
            x1: point.x.round(),
            y1: point.y.round(),
            x2: nextPoint.x.round(),
            y2: nextPoint.y.round(),
            color: image_lib.ColorFloat32.rgb(0, 0, 0),
          );
          convertedImage3 = line;
        }

        for (int i = 0; i < rightEyeBrowTop.points.length; i++) {
          var point = rightEyeBrowTop.points[i];
          if (i == rightEyeBrowTop.points.length - 1) {
            break;
          }
          var nextPoint = rightEyeBrowTop.points[i + 1];
          var line = image_lib.drawLine(
            convertedImage3,
            x1: point.x.round(),
            y1: point.y.round(),
            x2: nextPoint.x.round(),
            y2: nextPoint.y.round(),
            color: image_lib.ColorFloat32.rgb(0, 0, 0),
          );
          convertedImage3 = line;
        }

        // connect the oval face with leftEyeBrowTop
        // get the lowest point of leftEyeBrowTop
        var lowestPointOfLeftEyeBrowTop = leftEyeBrowTop.points[0];
        var highestPointOfLeftEyeBrowTop = leftEyeBrowTop.points[0];
        for (int i = 0; i < leftEyeBrowTop.points.length; i++) {
          var point = leftEyeBrowTop.points[i];
          if (point.y > lowestPointOfLeftEyeBrowTop.y) {
            lowestPointOfLeftEyeBrowTop = point;
          }
          if (point.y < highestPointOfLeftEyeBrowTop.y) {
            highestPointOfLeftEyeBrowTop = point;
          }
        }
        // get the highest point of oval face that below the lowest point of leftEyeBrowTop
        var highestPointOfOvalFaceBelowLowestPointOfLeftEyeBrowTop =
            ovalFace.points[(ovalFace.points.length / 2).round()];
        for (int i = ovalFace.points.length - 1;
            i > (ovalFace.points.length / 2).round();
            i--) {
          var point = ovalFace.points[i];
          if (point.y > lowestPointOfLeftEyeBrowTop.y &&
              point.y <
                  highestPointOfOvalFaceBelowLowestPointOfLeftEyeBrowTop.y) {
            highestPointOfOvalFaceBelowLowestPointOfLeftEyeBrowTop = point;
          }
        }

        // connect the oval face with rightEyeBrowTop
        // get the lowest point of rightEyeBrowTop
        var lowestPointOfRightEyeBrowTop = rightEyeBrowTop.points[0];
        var highestPointOfRightEyeBrowTop = rightEyeBrowTop.points[0];
        for (int i = 0; i < rightEyeBrowTop.points.length; i++) {
          var point = rightEyeBrowTop.points[i];
          if (point.y > lowestPointOfRightEyeBrowTop.y) {
            lowestPointOfRightEyeBrowTop = point;
          }
          if (point.y < highestPointOfRightEyeBrowTop.y) {
            highestPointOfRightEyeBrowTop = point;
          }
        }

        // get the highest point of oval face that below the lowest point of rightEyeBrowTop
        var highestPointOfOvalFaceBelowLowestPointOfRightEyeBrowTop =
            ovalFace.points[(ovalFace.points.length / 2).round()];
        for (int i = (ovalFace.points.length / 2).round(); i > 0; i--) {
          var point = ovalFace.points[i];
          if (point.y > lowestPointOfRightEyeBrowTop.y &&
              point.y <
                  highestPointOfOvalFaceBelowLowestPointOfRightEyeBrowTop.y) {
            highestPointOfOvalFaceBelowLowestPointOfRightEyeBrowTop = point;
          }
        }

        // connect the oval face with leftEyeBrowTop
        image_lib.drawLine(
          convertedImage3,
          x1: lowestPointOfLeftEyeBrowTop.x.round(),
          y1: lowestPointOfLeftEyeBrowTop.y.round(),
          x2: highestPointOfOvalFaceBelowLowestPointOfLeftEyeBrowTop.x.round(),
          y2: highestPointOfOvalFaceBelowLowestPointOfLeftEyeBrowTop.y.round(),
          color: image_lib.ColorFloat32.rgb(0, 0, 0),
        );

        // connect the oval face with rightEyeBrowTop
        image_lib.drawLine(
          convertedImage3,
          x1: lowestPointOfRightEyeBrowTop.x.round(),
          y1: lowestPointOfRightEyeBrowTop.y.round(),
          x2: highestPointOfOvalFaceBelowLowestPointOfRightEyeBrowTop.x.round(),
          y2: highestPointOfOvalFaceBelowLowestPointOfRightEyeBrowTop.y.round(),
          color: image_lib.ColorFloat32.rgb(0, 0, 0),
        );

        // connect leftEyeBrowTop with rightEyeBrowTop
        image_lib.drawLine(
          convertedImage3,
          x1: leftEyeBrowTop.points[leftEyeBrowTop.points.length - 1].x.round(),
          y1: leftEyeBrowTop.points[leftEyeBrowTop.points.length - 1].y.round(),
          x2: rightEyeBrowTop.points[rightEyeBrowTop.points.length - 1].x
              .round(),
          y2: rightEyeBrowTop.points[rightEyeBrowTop.points.length - 1].y
              .round(),
          color: image_lib.ColorFloat32.rgb(0, 0, 0),
        );

        // delete the oval face points that above the highest point of oval face that below the lowest point of leftEyeBrowTop
        for (int i = 0; i < ovalFace.points.length; i++) {
          var point = ovalFace.points[i];
          if (point.y <
              highestPointOfOvalFaceBelowLowestPointOfLeftEyeBrowTop.y) {
            ovalFace.points.removeAt(i);
            i--;
          }
        }

        // delete the oval face points that above the highest point of oval face that below the lowest point of rightEyeBrowTop
        for (int i = 0; i < ovalFace.points.length; i++) {
          var point = ovalFace.points[i];
          if (point.y <
              highestPointOfOvalFaceBelowLowestPointOfRightEyeBrowTop.y) {
            ovalFace.points.removeAt(i);
            i--;
          }
        }

        // delete the oval face points that above the highest point of leftEyeBrowTop
        for (int i = 0; i < ovalFace.points.length; i++) {
          var point = ovalFace.points[i];
          if (point.y < highestPointOfLeftEyeBrowTop.y) {
            ovalFace.points.removeAt(i);
            i--;
          }
        }

        // delete the oval face points that above the highest point of rightEyeBrowTop
        for (int i = 0; i < ovalFace.points.length; i++) {
          var point = ovalFace.points[i];
          if (point.y < highestPointOfRightEyeBrowTop.y) {
            ovalFace.points.removeAt(i);
            i--;
          }
        }

        // add the leftEyeBrowTop points to ovalFace
        for (int i = 0; i < leftEyeBrowTop.points.length; i++) {
          var point = leftEyeBrowTop.points[i];
          ovalFace.points.add(point);
        }

        // add the rightEyeBrowTop points to ovalFace
        for (int i = rightEyeBrowTop.points.length - 1; i >= 0; i--) {
          var point = rightEyeBrowTop.points[i];
          ovalFace.points.add(point);
        }

        // add first point as last point to make a closed loop
        ovalFace.points.add(ovalFace.points[0]);

        // draw line from new oval face points
        for (int i = 0; i < ovalFace.points.length; i++) {
          var point = ovalFace.points[i];
          if (i == ovalFace.points.length - 1) {
            break;
          }
          var nextPoint = ovalFace.points[i + 1];
          var line = image_lib.drawLine(
            convertedImage3,
            x1: point.x.round(),
            y1: point.y.round(),
            x2: nextPoint.x.round(),
            y2: nextPoint.y.round(),
            color: image_lib.ColorFloat32.rgb(0, 0, 0),
          );
          convertedImage3 = line;
        }

        // convert List<Point<Int>> to List<Point> from ovalFace
        List<image_lib.Point> points = [];
        for (int i = 0; i < ovalFace.points.length; i++) {
          var point = ovalFace.points[i];
          points.add(image_lib.Point(point.x.round(), point.y.round()));
        }

        // fill the outside of ovalFace with black color
        var filledOutsideOvalFace = image_lib.fill(
          convertedImage3,
          color: image_lib.ColorFloat32.rgb(0, 0, 0),
        );

        //  fill the ovalFace with white color
        var filledOvalFace = image_lib.fillPolygon(
          filledOutsideOvalFace,
          vertices: points,
          color: image_lib.ColorFloat32.rgb(255, 255, 255),
        );

        // only get white area from filledOvalFace and get the image from copyCroppedFaceImage so that can only get the face
        for (int i = 0; i < filledOvalFace.height; i++) {
          for (int j = 0; j < filledOvalFace.width; j++) {
            var color = filledOvalFace.getPixelCubic(j, i);
            if (color.r == 0 && color.g == 0 && color.b == 0) {
              convertedImage4.setPixelRgba(j, i, 0, 0, 0, 0);
            }
          }
        }

        String fileName =
            '${temp.path}/${DateTime.now().toIso8601String()}_$i.png';
        File(fileName).writeAsBytesSync(image_lib.encodePng(
          convertedImage4,
        ));
        result.add(File(fileName));
      }

      return (result, resFace);
    } catch (e) {
      return (<File>[], <Face>[]);
    }
  }

  image_lib.Image _alignFace(Face element, image_lib.Image convertedImage) {
    var leftEye = element.landmarks[FaceLandmarkType.leftEye]!;
    var rightEye = element.landmarks[FaceLandmarkType.rightEye]!;

    Point thirdPoint;
    int direction;

    if (leftEye.position.y < rightEye.position.y) {
      thirdPoint = Point(rightEye.position.x, leftEye.position.y);
      direction = -1;
    } else {
      thirdPoint = Point(leftEye.position.x, rightEye.position.y);
      direction = 1;
    }

    var a = euclideanDistance(leftEye.position, thirdPoint);
    var b = euclideanDistance(rightEye.position, leftEye.position);
    var c = euclideanDistance(rightEye.position, thirdPoint);

    var cosineA = (pow(b, 2) + pow(c, 2) - pow(a, 2)) / (2 * b * c);
    var angleA = acos(cosineA);
    var angle = angleA * (180 / pi);

    if (direction == -1) {
      angle = 90 - angle;
    }

    // rotate the image based on angle
    image_lib.Image rotatedFaceImage = image_lib.copyRotate(
      convertedImage,
      angle: (direction * angle),
    );
    return rotatedFaceImage;
  }

  image_lib.Image _cropFaceArea(Face element, image_lib.Image image) {
    double x = element.boundingBox.left - 45.0;
    double y = element.boundingBox.top - 100.0;
    double w = element.boundingBox.width + 100.0;
    double h = element.boundingBox.height + 200.0;

    image_lib.Image convertedImage3 = image_lib.copyCrop(
      image,
      x: x.round(),
      y: y.round(),
      width: w.round(),
      height: h.round(),
    );

    return convertedImage3;
  }

  num euclideanDistance(Point a, Point b) {
    num x1 = a.x;
    num y1 = a.y;
    num x2 = b.x;
    num y2 = b.y;
    return sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2));
  }

  Future<List<Face>> detectFacesFromImageFile({
    required File source,
  }) async {
    var fileInputImage = InputImage.fromFile(source);

    var result = await _detectFaces(
      fileInputImage,
    );
    return result;
  }

  Future<List<Face>> detectFacesFromCameraImage({
    required CameraImage source,
    required CameraDescription cameraDescription,
    required FaceDetector faceDetector,
  }) async {
    /// Convert To Bytes
    var planes = source.planes;
    final WriteBuffer allBytes = WriteBuffer();
    for (var plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    var resultBytes = allBytes.done().buffer.asUint8List();

    final rotation = InputImageRotationValue.fromRawValue(
      cameraDescription.sensorOrientation,
    );
    if (rotation == null) return [];
    final format = InputImageFormatValue.fromRawValue(source.format.raw);
    if (format == null) return [];

    /// Convert to Metadata
    InputImageMetadata metadata = InputImageMetadata(
      size: Size(source.width.toDouble(), source.height.toDouble()),
      rotation: rotation,
      format: format,
      bytesPerRow: planes.first.bytesPerRow,
    );

    var fileInputImage = InputImage.fromBytes(
      bytes: resultBytes,
      metadata: metadata,
    );
    var result = await _detectFaces(
      fileInputImage,
    );
    return result;
  }

  /// Function TO Detect Face From Input Image
  Future<List<Face>> _detectFaces(
    InputImage inputImage,
  ) async {
    List<Face> facesFromImageFile = [];

    try {
      facesFromImageFile = await faceDetector.processImage(inputImage);
    } catch (e) {
      facesFromImageFile = [];
    }
    return facesFromImageFile;
  }
}
