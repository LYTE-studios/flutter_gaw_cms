import 'dart:html';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:gaw_ui/gaw_ui.dart';

class FileUploadZone extends StatefulWidget {
  final File? selectedFile;
  final Uint8List? rawData;

  final Function(File file, Uint8List data)? onUpdateFile;

  final Function()? onRemoveImage;

  const FileUploadZone({
    super.key,
    this.selectedFile,
    this.rawData,
    this.onUpdateFile,
    this.onRemoveImage,
  });

  @override
  State<FileUploadZone> createState() => _FileUploadZoneState();
}

class _FileUploadZoneState extends State<FileUploadZone> with ScreenStateMixin {
  bool isHovering = false;

  late DropzoneViewController controller;

  File platformFileToFile(PlatformFile platformFile) {
    return File(
      platformFile.bytes?.toList() ?? [],
      platformFile.name,
    );
  }

  void pickFile() {
    setLoading(true);

    FilePicker.platform
        .pickFiles(
      type: FileType.image,
    )
        .then((FilePickerResult? result) {
      if (result?.files.isEmpty ?? true) {
        return;
      }

      widget.onUpdateFile?.call(
          platformFileToFile(result!.files.first), result.files.first.bytes!);
    }).whenComplete(() => setLoading(false));
  }

  Future<void> onDrop(dynamic result) async {
    setState(() {
      isHovering = false;
      loading = true;
    });
    if (result == null) {
      return;
    }

    Uint8List data = await controller.getFileData(result);

    String name = await controller.getFilename(result);

    File file = File(
      data,
      name,
    );

    setLoading(false);

    widget.onUpdateFile?.call(
      file,
      data,
    );
  }

  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      width: 470,
      child: Stack(
        children: [
          DropzoneView(
            onCreated: (ctrl) => controller = ctrl,
            onHover: () {
              setState(() {
                isHovering = true;
              });
            },
            onLeave: () {
              setState(() {
                isHovering = false;
              });
            },
            onDrop: (result) {
              onDrop(result);
            },
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: DottedBorder(
              color: GawTheme.unselectedText,
              strokeWidth: 0.5,
              borderType: BorderType.RRect,
              dashPattern: const [4, 3],
              radius: const Radius.circular(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: !isHovering
                      ? Colors.transparent
                      : GawTheme.mainTint.withOpacity(0.2),
                  child: LoadingSwitcher(
                    loading: loading,
                    color: GawTheme.secondaryTint,
                    child: widget.rawData != null
                        ? _FileSelectedView(
                            file: widget.rawData,
                            onRemove: widget.onRemoveImage,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: PaddingSizes.extraBigPadding +
                                    PaddingSizes.mainPadding,
                              ),
                              const Center(
                                child: SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: SvgIcon(
                                    PixelPerfectIcons.upload,
                                    color: GawTheme.unselectedText,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: PaddingSizes.bigPadding,
                              ),
                              const Center(
                                child: MainText(
                                  'Select a file or drag and drop here',
                                ),
                              ),
                              const SizedBox(
                                height: PaddingSizes.extraBigPadding,
                              ),
                              Center(
                                child: SizedBox(
                                  height: 42,
                                  width: 128,
                                  child: _SelectFileButton(
                                    onTap: pickFile,
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FileSelectedView extends StatelessWidget {
  final Uint8List? file;

  final Function()? onRemove;

  const _FileSelectedView({
    this.file,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 164,
        width: 164,
        child: ProfilePictureAvatar(
          bytes: file,
          canRemove: true,
          onRemovePressed: onRemove,
          showCircle: true,
        ),
      ),
    );
  }
}

class _SelectFileButton extends StatelessWidget {
  final Function()? onTap;

  const _SelectFileButton({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ColorlessInkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: GawTheme.clearText,
          borderRadius: BorderRadius.circular(8),
          border: const Border.fromBorderSide(
            Borders.thickMainTintSide,
          ),
        ),
        child: const Center(
          child: MainText(
            'Select file',
            color: GawTheme.mainTint,
          ),
        ),
      ),
    );
  }
}
