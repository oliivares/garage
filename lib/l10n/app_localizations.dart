import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];
  String get account;

  String get personalData;

  String get logout;

  String get language;

  String get spanish;

  String get english;

  String get vehiclesTitle;

  String get vehiclesLoadError;

  String get vehiclesEmpty;

  String get vehiclesAdd;

  String get vehicleAddedSuccessfully;

  String get saveVehicle;

  String get selectAnyo;

  String get year;

  String get enterTheMotor;

  String get selectThePower;

  String get enterTheBrand;

  String get enterTheTuition;

  String get motor;

  String get power;

  String get brand;

  String get licensePlate;

  String get vehicleUpdated;

  String get errorEditing;

  String get editVehicle;

  String get confirmEdition;

  String get fieldRequired;

  String get vehicleDetails;

  String get edits;

  String get userName;

  String get password;

  String get confirmPassword;

  String get createAccount;

  String get startSession;

  String get fullName;

  String get email;

  String get phone;

  String get lightMode;

  String get darkMode;

  String get location;

  String get registry;

  String get home;

  String get vehicles;

  String get notifications;

  String get user;

  String get selecteddate;

  String get none;

  String get selectdate;

  String get searchplace;

  String get address;

  String get call;

  String get close;

  String get delete;

  String get vehicle;

  String get deleteVehicle;

  String get deleteConfirmation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
