part of bilions_ui;

class ImageSlider extends StatelessWidget {
  final List images;
  final double? ratio;
  const ImageSlider(this.images, {Key? key, this.ratio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: ratio ?? 1.7,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        initialPage: 2,
        autoPlay: false,
      ),
      items: [
        for (var index = 0; index < images.length; index++)
          InkWell(
            onTap: () {
              preview(context, images, index: index);
            },
            child: ImageWidget(
              images[index],
              fit: BoxFit.cover,
              radius: 10,
            ),
          ),
      ],
    );
  }
}
