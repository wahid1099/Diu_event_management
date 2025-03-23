import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  late final String cloudName;
  late final String apiKey;
  late final String apiSecret;

  CloudinaryService() {
    dotenv.load(fileName: ".env"); // ✅ Load environment variables here
    cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
    apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
    apiSecret = dotenv.env['CLOUDINARY_SECRET']!;
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      var request = http.MultipartRequest("POST", url);
      request.fields["upload_preset"] = "ml_default";
      request.fields["api_key"] = apiKey;
      request.fields["timestamp"] =
          DateTime.now().millisecondsSinceEpoch.toString();

      var mimeType = lookupMimeType(imageFile.path) ?? "image/jpeg";
      var fileStream = http.ByteStream(imageFile.openRead());
      var fileLength = await imageFile.length();

      var multipartFile = http.MultipartFile(
        "file",
        fileStream,
        fileLength,
        filename: basename(imageFile.path),
        contentType: MediaType.parse(mimeType),
      );

      request.files.add(multipartFile);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return responseBody; // ✅ Successfully uploaded
      } else {
        print("Failed to upload image: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
