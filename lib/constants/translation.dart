
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:i18n_extension/i18n_extension.dart';
extension Localization on String {

  static final _t = Translations("pt_br") +
      {
        "pt_br": "Português",
        "en_us": "Portuguese",
        "es": "Portugués",
        "fr": "Portugais",
      } +
      {
        "pt_br": "Ingles",
        "en_us": "English",
        "es": "Inglés",
        "fr": "Anglais",
      } +
      {
        "pt_br": "Espanhol",
        "en_us": "Spanish",
        "es": "Español",
        "fr": "Espagnol",
      } +
      {
        "pt_br": "Frances",
        "en_us": "French",
        "es": "Francés",
        "fr": "Francais",
      } +
      {
        "en_us": "Change Language",
        "pt_br": "Mude Idioma",
      } +
      {
        "pt_br": "Termos e Condições",
        "en_us": "Terms and conditions",
        "es": "Términos y condiciones",
        "fr": "Termes et conditions",
      } +
      {
        "en_us": "You clicked the button %d times:"
            .zero("You haven't clicked the button:")
            .one("You clicked it once:")
            .two("You clicked a couple times:")
            .many("You clicked %d times:")
            .times(12, "You clicked a dozen times:"),
        "pt_br": "Você clicou o botão %d vezes:"
            .zero("Você não clicou no botão:")
            .one("Você clicou uma única vez:")
            .two("Você clicou um par de vezes:")
            .many("Você clicou %d vezes:")
            .times(12, "Você clicou uma dúzia de vezes:"),
      };

  String get i18n => localize(this, _t);

  String fill(List<Object> params) => localizeFill(this, params);

  String plural(int value) => localizePlural(value, this, _t);

  String version(Object modifier) => localizeVersion(modifier, this, _t);

  Map<String?, String> allVersions() => localizeAllVersions(this, _t);
}



