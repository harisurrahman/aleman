class SuraList {
  final int sid;
  final String originalName;
  final String englishName;
  final String banglaName;
  final String englishTranslated;
  final String banglaTranslated;
  final String revelationType;
  final int numberOfAyets;

  SuraList({
    this.sid,
    this.originalName,
    this.englishName,
    this.banglaName,
    this.englishTranslated,
    this.banglaTranslated,
    this.revelationType,
    this.numberOfAyets,
  });

  factory SuraList.fromJson(Map<String, dynamic> json) {
    return SuraList(
      sid: json['sid'],
      originalName: json['originalName'],
      englishName: json['englishName'],
      banglaName: json['banglaName'],
      englishTranslated: json['englishTranslated'],
      banglaTranslated: json['banglaTranslated'],
      revelationType: json['revelationType'],
      numberOfAyets: json['numberOfAyets'],
    );
  }
}
