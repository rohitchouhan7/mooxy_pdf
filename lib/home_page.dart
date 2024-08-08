import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mooxy_pdf/left_section.dart';
import 'package:mooxy_pdf/right_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          LeftSection(),
         if(ref.watch(currentPdfProvider)!=null)...{ RightSection(

         )}
        ],
      ),
    );
  }
}


