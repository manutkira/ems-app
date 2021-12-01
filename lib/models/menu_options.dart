class MenuOptions {
  String value;
  String label;
  MenuOptions({required this.value, required this.label});

  static get view => "View";
  static get edit => "Edit";
  static get delete => "Delete";
}
