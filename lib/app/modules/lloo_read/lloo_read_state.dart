
import 'package:get/get.dart';

import 'models/search_results.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;


class LlooReadState {
  LlooReadState();

  //=======================================================================
  // SEARCH
  //=======================================================================
  var query = "".obs;
  var resultsData = Rx<SearchResultsData?>(null);
  var carouselIndex = 0.obs;
  var hasBegunSearch = false.obs;   // used to ensure resurrectred search controller deoent re-search


  reset() {
    L.info("STATE", "Resetting state");
    query.value = "";
    resultsData.value = null;
    carouselIndex.value = 0;
    hasBegunSearch.value = false;
  }

  //=======================================================================
  // DETAILS
  //=======================================================================

}

