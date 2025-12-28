import 'package:flutter/material.dart';
import 'package:foodify/screens/dashboard /dashboard_controller.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colours.dart';

class RestaurantHomeScreen extends StatelessWidget {
  const RestaurantHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final  DashboardController controller = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              controller.logout();
            },
            icon: const Icon(Icons.logout,color: Colors.white,),

          )
        ],
        title: Column(
          children: [
            Text(
              "FOODIFY",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              "Book your table instantly",
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.restaurants.isEmpty) {
          return const Center(child: Text("No restaurants available"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Text(
                    "Select Restaurant",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColours.kPrimaryPurple,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColours.kPrimaryPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.restaurants.length,
                itemBuilder: (_, i) {
                  final r = controller.restaurants[i];

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                            color: Colors.black.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // image box (improved)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 90,
                                width: 90,
                                color: Colors.white,
                                child: r.imageUrl.isNotEmpty
                                    ? Image.network(
                                        r.imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "lib/core/assets/rest.jpg",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    r.location,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 18,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text("${r.rating}"),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColours.kPrimaryPurple,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.toNamed('/booking',arguments: r );
                                        },
                                        child: const Text(
                                          "Book Table",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
