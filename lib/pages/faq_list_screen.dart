import 'a_pages_index.dart';

class FaqListScreen extends StatefulWidget {
  static const String routeName = "/faq_screen";

  @override
  _FaqListScreenState createState() => _FaqListScreenState();
}

class _FaqListScreenState extends State<FaqListScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    print('page frame');

    Widget faqCategoryListWidget(
        BuildContext context, String category, String categoryTitle) {
      return InkWell(
        focusColor: androidTVFocusColor,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => faqList(context, category, categoryTitle),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: yipliBlack,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: yipliNewBlue,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    categoryTitle,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return YipliPageFrame(
      title: Text('FAQ'),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.question_answer_outlined, color: yipliNewBlue),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'How can we help you?',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: Column(
                        children: [
                          faqCategoryListWidget(
                            context,
                            'introduction',
                            'Introduction',
                          ),
                          faqCategoryListWidget(
                            context,
                            'setup-and-usage',
                            'Setup and Usage',
                          ),
                          faqCategoryListWidget(
                            context,
                            'features',
                            'Features',
                          ),
                          faqCategoryListWidget(
                            context,
                            'technical',
                            'Technical',
                          ),
                          faqCategoryListWidget(
                            context,
                            'rewards',
                            'Rewards',
                          ),
                          SizedBox(
                            height: screenSize.height * 0.3,
                          )
                        ],
                      ),
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

  Widget faqList(BuildContext context, String category, String categoryTitle) {
    Query faqFromDB = FirebaseDatabaseUtil()
        .rootRef
        .child("inventory")
        .child("faq")
        .orderByChild("category")
        .equalTo(category);

    return StreamBuilder<Event>(
        stream: faqFromDB.onValue,
        builder: (context, event) {
          if ((event.connectionState == ConnectionState.waiting) ||
              event.hasData == null)
            return YipliLoaderMini(loadingMessage: 'Loading Faq');

          FaqCategory faqModel =
              new FaqCategory.fromSnapshotValue(event.data.snapshot);

          return YipliPageFrame(
            title: Text(categoryTitle),
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: faqModel.allFaq.length,
                itemBuilder: (context, index) {
                  return FaqListWidget(faqModel.allFaq[index]);
                }),
          );
        });
  }
}
