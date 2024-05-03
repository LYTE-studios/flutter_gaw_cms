import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gaw_cms/core/widgets/file/file_upload_zone.dart';
import 'package:gaw_ui/gaw_ui.dart';

class FileUploadForm extends StatefulWidget {
  final Function(File? file, Uint8List data)? onUpdateFile;
  final Function()? onRemoveFile;

  final File? file;
  final Uint8List? rawData;

  const FileUploadForm({
    super.key,
    this.onUpdateFile,
    this.onRemoveFile,
    this.file,
    this.rawData,
  });

  @override
  State<FileUploadForm> createState() => _FileUploadFormState();
}

class _FileUploadFormState extends State<FileUploadForm> {
  @override
  Widget build(BuildContext context) {
    return GawForm(
      rows: [
        const FormRow(
          formItems: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormTitle(
                  label: 'Upload profile picture',
                ),
                MainText(
                  'Select image to complete users profile',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: PaddingSizes.mainPadding,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: FileUploadZone(
            onUpdateFile: widget.onUpdateFile,
            selectedFile: widget.file,
            rawData: widget.rawData,
            onRemoveImage: widget.onRemoveFile,
          ),
        )
      ],
    );
  }
}
