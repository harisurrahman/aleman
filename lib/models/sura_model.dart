class Sura {
  final int serial;
  final int sura;
  final int aya;
  final String quranText;
  final String banglaMohiuddin;
  final String banglaMurtaza;
  final String englishText;
  final String banglaTranslit;
  final String englishTranslit;
  final bool active;
  

  Sura({this.serial, this.sura, this.aya, this.quranText, this.banglaMurtaza, this.banglaMohiuddin, this.englishText, this.banglaTranslit, this.englishTranslit, this.active});

  factory Sura.fromJson(Map<String, dynamic> json){

    return Sura(
      serial: json['serial'],
      sura: json['sura'],
      aya: json['aya'],
      quranText: json['quran_text'],
      banglaMohiuddin: json['bangla_mohiuddin'],
      banglaMurtaza: json['bangla_murtaza'],
      englishText: json['english_text'],
      banglaTranslit: json['bangla_translit'],
      englishTranslit: json['english_translit'],
      active:false
    );
  }
}


