//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lib_sj/lib_sj.dart';
// import 'package:lib_sj/util/toast.dart';
// @deprecated
// abstract class ViewStateModel extends GetxController {
//   /// 当前的页面状态,默认为idle,可在viewModel的构造方法中指定;
//   late ViewState _viewState;
//
//   /// ViewStateError
//   ViewStateError? _viewStateError;
//
//   ViewStateModel({ViewState? viewState}) {
//     _viewState = viewState ?? ViewState.idle;
//   }
//
//   ViewState get viewState => _viewState;
//
//   ViewState getViewState() {
//     return _viewState;
//   }
//
//   set viewState(ViewState viewState) {
//     _viewStateError = null;
//     _viewState = viewState;
//   }
//
//   ViewStateError? get viewStateError => _viewStateError;
//
//   bool get isLoading => viewState == ViewState.loading;
//
//   bool get isIdle => viewState == ViewState.idle;
//
//   bool get isEmpty => viewState == ViewState.empty;
//
//   bool get isError => viewState == ViewState.error;
//
//   void setStatusIdle() {
//     viewState = ViewState.idle;
//   }
//
//   void setStatusLoading() {
//     viewState = ViewState.loading;
//   }
//
//   void setStatusEmpty() {
//     viewState = ViewState.empty;
//   }
//
//   void setStatusError() {
//     viewState = ViewState.error;
//   }
//
//   /// [e]分类Error和Exception两种
//   // void setError(e, stackTrace, {String? message}) {
//   //   _viewStateError = ErrorParse.getViewStateError(e);
//   //   printErrorStack(e, stackTrace);
//   //   onError(viewStateError);
//   // }
//   //
//   // void onError(ViewStateError? viewStateError) {}
//
//   /// 显示错误消息
//   showErrorMessage(String? message) {
//     if (message != null) {
//       Future.microtask(() {
//         ToastUtil.showShort(message);
//       });
//     }
//   }
//
//   @override
//   String toString() {
//     return 'ViewStateModel{ _viewStateError: $_viewStateError}';
//   }
// }
//
// /// [e]为错误类型 :可能为 Error , Exception ,String
// /// [s]为堆栈信息
// printErrorStack(e, s) {
//   debugPrint('''
// <-----↓↓↓↓↓↓↓↓↓↓-----error-----↓↓↓↓↓↓↓↓↓↓----->
// $e
// <-----↑↑↑↑↑↑↑↑↑↑-----error-----↑↑↑↑↑↑↑↑↑↑----->''');
//   if (s != null) debugPrint('''
// <-----↓↓↓↓↓↓↓↓↓↓-----trace-----↓↓↓↓↓↓↓↓↓↓----->
// $s
// <-----↑↑↑↑↑↑↑↑↑↑-----trace-----↑↑↑↑↑↑↑↑↑↑----->
//     ''');
// }
