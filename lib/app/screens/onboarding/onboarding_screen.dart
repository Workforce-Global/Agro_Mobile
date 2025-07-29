import 'package:agro_sav/services/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final pages = [
    _OnboardPage(
      img: "assets/images/on_1.jpeg",
      title: "Grow Better Tomatoes",
      subtitle: "Learn best practices and detect diseases early.",
    ),
    _OnboardPage(
      img: "assets/images/on_2.jpeg",
      title: "Nurture Your Grains",
      subtitle: "Keep your rice and cereals healthy all season.",
    ),
    _OnboardPage(
      img: "assets/images/on_3.jpeg",
      title: "Harvest With Confidence",
      subtitle: "Join thousands of farmers boosting yields.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => currentIndex = i),
                itemBuilder: (_, i) => pages[i],
              ),
            ),
            _buildDots(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (currentIndex == pages.length - 1) {
                    await PermissionService.requestAllPermissions();
                    Get.offAllNamed('/signup'); // or '/login'
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Text(currentIndex == pages.length - 1
                    ? "Get Started"
                    : "Next"),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pages.length,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentIndex == i ? 24 : 8,
          decoration: BoxDecoration(
            color: currentIndex == i ? Colors.green : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final String img, title, subtitle;
  const _OnboardPage({
    required this.img,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(img, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          const SizedBox(height: 24),
          Text(title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
