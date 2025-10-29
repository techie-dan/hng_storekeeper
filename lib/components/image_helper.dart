import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<String?> pickAndSaveImage() async {
  final picker = ImagePicker();
  final XFile? picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

  if (picked == null) return null;

  final appDir = await getApplicationDocumentsDirectory();
  final fileName = basename(picked.path);
  final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');
  return savedImage.path; // store this path in DB
}
