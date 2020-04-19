class SuraList {
  final String number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String numberOfAyahs;
  final String revelationType;
  final String banglaName;
  final int englishNumber;
  final String numberBanglaAyahs;
  final String numberEnglishAyahs;

  SuraList({this.number, this.name, this.englishName, this.englishNameTranslation,
      this.numberOfAyahs, this.revelationType, this.banglaName,  this.englishNumber,
      this.numberBanglaAyahs, this.numberEnglishAyahs});

  factory SuraList.fromJson(Map<String, dynamic> json){

    return SuraList(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      numberOfAyahs: json['numberOfAyahs'],
      revelationType: json['revelationType'],
      banglaName: json['banglaName'],
      englishNumber: json['englishNumber'],
      numberBanglaAyahs: json['numberBanglaAyahs'],
      numberEnglishAyahs: json['numberEnglishAyahs']

    );
  }
}


