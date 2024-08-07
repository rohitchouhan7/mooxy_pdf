import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mooxy_pdf/diode_controller.dart';
import 'package:mooxy_pdf/diode_tabbar.dart';
import 'package:mooxy_pdf/direct_solutions_controller.dart';
import 'package:mooxy_pdf/direct_solutions_tabbar.dart';
import 'package:mooxy_pdf/providers.dart';
StateProvider<bool> isLeftSectionOpen= StateProvider((ref) => true,) ;
final pdfFilesProvider = StateNotifierProvider<PdfFilesNotifier, List<PdfFile>>((ref) {
  return PdfFilesNotifier();
});

class PdfFilesNotifier extends StateNotifier<List<PdfFile>> {
  PdfFilesNotifier() : super([]);

  void addPdfFile(PdfFile file) {
    state = [...state, file]; // Create a new list instance
  }
}
class LeftSection extends ConsumerStatefulWidget {
  const LeftSection({super.key});

  @override
  ConsumerState createState() => _LeftSectionState();
}

class _LeftSectionState extends ConsumerState<LeftSection> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController= TabController(length: 4, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      color: Colors.grey[900],
      width:ref.watch(isLeftSectionOpen)==true?300:50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(onPressed: (){
                ref.read(isLeftSectionOpen.notifier).state=!ref.read(isLeftSectionOpen);
              }, icon: Icon(Icons.cancel_outlined))
            ],
          ),
          TabBar(
            indicator: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(50)
            ),
            labelPadding: EdgeInsets.symmetric(horizontal: 10),
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
tabAlignment: TabAlignment.start,
            tabs: [
            Tab(
              text: 'Direct Solutions',
            ),
            Tab(
              text: 'Diode',
            ),
            Tab(
              text: 'Direct Solutions',
            ),
            Tab(
              text: 'Direct Solutions',
            ),
          ],
          controller: _tabController,),

          Flexible(
            child: TabBarView(children: [
              DirectSolutionsTabBar(),
              DiodeTabBar(),
              Text('hdfdf'),
              Text('hdfdf'),
            ],
              controller: _tabController,
            ),
          )
        ],
      ),
    );
  }
}






