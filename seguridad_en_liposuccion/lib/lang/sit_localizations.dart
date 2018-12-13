import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seguridad_en_liposuccion/l10n/messages_all.dart';

class SitLocalizations {
  /// Initialize localization systems and messages
  static Future<SitLocalizations> load(Locale locale) async {
    // If we're given "en_US", we'll use it as-is. If we're
    // given "en", we extract it and use it.
    final String localeName =
        locale.countryCode == null || locale.countryCode.isEmpty
            ? locale.languageCode
            : locale.toString();

    // We make sure the locale name is in the right format e.g.
    // converting "en-US" to "en_US".
    final String canonicalLocaleName = Intl.canonicalizedLocale(localeName);

    // Load localized messages for the current locale.
    await initializeMessages(canonicalLocaleName);
    // We'll uncomment the above line after we've built our messages file

    // Force the locale in Intl.
    Intl.defaultLocale = canonicalLocaleName;

    return SitLocalizations();
  }

  /// Retrieve localization resources for the widget tree
  /// corresponding to the given `context`
  static SitLocalizations of(BuildContext context) =>
      Localizations.of<SitLocalizations>(context, SitLocalizations);

  String get title => Intl.message(
        'Safety In Liposuction',
        name: 'title',
      );

  String get weightHint => Intl.message(
        'Enter your weight',
        name: 'weightHint',
      );

  String get volumeLabel => Intl.message(
        'Circulating Volume',
        name: 'volumeLabel',
      );

  String get selectGenderLabel => Intl.message(
        'Gender',
        name: 'selectGenderLabel',
      );

  String get maleGender => Intl.message(
        'Male 75 mL/Kg',
        name: 'maleGender',
      );

  String get femaleGender => Intl.message(
        'Female 65 mL/Kg',
        name: 'femaleGender',
      );

  String get minimumHemoglobin => Intl.message(
        'Minimum Hemoglobin',
        name: 'minimumHemoglobin',
      );

  String get initialHemoglobin => Intl.message(
        'Initial Hemoglobin',
        name: 'initialHemoglobin',
      );

  String get ppsLabel => Intl.message(
        'Permissible Blood Loss',
        name: 'ppsLabel',
      );

  String get ageHint => Intl.message(
        'Enter your age',
        name: 'ageHint',
      );

  String get ageUnit => Intl.message(
        'Years',
        name: 'ageUnit',
      );

  String get ppgButtonLabel => Intl.message(
        'Calculate Permissible Fat Loss',
        name: 'ppgButtonLabel',
      );

  String get pflMessage => Intl.message(
        'The Permissible Fat Loss is',
        name: 'pflMessage',
      );

  String get disclaimerText1 => Intl.message(
        'This predictive formula ',
        name: 'disclaimerText1',
      );

  String get disclaimerText2 => Intl.message(
        ' is made for the exclusive use of plastic surgeons. The plastic surgeon can have with this application an approximation of how much fat can be sucked in a super-wet type liposuction, avoiding the possibility of carrying out a blood transfusion or the presentation of a greater complication.',
        name: 'disclaimerText2',
      );

  String get ppgTitle => Intl.message(
        'Permissible Fat Loss',
        name: 'ppgTitle',
      );

  String get ppgTabTitle => Intl.message(
        'PFL',
        name: 'ppgTabTitle',
      );

  String get rohrichScreenTitle => Intl.message(
        'Rohrich Formula',
        name: 'rohrichScreenTitle',
      );

  String get rohrichTabTitle => Intl.message(
        'Rohrich',
        name: 'rohrichTabTitle',
      );

  String get aspiradoTotalHint => Intl.message(
        'Total Aspirate',
        name: 'aspiradoTotalHint',
      );

  String get infiltratedLiquidHint => Intl.message(
        'Liquid infiltrated by the surgeon',
        name: 'infiltratedLiquidHint',
      );

  String get intravenousFluidHint => Intl.message(
        'Endovenous liquid',
        name: 'intravenousFluidHint',
      );

  String get rohrichButtonLabel => Intl.message(
        'Get Result',
        name: 'rohrichButtonLabel',
      );

  String get correctBalance => Intl.message(
        'Correct Hydric Balance',
        name: 'correctBalance',
      );

  String get superMessage => Intl.message(
        'Overhydrated in %s cc',
        name: 'superMessage',
      );

  String get deficitMessage => Intl.message(
        'Volume deficit in %s cc',
        name: 'deficitMessage',
      );

  String get rohrichDisclaimerText => Intl.message(
        'This formula is used to evaluate the hydric balance of patients who undergo Super Wet type liposuction. formula:\nTo an AT < 5000 ml applies -> (AT x 1.8 = LI + LE)\nFor an AT > 5001ml applies -> (AT x 1.2 = LI + LE)\nWhere: AT = total aspirate LI = infiltrated liquid LE = intravenous fluid\nRohrich RJ, Jason E, Leedy, Swamy JR. Fluid resuscitation in liposuction: a retrospective review of 89 consecutive patients. Plast Reconstr Surg. 2006; 117: 431-6',
        name: 'rohrichDisclaimerText',
      );

  String get bibliographyTitle => Intl.message(
        'Bibliography',
        name: 'bibliographyTitle',
      );

  String get bibliographyTabTitle => Intl.message(
        'Bibliography',
        name: 'bibliographyTabTitle',
      );

  String get researchWorkLabel => Intl.message(
        'Research work ',
        name: 'researchWorkLabel',
      );

  String get aboutUsTitle => Intl.message(
        'Who are we?',
        name: 'aboutUsTitle',
      );

  String get aboutUsTabTitle => Intl.message(
        'About Us',
        name: 'aboutUsTabTitle',
      );

  String get raulName => Intl.message(
        'Dr. Raúl Manzaneda Cipriani',
        name: 'raulName',
      );

  String get biography1 => Intl.message(
        "Plastic and Reconstructive Surgeon\nCMP : 51022\nRNE : 26404\nwww.drmanzanedacipriani.com.pe\nnrmanzanedacipriani@hotmail.com",
        name: 'biography1',
      );

  String get fiorellaName => Intl.message(
        'Dra. Fiorella Cano Guerra',
        name: 'fiorellaName',
      );

  String get biography3 => Intl.message(
        'Plastic and Reconstructive Surgeon\nCMP : 60040\nRNE : 33339\nfiorelladcanoguerra@gmail.com',
        name: 'biography3',
      );

  String get welcomeText => Intl.message(
        'Note: This application comes from a study conducted with the aim of having available an individualized and simple way of estimating how much fat we could extract without increasing the risk of complications or the need for blood transfusions; using a predictive model; adapted for a free computer application called Safety in Liposuction/Allowable Fat Loss, for use in computers, cell phones and tablets.',
        name: 'welcomeText',
      );

  String get disclaimerButtonLabel => Intl.message(
        'Accept',
        name: 'disclaimerButtonLabel',
      );

  String get appNameLogo1 => Intl.message(
        'SAFETY IN ',
        name: 'appNameLogo1',
      );

  String get appNameLogo2 => Intl.message(
        'LIPOSUCTION',
        name: 'appNameLogo2',
      );

  String get appSubtitleLogo => Intl.message(
        'PERMISSIBLE LOSS OF FAT',
        name: 'appSubtitleLogo',
      );

  String get done => Intl.message(
        'Done',
        name: 'done',
      );
}
