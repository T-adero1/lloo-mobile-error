import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/modules/lloo_read/lloo_read_styles.dart';
import 'package:lloo_mobile/app/modules/lloo_read/widgets/memories_node_graph.dart';
import 'package:lloo_mobile/app/modules/lloo_read/widgets/stage_progress_widget.dart';
import 'package:lloo_mobile/app/modules/lloo_read/widgets/primary_results_row.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;

import 'package:lloo_mobile/app/core/base/lloo_view.dart';
import 'package:lloo_mobile/app/app_theme.dart';
import '../../../app_styles.dart';
import 'package:lloo_mobile/app/core/models/memory.dart';
import 'package:lloo_mobile/app/core/widgets/lloo_navbar.dart';
import '../controllers/search_results_view_controller.dart' as lloo;
import '../lloo_read_state.dart';
import '../models/search_results.dart';
import '../widgets/standard_results_list.dart';


class SearchResultsView extends LlooView<lloo.SearchResultsViewController, LlooReadState> {
  SearchResultsView({super.key});

  @override
  Widget build(BuildContext context) {

    // Style consts
    const kSectionSpacing = 28.0;

    return Scaffold(
        body:
        SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //=======================================================================
                // NAVBAR
                //=======================================================================

                LlooNavbar(),

                //=======================================================================
                // QUERY AS TITLE
                //=======================================================================
                // @TODO make this auto-size
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kScreenPaddingSizeLR, vertical: kSectionSpacing),
                  child: Text(
                    state.query.value,
                    style: theme.textTheme.headlineLarge,
                  ),
                ),

                //=======================================================================
                // NODE GRAPH & LLM SUMMARY
                //=======================================================================
                // @TODO: Make this like a carousel
                SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          //=======================================================================
                          // LLM SUMMARY
                          //=======================================================================

                          Obx(() {
                            final llmSummary = state.resultsData.value?.llmSummary;
                            final hasText = llmSummary?.isNotEmpty ?? false;

                            // Animate width and fade it in
                            return AnimatedContainer(duration: Duration(milliseconds: 250), width: hasText ? 260 : 0,
                              child: AnimatedOpacity(duration: Duration(milliseconds: 500), opacity: hasText ? 1.0 : 0.0,
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(left: kScreenPaddingSizeLR,),
                                  width: 260,
                                  child: AutoSizeText(
                                    llmSummary ?? '',
                                    style: theme.textTheme.bodyMedium!.copyWith(fontSize: 18),
                                    maxFontSize: 21,
                                    minFontSize: 11,
                                    stepGranularity: 0.1,
                                    maxLines: 22,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            );
                          }),

                          //=======================================================================
                          // NODE GRAPH
                          //=======================================================================
                          // we want to centered until the summary text comes in
                          // then we want it closer to the summary text so it's
                          // seen on the right side of the screen
                          Obx(() {
                            // @TODO DRY with above
                            final llmSummary = state.resultsData.value?.llmSummary;
                            final hasText = llmSummary?.isNotEmpty ?? false;
                            return SizedBox(width: hasText ? 0 : 40);
                          }),

                          Container(
                            // duration: Duration(milliseconds: 250),
                            width: 310,
                            height: 300,
                            color: theme.scaffoldBackgroundColor,
                            child: MemoriesNodeGraph(
                                controller: controller.graphController),
                          ),
                        ],
                      ),
                    )
                  // }),
                ),

                //=======================================================================
                // PROGRESS WIDGET
                // - reactivity handled manually in controller
                //=======================================================================
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: kSectionSpacing,
                      horizontal: kScreenPaddingSizeLR
                  ),
                  child: StageProgressWidget(controller: controller.progressWidgetController),
                ),


                //=======================================================================
                // PRIMARY RESULTS ROW
                // - Animate open the space and fade it when available
                //=======================================================================
                Obx( () {
                  const kCardWidth = 300.0;
                  const kCardHeight = 400.0;

                  final resultsUsed = state.resultsData.value?.memoriesUsed ?? [];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: resultsUsed.isNotEmpty ? kCardHeight : 0,  // @TODO: DRY this up with the PRCard sizing
                    curve: Curves.easeInOut,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: resultsUsed.isNotEmpty ? 1.0 : 0.0,
                      child: PrimaryResultsRow(
                          memories: resultsUsed,
                          cardWidth: kCardWidth,
                          cardHeight: kCardHeight,
                          onMemoryTapped: (memory) => controller.handleMemoryTapped(memory)
                      ),
                    ),
                  );
                }),

                //=======================================================================
                // QUERY RESULTS
                //=======================================================================
                Obx(() {
                  return StandardResultsList(
                      memories: state.resultsData.value?.documentTypeMemories ?? [],
                      onMemoryTapped: (memory) => controller.handleMemoryTapped(memory),
                  );
                })
              ]
          ),
        )
      // )
    );
  }
}

