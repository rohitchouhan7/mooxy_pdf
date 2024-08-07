import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mooxy_pdf/diode_controller.dart';
import 'package:mooxy_pdf/providers.dart';

class DiodeTabBar extends ConsumerStatefulWidget {
  const DiodeTabBar({super.key});

  @override
  ConsumerState createState() => _DiodeTabBarState();
}

class _DiodeTabBarState extends ConsumerState<DiodeTabBar> {
  final DiodeAppControllers _appControllers = DiodeAppControllers();
  late Future<BrandResponse> _brandsFuture;

  @override
  void initState() {
    super.initState();
    _brandsFuture = _appControllers.getAllDirectSolutionsBrands();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BrandResponse>(
      future: _brandsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final BrandResponse brands = snapshot.data!;

        return ListView.separated(
          separatorBuilder: (context, index) => Container(
              width:double.maxFinite,
              height: 5,
              color:Colors.grey[800]
          ),
          itemCount: 10,
          itemBuilder: (context, index) => ExpansionTile(
            title: Text('${brands.data[index].name}'),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                AppStateProviders.prifixUrl+brands.data[index].icon,
              ),
            ),
            onExpansionChanged: (value) {
              // log(brands.data[index].id??'');
              // AppControllers().getAllSubBrandsByPBrand(brands.data[index].id??'');
            },
            children: [
              FutureBuilder(future: _appControllers.getAllSubBrandsByPBrand(brands.data[index].id??''), builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                  return Center(child: Text('No data available'));
                }

                final SubBrandResponse subBrands = snapshot.data!;
                log(subBrands.data.length.toString());
                return ListView.separated(
                  separatorBuilder: (context, index) => Container(
                      width:double.maxFinite,
                      height: 2,
                      color:Colors.grey[800]
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: subBrands.data.length,
                  itemBuilder: (context, innerIndex) => ExpansionTile(
                    title: Text('${subBrands.data[innerIndex].name}'),
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        AppStateProviders.prifixUrl+subBrands.data[innerIndex].icon,

                      ),
                    ),
                    onExpansionChanged: (value) {
                      log(subBrands.data[innerIndex].id??'');
                    },
                    children: [
                      FutureBuilder(future: _appControllers.getAllSubSubBrandsByPBrand(subBrands.data[innerIndex].id??''), builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.pdfData.isEmpty) {
                          return Center(child: Text('No data available'));
                        }

                        final SubSubBrandResponse subSubBrands = snapshot.data!;
                        log(subSubBrands.pdfData.length.toString());
                        return ListView.separated(
                            separatorBuilder: (context, index) => Container(
                                width:double.maxFinite,
                                height: 1,
                                color:Colors.grey[800]
                            ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: subSubBrands.pdfData.length,
                            itemBuilder: (context, innerSubIndex) {
                              final pdfData=subSubBrands.pdfData[innerSubIndex];
                              return ListTile(
                                title: Text(
                                    pdfData['name']),
                              );
                            }
                        );
                      },)
                    ],
                  ),
                );
              },)

            ],
          ),
        );
      },
    );
  }
}