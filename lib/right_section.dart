import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mooxy_pdf/diode_controller.dart';
import 'package:mooxy_pdf/left_section.dart';

class RightSection extends ConsumerStatefulWidget {
  const RightSection({super.key});

  @override
  ConsumerState createState() => _RightSectionState();
}

class _RightSectionState extends ConsumerState<RightSection> {
  @override
  Widget build(BuildContext context) {
    final List<PdfFile> files= ref.watch(pdfFilesProvider);
    log('PDFFILES ${ref.watch(pdfFilesProvider).length}');
    return Container(
          height: 200,
          width: 500,
          color: Colors.blue,
          child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
            return Text(files[index].toString());
          },)
    );
  }
}
