// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `安睡有氧`
  String get appName {
    return Intl.message(
      '安睡有氧',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `skip`
  String get skip {
    return Intl.message(
      'skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Click again to exit APP`
  String get exit_app {
    return Intl.message(
      'Click again to exit APP',
      name: 'exit_app',
      desc: '',
      args: [],
    );
  }

  /// `get verification code`
  String get send_code {
    return Intl.message(
      'get verification code',
      name: 'send_code',
      desc: '',
      args: [],
    );
  }

  /// `resend ({second}s)`
  String resend_code(Object second) {
    return Intl.message(
      'resend (${second}s)',
      name: 'resend_code',
      desc: '',
      args: [second],
    );
  }

  /// `Release to load more`
  String get canLoadingText {
    return Intl.message(
      'Release to load more',
      name: 'canLoadingText',
      desc: '',
      args: [],
    );
  }

  /// `Release to refresh`
  String get canRefreshText {
    return Intl.message(
      'Release to refresh',
      name: 'canRefreshText',
      desc: '',
      args: [],
    );
  }

  /// `Release to enter secondfloor`
  String get canTwoLevelText {
    return Intl.message(
      'Release to enter secondfloor',
      name: 'canTwoLevelText',
      desc: '',
      args: [],
    );
  }

  /// `Pull up Load more`
  String get idleLoadingText {
    return Intl.message(
      'Pull up Load more',
      name: 'idleLoadingText',
      desc: '',
      args: [],
    );
  }

  /// `Pull down Refresh`
  String get idleRefreshText {
    return Intl.message(
      'Pull down Refresh',
      name: 'idleRefreshText',
      desc: '',
      args: [],
    );
  }

  /// `Load Failed`
  String get loadFailedText {
    return Intl.message(
      'Load Failed',
      name: 'loadFailedText',
      desc: '',
      args: [],
    );
  }

  /// `Loading…`
  String get loadingText {
    return Intl.message(
      'Loading…',
      name: 'loadingText',
      desc: '',
      args: [],
    );
  }

  /// `No more data`
  String get noMoreText {
    return Intl.message(
      'No more data',
      name: 'noMoreText',
      desc: '',
      args: [],
    );
  }

  /// `Refresh completed`
  String get refreshCompleteText {
    return Intl.message(
      'Refresh completed',
      name: 'refreshCompleteText',
      desc: '',
      args: [],
    );
  }

  /// `Refresh failed`
  String get refreshFailedText {
    return Intl.message(
      'Refresh failed',
      name: 'refreshFailedText',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing…`
  String get refreshingText {
    return Intl.message(
      'Refreshing…',
      name: 'refreshingText',
      desc: '',
      args: [],
    );
  }

  /// `Please try again`
  String get try_again {
    return Intl.message(
      'Please try again',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `Saved to album!`
  String get saved_to_album {
    return Intl.message(
      'Saved to album!',
      name: 'saved_to_album',
      desc: '',
      args: [],
    );
  }

  /// `Save failure!`
  String get save_failure {
    return Intl.message(
      'Save failure!',
      name: 'save_failure',
      desc: '',
      args: [],
    );
  }

  /// `Save successfully`
  String get save_successfully {
    return Intl.message(
      'Save successfully',
      name: 'save_successfully',
      desc: '',
      args: [],
    );
  }

  /// `You denied the permission, causing the function to be unavailable！`
  String get denied_permission_desc {
    return Intl.message(
      'You denied the permission, causing the function to be unavailable！',
      name: 'denied_permission_desc',
      desc: '',
      args: [],
    );
  }

  /// `Copied！`
  String get copied {
    return Intl.message(
      'Copied！',
      name: 'copied',
      desc: '',
      args: [],
    );
  }

  /// `Network unavailable!`
  String get network_unavailable {
    return Intl.message(
      'Network unavailable!',
      name: 'network_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Start downloading`
  String get start_downloading {
    return Intl.message(
      'Start downloading',
      name: 'start_downloading',
      desc: '',
      args: [],
    );
  }

  /// `Deupdate`
  String get go_update {
    return Intl.message(
      'Deupdate',
      name: 'go_update',
      desc: '',
      args: [],
    );
  }

  /// `Not updated temporarily`
  String get not_updated_temporarily {
    return Intl.message(
      'Not updated temporarily',
      name: 'not_updated_temporarily',
      desc: '',
      args: [],
    );
  }

  /// `Downloading`
  String get downloading {
    return Intl.message(
      'Downloading',
      name: 'downloading',
      desc: '',
      args: [],
    );
  }

  /// `Download completed`
  String get download_completed {
    return Intl.message(
      'Download completed',
      name: 'download_completed',
      desc: '',
      args: [],
    );
  }

  /// `The input content cannot be empty！`
  String get input_content_cannot_be_empty {
    return Intl.message(
      'The input content cannot be empty！',
      name: 'input_content_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `NO DATA`
  String get no_data {
    return Intl.message(
      'NO DATA',
      name: 'no_data',
      desc: '',
      args: [],
    );
  }

  /// `Server processing`
  String get server_processing {
    return Intl.message(
      'Server processing',
      name: 'server_processing',
      desc: '',
      args: [],
    );
  }

  /// `The server is busy, please try again later`
  String get server_error {
    return Intl.message(
      'The server is busy, please try again later',
      name: 'server_error',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
