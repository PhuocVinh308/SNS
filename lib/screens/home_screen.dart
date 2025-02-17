import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: const Color.fromARGB(255, 240, 240, 240),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopSection(height, width),
            const SizedBox(height: 15),
            _buildAvailableCropsText(),
            _buildCropsList(height, width),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(double height, double width) {
    return Container(
      height: height * 0.26,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 174, 255, 178),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.15,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello Farmers",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 61, 61, 61),
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Sunday 12 Jan , 2024",
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 118, 118, 118),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: height * 0.065,
            width: width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 72, 72, 72),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Search Crops",
                        style: GoogleFonts.workSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.mic,
                    color: Color.fromARGB(255, 29, 29, 29),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableCropsText() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        "available crops",
        style: GoogleFonts.poppins(
          color: const Color.fromARGB(255, 71, 71, 71),
          fontWeight: FontWeight.w300,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildCropsList(double height, double width) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 20, top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCropItem(
                height,
                width,
                "Wheat Crops",
                "Conditions of your wheat crops",
                "https://images.unsplash.com/photo-1529677987586-cb08849925dd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8MTN8MjU3NDAxM3x8ZW58MHx8fHx8&w=1000&q=80",
                "Wheat",
              ),
              const SizedBox(height: 15),
              _buildCropItem(
                height,
                width,
                "Rice Crops",
                "Conditions of your rice crops",
                "https://foodtank.com/wp-content/uploads/2017/05/Food-Tank-SRI-Rice.jpg",
                "Rice",
              ),
              const SizedBox(height: 15),
              _buildCropItem(
                height,
                width,
                "Other Crops",
                "Conditions of your other crops",
                "https://media.istockphoto.com/id/1308606393/photo/corn-field-in-agricultural-garden-and-light-shines-sunset.jpg?s=612x612&w=0&k=20&c=N6SJj8zZwZLQMLrDcFa6KtfTxQhhS9n3dpDhDT2hbMo=",
                "Other",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropItem(double height, double width, String title, String subtitle, String imageUrl, String cropType) {
    return InkWell(
      onTap: () {
        // Handle crop item tap
        Get.toNamed('/imageUploadScreen', arguments: cropType);
      },
      child: Container(
        height: height * 0.3,
        width: width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.manrope(
                          color: const Color.fromARGB(255, 0, 127, 4),
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.manrope(
                          color: const Color.fromARGB(255, 49, 49, 49),
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 160, 255, 163),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_right,
                        color: Color.fromARGB(255, 50, 50, 50),
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}