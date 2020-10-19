import 'package:i_account/routers/router_init.dart';
import 'package:fluro/fluro.dart';
import 'bill_list_page.dart';
import 'package:i_account/pages/newbill.dart';

class BillRouter implements IRouterProvider {
  static String billPage = '/bill';
  static String bookkeepPage = '/bill/bookkeep';

  @override
  void initRouter(FluroRouter router) {
    router.define(billPage,
        handler: Handler(handlerFunc: (_, params) => Bill()));
    router.define(bookkeepPage,
        handler: Handler(handlerFunc: (_, params) => NewPage()));
  }
}
