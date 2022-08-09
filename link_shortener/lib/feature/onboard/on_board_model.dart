class OnBoardModel {
  final String title;
  final String description;
  final String imageName;

  OnBoardModel(this.title, this.description, this.imageName);

  String get imageWithPath => 'images/$imageName.png';
}

class OnBoardModels {
  static final List<OnBoardModel> onBoardItems = [
    OnBoardModel('Fast Shortener', 'Shorten the link quickly and easily.',
        'ic_linkspeed'),
    OnBoardModel('Copy & Go Link', 'Copy the link if you want, go to the link if you want.',
        'ic_link'),
 
  ];
}
