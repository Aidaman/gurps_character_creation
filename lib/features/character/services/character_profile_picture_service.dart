import 'dart:io';
import 'dart:typed_data';
import 'package:gurps_character_creation/core/services/service_locator.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

import 'package:gurps_character_creation/core/services/app_directory_service.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:path_provider/path_provider.dart';

class CharacterProfilePictureService {
  static Future<List<int>> _convertToPng(Uint8List bytes) async {
    final img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw const FormatException('Could not decode an image');
    }

    return img.encodePng(image);
  }

  static Future<File> _beforeEach() async {
    final String characterId =
        serviceLocator.get<CharacterProvider>().character.id;

    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath =
        '${ApplicationDirectories.USER_CHARACTER_PROFILE_PICTURES_DIRECTORY.stringValue}/$characterId.png';

    final String fullPath = path.join(directory.path, filePath);

    return File(fullPath);
  }

  static Future<void> saveProfilePicture(Uint8List bytes) async {
    try {
      File charPFP = await _beforeEach();
      final pngBytes = await _convertToPng(bytes);

      await charPFP.writeAsBytes(pngBytes);
    } catch (e) {
      throw Exception('Failed to save character PFP');
    }
  }

  static Future<Uint8List> loadProfilePictureBytes() async {
    try {
      File charPFP = await _beforeEach();
      return await charPFP.readAsBytes();
    } catch (e) {
      throw Exception('Failed to load character PFP');
    }
  }
}
