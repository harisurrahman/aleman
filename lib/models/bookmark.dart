class Bookmark{
  final String lang;
  final int sid;
  final int aid;
  final int ttlAyas;

  Bookmark(this.lang, this.sid, this.aid, this.ttlAyas);

  factory Bookmark.fromJson(Map<String, dynamic> json){
    return Bookmark(
      json['lang'],
      json['sid'],
      json['aid'],
      json['ttlAyas']
      
    );

  }
}