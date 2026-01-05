class OnboardingContents {
  final String title;
  final String image;
  // final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    // required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Trip with Your soul and get the best result",
    image: "assets/images/on1.jpg",
    //image: "assets/images/image1.png",
    //desc: "Remember to keep track of your professional accomplishments.",
  ),
  OnboardingContents(
    title: "Track and enjoy your trip",
    image: "assets/images/on2.jpg",
    // desc:
    //  "But understanding the contributions our colleagues make to our teams and companies.",
  ),
  OnboardingContents(
    title: "Explore the hidden places that you don't know",
    image: "assets/images/on3.jpg",

  ),
];
