import 'package:flutter_app/page_models/page_model_index.dart';

class FaqCategory {
  static String refName = "faq";

  List<FaqDetails> allFaq;

  FaqCategory() {
    allFaq = new List<FaqDetails>();
  }

  FaqCategory.fromSnapshotValue(DataSnapshot faqSnapshot) {
    allFaq = new List<FaqDetails>();

    LinkedHashMap fetchedFaqMap = faqSnapshot.value;
    if (fetchedFaqMap != null) {
      for (var faq in fetchedFaqMap.entries) {
        if (faq == null) {
          print('skipped');
        } else {
          FaqDetails faqDetails =
              new FaqDetails(faq.value['question'], faq.value['answer']);
          allFaq.add(faqDetails);
        }
      }
    } else
      print('faq list null');
  }
}
