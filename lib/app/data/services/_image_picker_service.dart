import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

class ImagePickerService {
  /// Pick an image from the user's local storage (Flutter Web)
  Future<Map<String, dynamic>?> pickImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // Allow only image files
    uploadInput.click(); // Open the file picker dialog

    final completer = Completer<Map<String, dynamic>?>();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((_) {
          final Uint8List imageData = reader.result as Uint8List;
          final String fileName = file.name;

          completer.complete({
            "imageData": imageData,
            "fileName": fileName,
          });
        });
      } else {
        completer.complete(null);
      }
    });

    return completer.future;
  }
}
