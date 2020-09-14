import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import 'package:fluro/fluro.dart';
import './provide/count.dart';
import './provide/child_category.dart';
import './provide/caregory_goods_list.dart';
import './routers/routers.dart';
import './routers/application.dart';

void main() {
  var counter2 = Counter();
  var childCategory = ChildCategory();
  var caregoryGoodsListProvide = CategoryGoodsListProvide();
  var provides = Providers();



  provides
    ..provide(Provider<Counter>.value(counter2))
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<CategoryGoodsListProvide>.value(caregoryGoodsListProvide));

   runApp(ProviderNode(child: MyApp(), providers: provides,) );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.



  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: 'Human life+',
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
      ),
    );
  }
}



