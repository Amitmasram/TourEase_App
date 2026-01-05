import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
  'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0a/a9/92/cd/clean-and-variety-of.jpg?w=1200&h=1200&s=1',
  'https://i.ytimg.com/vi/tm9DDKJNWv8/maxresdefault.jpg',
  'https://tse3.mm.bing.net/th?id=OIP.LYGXRGcw-izrgysQFwUKBAHaEK&pid=Api&P=0&h=180',
  'https://i.ytimg.com/vi/ETr88LxKtoY/maxresdefault.jpg',
  'https://tse3.mm.bing.net/th?id=OIP.ARzoUo7RSHfRdT4ARt8D8AHaE8&pid=Api&P=0&h=180',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];
final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          'No. ${imgList.indexOf(item)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

class CarouselChangeReasonDemo extends StatefulWidget {
  const CarouselChangeReasonDemo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CarouselChangeReasonDemoState();
  }
}

class _CarouselChangeReasonDemoState extends State<CarouselChangeReasonDemo> {
  String reason = '';
  final carousel_slider.CarouselController _controller = carousel_slider.CarouselController();

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      reason = changeReason.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: const Text('Change reason demo')),
        body: Column(
      children: <Widget>[
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            onPageChanged: onPageChange,
            autoPlay: true,
          ),
          carouselController: _controller,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: <Widget>[
        //     Flexible(
        //       child: ElevatedButton(
        //         onPressed: () => _controller.previousPage(),
        //         child: const Text('←'),
        //       ),
        //     ),
        //     Flexible(
        //       child: ElevatedButton(
        //         onPressed: () => _controller.nextPage(),
        //         child: const Text('→'),
        //       ),
        //     ),
        //     ...Iterable<int>.generate(imgList.length).map(
        //       (int pageIndex) => Flexible(
        //         child: ElevatedButton(
        //           onPressed: () => _controller.animateToPage(pageIndex),
        //           child: Text("$pageIndex"),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Center(
        //   child: Column(
        //     children: [
        //       const Text('page change reason: '),
        //       Text(reason),
        //     ],
        //   ),
        // )
      ],
    ));
  }
}
