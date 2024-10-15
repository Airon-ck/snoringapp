class Entity_PageInfo {
  //总页数
  int? total;

  //page_size

  String? per_page;

  String? current_page;

  int? last_page;

  int get pageSize {
    return per_page == null ? 0 : int.parse(per_page!);
  }

  int get nowPage {
    return current_page == null ? 1 : int.parse(current_page!);
  }

  setNowPage(int nowPage) {}
}
