import 'dart:io';

import 'package:path_provider/path_provider.dart';

final String directoryForNotes = '/notes';

class FileService {
  Future<File> get _localFileForNote async {
    final date = DateTime.now().toUtc().toString();
    final path = await _localPath;
    return File('$path/$date').create(recursive: true);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path + directoryForNotes;
  }

  Future<List<Object>> get _localNotes async {
    final List<Object> notes = [];
    final directory = Directory(await _localPath);
     await for (var entity in
     directory.list(recursive: true, followLinks: false)) {
       final file = File(entity.path);
       notes.add({'date': DateTime.now().toUtc().toString(), 'note': await file.readAsString()});
     }

    return notes;
  }

  writeFile(String text) async {
    final file = await _localFileForNote;
    await file.writeAsString(text);
  }

  Future<List<Object>> getLocalNotes(int numToGet) async {
    return await _localNotes;
  }
}
