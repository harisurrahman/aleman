class Sura {
  final int serial;
  final int sura;
  final int aya;
  final String quranText;
  final String banglaText;
  final String englishText;
  final String banglaTranslit;
  final String englishTranslit;
  final bool active;
  

  Sura({this.serial, this.sura, this.aya, this.quranText, this.banglaText, this.englishText, this.banglaTranslit, this.englishTranslit, this.active});

  factory Sura.fromJson(Map<String, dynamic> json){

    return Sura(
      serial: json['serial'],
      sura: json['sura'],
      aya: json['aya'],
      quranText: json['quran_text'],
      banglaText: json['bangla_text'],
      englishText: json['english_text'],
      banglaTranslit: json['bangla_translit'],
      englishTranslit: json['english_translit'],
      active:false
    );
  }
}


