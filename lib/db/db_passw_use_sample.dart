import 'package:i_account/db/db_passw.dart';

PWSqlite pwSqlite = new PWSqlite();

Future<bool> getpwat() async {
  await pwSqlite.openSqlite();
  bool authentication = await pwSqlite.loadAuthentication();
  await pwSqlite.close();
  return authentication;
}
