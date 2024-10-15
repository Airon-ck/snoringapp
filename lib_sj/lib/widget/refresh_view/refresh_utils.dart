import 'package:pull_to_refresh/pull_to_refresh.dart';

getRefreshController(bool initialRefresh) {
  return RefreshController(initialRefresh: initialRefresh);
}
