import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mooxy_pdf/diode_controller.dart';
import 'package:mooxy_pdf/left_section.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

final currentPdfProvider = StateProvider<PdfFile?>((ref) {
  return null;
});
final splitPdfProvider = StateProvider<PdfFile?>((ref) {
  return null;
});
final thirdPdfProvider = StateProvider<PdfFile?>((ref) {
  return null;
});
final fourthPdfProvider = StateProvider<PdfFile?>((ref) {
  return null;
});

final isFirstPdfActive = StateProvider<bool>((ref) {
  return false;
});
final isSecondPdfActive = StateProvider<bool>((ref) {
  return false;
});
final isThirdPdfActive = StateProvider<bool>((ref) {
  return false;
});
final isFourthPdfActive = StateProvider<bool>((ref) {
  return false;
});

class RightSection extends ConsumerStatefulWidget {
  const RightSection({super.key});

  @override
  ConsumerState createState() => _RightSectionState();
}

class _RightSectionState extends ConsumerState<RightSection> {
  final GlobalKey<SfPdfViewerState> _firstPdfViewerKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> _secondPdfViewerKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> _thirdPdfViewerKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> _fourthPdfViewerKey = GlobalKey();
  final PdfViewerController _firstPdfController = PdfViewerController();
  final PdfViewerController _splitPdfController = PdfViewerController();
  final PdfViewerController _thirdPdfController = PdfViewerController();
  final PdfViewerController _fourthPdfController = PdfViewerController();
  TextEditingController _searchTextController = TextEditingController();
  dynamic currentPdf;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPdf = ref.read(pdfFilesProvider).first;
  }

  // List<PdfTextSearchResult>? _searchResult;
  List<PdfTextSearchResult> _searchResult = [];

  void performSearch(List<PdfViewerController> pdfs) {
    // setState(() {
    //   _searchResult.clear(); // Clear previous results
    // });

    for (PdfViewerController pdf in pdfs) {
      final searchResult = pdf.searchText(_searchTextController.text.trim());
      log(searchResult.toString());
        setState(() {
          _searchResult.add(searchResult); // Add the search result to the list
          log(searchResult.totalInstanceCount.toString());
        });
    }
  }


  setZoomLevel(double value) {
    if (ref.read(isFirstPdfActive)) {
      _firstPdfController.zoomLevel = value;
    }
    if (ref.read(isSecondPdfActive)) {
      _splitPdfController.zoomLevel = value;
    }
    if (ref.read(isThirdPdfActive)) {
      _thirdPdfController.zoomLevel = value;
    }
    if (ref.read(isFourthPdfActive)) {
      _fourthPdfController.zoomLevel = value;
    }
  }

// previousSwitcher(){
//   if(ref.read(isFirstPdfActive)){
//     _firstPdfController.zoomLevel=value;
//   }if(ref.read(isSecondPdfActive)){
//     _splitPdfController.zoomLevel=value;
//   }if(ref.read(isThirdPdfActive)){
//     _thirdPdfController.zoomLevel=value;
//   }if(ref.read(isFourthPdfActive)){
//     _fourthPdfController.zoomLevel=value;
//   }
// }

  double defaultZoomLevel = 1;
  @override
  Widget build(BuildContext context) {
    final List<PdfFile> files = ref.watch(pdfFilesProvider);
    log('PDFFILES ${ref.watch(pdfFilesProvider).length}');
    return Container(
        // height: 200,
        // width: 500,
        color: Colors.blue,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                child: Row(
                    children: files
                        .map(
                          (e) => GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              ref
                                                  .read(currentPdfProvider
                                                      .notifier)
                                                  .state = e;
                                            },
                                            child: Text("open pdf"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              ref
                                                  .read(
                                                      splitPdfProvider.notifier)
                                                  .state = e;
                                            },
                                            child: Text("split pdf"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              ref
                                                  .read(
                                                      thirdPdfProvider.notifier)
                                                  .state = e;
                                            },
                                            child: Text("third pdf"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              ref
                                                  .read(fourthPdfProvider
                                                      .notifier)
                                                  .state = e;
                                            },
                                            child: Text("fourth pdf"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Chip(
                                label: Text(e.pdfName),
                                onDeleted: () {
                                  setState(() {
                                    ref
                                        .read(pdfFilesProvider.notifier)
                                        .removePdfFile(e);
                                    files.removeWhere(
                                      (element) => element.pdfId == e.pdfId,
                                    );
                                    if (ref.read(currentPdfProvider)!.pdfId ==
                                        e.pdfId) {
                                      ref
                                          .read(currentPdfProvider.notifier)
                                          .state = null;
                                    }
                                    if (ref.read(splitPdfProvider)!.pdfId ==
                                        e.pdfId) {
                                      ref
                                          .read(splitPdfProvider.notifier)
                                          .state = null;
                                    }
                                    if (ref.read(thirdPdfProvider)!.pdfId ==
                                        e.pdfId) {
                                      ref
                                          .read(thirdPdfProvider.notifier)
                                          .state = null;
                                    }
                                    if (ref.read(fourthPdfProvider)!.pdfId ==
                                        e.pdfId) {
                                      ref
                                          .read(fourthPdfProvider.notifier)
                                          .state = null;
                                    }
                                  });
                                },
                              )),
                        )
                        .toList()),
              ),
              SizedBox(
                height: 100,
                width: 500,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchResult.isNotEmpty) ...{
                      if (ref.watch(isFirstPdfActive)) ...{
                        Text(
                          "${_searchResult[0].currentInstanceIndex} / ${_searchResult[0].totalInstanceCount}",
                          style: TextStyle(fontSize: 16),
                        )
                      },
                      if (ref.watch(isSecondPdfActive)) ...{
                        Text(
                          "${_searchResult[1].currentInstanceIndex} / ${_searchResult[1].totalInstanceCount}",
                          style: TextStyle(fontSize: 16),
                        )
                      },
                      if (ref.watch(isThirdPdfActive)) ...{
                        Text(
                          "${_searchResult[2].currentInstanceIndex} / ${_searchResult[2].totalInstanceCount}",
                          style: TextStyle(fontSize: 16),
                        )
                      },
                      if (ref.watch(isFourthPdfActive)) ...{
                        Text(
                          "${_searchResult[3].currentInstanceIndex} / ${_searchResult[3].totalInstanceCount}",
                          style: TextStyle(fontSize: 16),
                        )
                      },
                    },
                    Flexible(
                      child: TextField(
                        controller: _searchTextController,
                        onSubmitted: (value) {
                          performSearch([
                            _firstPdfController,
                            _splitPdfController,
                            _thirdPdfController,
                            _fourthPdfController,
                          ]);
                        },
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () {
                        if (_searchResult.isNotEmpty) {
                          if (ref.read(isFirstPdfActive)) {
                            _searchResult[0].previousInstance();
                          }
                          if (ref.read(isSecondPdfActive)) {
                            _searchResult[1].previousInstance();
                          }
                          if (ref.read(isThirdPdfActive)) {
                            _searchResult[2].previousInstance();
                          }
                          if (ref.read(isFourthPdfActive)) {
                            _searchResult[3].previousInstance();
                          }
                        }
                      },
                      icon: Icon(Icons.keyboard_arrow_left_rounded),
                    ),
                    IconButton.filledTonal(
                      onPressed: () {
                        if (_searchResult.isNotEmpty) {
                          if (ref.read(isFirstPdfActive)) {
                            _searchResult[0].nextInstance();
                          }
                          if (ref.read(isSecondPdfActive)) {
                            _searchResult[1].nextInstance();
                          }
                          if (ref.read(isThirdPdfActive)) {
                            _searchResult[2].nextInstance();
                          }
                          if (ref.read(isFourthPdfActive)) {
                            _searchResult[3].nextInstance();
                          }
                        }
                      },
                      icon: Icon(Icons.keyboard_arrow_right_rounded),
                    ),
                  ],
                ),
              )
,
              Stack(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width - 300,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double width = ref.watch(thirdPdfProvider) != null ||
                              ref.watch(fourthPdfProvider) != null ||
                              ref.watch(splitPdfProvider) != null
                          ? constraints.maxWidth / 2.2
                          : constraints.maxWidth;
                      double height = ref.watch(thirdPdfProvider) != null ||
                              ref.watch(fourthPdfProvider) != null
                          ? constraints.maxHeight / 2
                          : constraints.maxHeight;
                      return SizedBox(
                        child: Wrap(
                          spacing: 1,
                          runSpacing: 1,
                          children: [
                            SizedBox(
                              height: height,
                              width: width,
                              child: SfPdfViewer.network(
                                ref
                                    .watch(currentPdfProvider)!
                                    .pdfUrl
                                    .toString(),
                                key: _firstPdfViewerKey,
                                controller: _firstPdfController,
                                onTap: (details) {
                                  ref.read(isFirstPdfActive.notifier).state =
                                      true;
                                  ref.read(isSecondPdfActive.notifier).state =
                                      false;
                                  ref.read(isThirdPdfActive.notifier).state =
                                      false;
                                  ref.read(isFourthPdfActive.notifier).state =
                                      false;
                                },
                                maxZoomLevel: 1000,
                                currentSearchTextHighlightColor: Colors.red,
                                otherSearchTextHighlightColor: Colors.green,
                                onTextSelectionChanged: (details) {
                                  _searchTextController.text =
                                      details.selectedText ?? '';
                                },
                                onZoomLevelChanged: (details) {},
                              ),
                            ),
                            if (ref.watch(splitPdfProvider) != null) ...{
                              SizedBox(
                                height: height,
                                width: width,
                                child: SfPdfViewer.network(
                                  ref
                                      .watch(splitPdfProvider)!
                                      .pdfUrl
                                      .toString(),
                                  key: _secondPdfViewerKey,
                                  controller: _splitPdfController,
                                  onTap: (details) {
                                    ref.read(isFirstPdfActive.notifier).state =
                                        false;
                                    ref.read(isSecondPdfActive.notifier).state =
                                        true;
                                    ref.read(isThirdPdfActive.notifier).state =
                                        false;
                                    ref.read(isFourthPdfActive.notifier).state =
                                        false;
                                  },
                                ),
                              )
                            },
                            if (ref.watch(thirdPdfProvider) != null) ...{
                              SizedBox(
                                height: height,
                                width: width,
                                child: SfPdfViewer.network(
                                  ref
                                      .watch(thirdPdfProvider)!
                                      .pdfUrl
                                      .toString(),
                                  key: _thirdPdfViewerKey,
                                  controller: _thirdPdfController,
                                  onTap: (details) {
                                    ref.read(isFirstPdfActive.notifier).state =
                                        false;
                                    ref.read(isSecondPdfActive.notifier).state =
                                        false;
                                    ref.read(isThirdPdfActive.notifier).state =
                                        true;
                                    ref.read(isFourthPdfActive.notifier).state =
                                        false;
                                  },
                                ),
                              )
                            },
                            if (ref.watch(fourthPdfProvider) != null) ...{
                              SizedBox(
                                height: height,
                                width: width,
                                child: SfPdfViewer.network(
                                  ref
                                      .watch(fourthPdfProvider)!
                                      .pdfUrl
                                      .toString(),
                                  key: _fourthPdfViewerKey,
                                  controller: _fourthPdfController,
                                  onTap: (details) {
                                    ref.read(isFirstPdfActive.notifier).state =
                                        false;
                                    ref.read(isSecondPdfActive.notifier).state =
                                        false;
                                    ref.read(isThirdPdfActive.notifier).state =
                                        false;
                                    ref.read(isFourthPdfActive.notifier).state =
                                        true;
                                  },
                                ),
                              ),
                            }
                          ],
                        ),
                      );
                    },
                  ),
                ),
                StatefulBuilder(
                  builder: (context, setState) => Slider(
                    value: defaultZoomLevel,
                    min: 1,
                    max: 10,
                    onChanged: (value) {
                      setState(() {
                        defaultZoomLevel = value;
                        setZoomLevel(value);
                      });
                    },
                  ),
                )
              ])
            ],
          ),
        ));
  }
}
