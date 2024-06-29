import 'dart:io';

class FaceLivenessTakePictureArgument {
  /// Ketika Error akan langsung menutup halaman liveness
  ///
  /// Response --> ['face-not-found' , 'multiple-face']
  final Function(String error) onError;
  final Function(File result) onConfirmFile;
  const FaceLivenessTakePictureArgument({
    required this.onError,
    required this.onConfirmFile,
  });
}
