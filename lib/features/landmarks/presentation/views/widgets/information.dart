import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/constants.dart';
import 'package:graduation/core/utils/style.dart';
import 'package:graduation/features/home/data/models/most_visited_model/most_visited_model.dart';
import 'package:graduation/features/landmarks/data/model/landmark_on_cat_model/landmark_on_cat_model.dart';
import 'package:graduation/features/landmarks/presentation/manger/more_info_cubit/more_info_cubit.dart';
import 'package:graduation/features/review_onlandmark/pres/comment.dart';

class Information extends StatefulWidget {
  const Information({Key? key, required this.text,  this.landmarkmodel, this.mostvistedkmodel})
      : super(key: key);

  final String text;
  final LandmarkOnCatModel? landmarkmodel;
      final MostVisitedModel? mostvistedkmodel;


  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool showFullText = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final infoTextStyle = Textstyle.textStyle15.copyWith(color: kmaincolor);
    final reviewTextStyle = Textstyle.textStyle15.copyWith(color: kmaincolor);
    return Column(
      mainAxisSize: MainAxisSize.min, // Set to take only the required space
      children: [
        TabBar(
          controller: _tabController,
          indicatorWeight: 1,
          dividerColor: kbackgroundcolor,
          indicatorColor: kmaincolor,
          isScrollable: true,
          onTap: (value) {
            setState(() {});
          },
          tabs: [
            Tab(
              child: Text(
                '   Information  ',
                style: Textstyle.textStyle15.copyWith(color: kmaincolor),
              ),
            ),
            Tab(
              child: Text(
                '     Reviews    ',
                style: Textstyle.textStyle15.copyWith(color: kmaincolor),
              ),
            ),
          ],
        ),
        // Add a SizedBox to constrain the height of the TabBarView
        SizedBox(
          height: 400, // Set a fixed height for the TabBarView
          child: TabBarView(
            controller: _tabController,
            children: [
              BlocConsumer<MoreInfoCubit, MoreInfoState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is MoreInfoInitial) {
                    BlocProvider.of<MoreInfoCubit>(context).viewmore(
                      text: widget.text,
                      showmore: showFullText,
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showFullText = false;
                            });
                            BlocProvider.of<MoreInfoCubit>(context).viewmore(
                              text: widget.text,
                              showmore: showFullText,
                            );
                          },
                          child: Text(
                            '${BlocProvider.of<MoreInfoCubit>(context).Text}',
                            style: Textstyle.textStyle12.copyWith(
                              color: neutralColor3,
                                fontWeight: FontWeight.w400, height: 1.7),
                          ),
                        ),
                        if (BlocProvider.of<MoreInfoCubit>(context)
                                    .showView_more_Details ==
                                true &&
                            !showFullText)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  showFullText = true;
                                });
                                BlocProvider.of<MoreInfoCubit>(context)
                                    .viewmore(
                                  text: widget.text,
                                  showmore: showFullText,
                                );
                              },
                              child:  Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('View more Details',
                                        style: Textstyle.viewmoretext),
                                    Icon(Icons.keyboard_arrow_down,
                                        color: Color(0xff00A2D5)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              ReviewPage(
                  landmarkmodel: widget
                      .landmarkmodel,mostvistedkmodel: widget.mostvistedkmodel,), // Pass the actual landmark model instance
            ],
          ),
        ),
      ],
    );
  }
}
