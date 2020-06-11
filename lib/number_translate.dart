
extension LanguageStringExtensions on String{
    String withBanglaNumbers() {
    if (this == null || this.isEmpty) {
      return this;
    }

    var x = this;
    x = x.replaceAll('0', '\u09E6');
    x = x.replaceAll('1', '\u09E7');
    x = x.replaceAll('2', '\u09E8');
    x = x.replaceAll('3', '\u09E9');
    x = x.replaceAll('4', '\u09EA');
    x = x.replaceAll('5', '\u09EB');
    x = x.replaceAll('6', '\u09EC');
    x = x.replaceAll('7', '\u09ED');
    x = x.replaceAll('8', '\u09EE');
    x = x.replaceAll('9', '\u09EF');
    return x;
  }
}