import 'package:lib_sj/getx/base/page_base.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base_view_state_request_model.dart';

abstract class BaseRefreshStateModel<T> extends ViewStateRequestModel {
  final dataList = <T>[];

  bool enablePullUp = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  int nowPage = 1;

  int pageSize = 10;

  int pageCount = 0;

  addListByPageInfo(List<T>? list, Entity_PageInfo? pageInfo,
      {String? updateKey}) {
    if (pageInfo != null) {
      pageCount = pageInfo.last_page ?? 0;
      pageSize = pageInfo.pageSize;
    }

    // if (list == null) {
    //   list = [];
    // }
    if (_refreshController.isRefresh) {
      dataList.clear();
    }
    if (list != null) {
      dataList.addAll(list);
      MLog.e(
          "BaseRefreshStateModel", "addListByPageInfo size=${dataList.length}");
      if (updateKey != null && updateKey.isNotEmpty) {
        update([updateKey]);
      } else {
        update();
      }
    }
    nowPage++;
    completeRefresh();
    setxRecyclerViewStatusByPageInfo(pageInfo);
  }

  setxRecyclerViewStatusByPageInfo(Entity_PageInfo? pageInfo) {
    if (pageInfo != null) {
      if (pageInfo.nowPage >= pageCount) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
    }
  }

  addList(List<T>? list, int NowPage, int PageCount,
      {int PageSize = 10, String? updateKey}) {
    pageCount = PageCount;
    pageSize = PageSize;

    // if (list == null) {
    //   list = [];
    // }
    if (_refreshController.isRefresh) {
      dataList.clear();
    }
    if (list != null) {
      dataList.addAll(list);
      if (updateKey != null && updateKey.isNotEmpty) {
        update([updateKey]);
      } else {
        update();
      }
      MLog.e("BaseRefreshStateModel", "addList size=${dataList.length}");
    }
    nowPage++;
    completeRefresh();
    setxRecyclerViewStatus(NowPage);
    if (openStatus && dataList.length == 0) {
      setStatusEmpty();
    }
  }

  setxRecyclerViewStatus(int NowPage) {
    if (NowPage >= pageCount) {
      _refreshController.loadNoData();
      enablePullUp = false;
    } else {
      _refreshController.loadComplete();
      enablePullUp = true;
    }
  }

  completeRefresh() {
    _refreshController.refreshCompleted();
  }

  refreshFail(bool isRefresh) {
    if (isRefresh) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.loadFailed();
    }
    if (openStatus) {
      if (dataList.length != 0) {
        setStatusIdle();
      } else {
        setStatusErrorEmptyData();
      }
    }
  }

  get refreshController => _refreshController;

  refreshErrorComplete() {
    _refreshController.refreshCompleted();
  }

  initNowPage(bool isRefresh) {
    if (isRefresh) {
      nowPage = 1;
      dataList.clear();
    }
  }

  getLength() {
    return dataList.length;
  }

  bool canPullUp() {
    return enablePullUp;
  }

  setRefreshController(RefreshController controller) {
    _refreshController = controller;
  }

  startRefresh() {
    _refreshController.requestRefresh();
  }
}
