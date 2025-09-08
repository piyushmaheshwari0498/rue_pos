class SalesOverview {
  String title;

  String data = "";

  String img = "";

  SalesOverview({required this.title, required this.data, required this.img});

  SalesOverview copywith({
    required String title,
    required String data,
    required String img,
  }) {
    return SalesOverview(title: this.title, data: this.data, img: this.img);
  }

  @override
  String toString() {
    return 'SalesOverview(title: $title,data: $data,  img: $img)';
  }




}
