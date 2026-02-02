import 'package:flutter/material.dart';
import 'onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingModel> onboardingData = [
    OnboardingModel(
      title: "Discover the world.",
      description: "Experience a harmonious connection by syncing your routine with nature’s rhythm.",
      image: "assets/images/onboarding1.png", // Ensure these exist in pubspec.yaml
    ),
    OnboardingModel(
      title: "Seamless Syncing.",
      description: "Automatic and effortless syncing that adapts seamlessly to your lifestyle.",
      image: "assets/images/onboarding2.png",
    ),
    OnboardingModel(
      title: "Find Your Calm.",
      description: "Let go of stress and unwind as we guide you towards calmness.",
      image: "assets/images/onboarding3.png",
    ),
  ];

  void _goNext() {
    if (_currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to Welcome Screen after onboarding
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A194E), Color(0xFF000000)],
          ),
        ),
        child: PageView.builder(
          controller: _pageController,
          itemCount: onboardingData.length,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemBuilder: (context, index) {
            final item = onboardingData[index];
            final imageHeight = MediaQuery.of(context).size.height * 0.5;

            return Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                  child: Container(
                    height: imageHeight,
                    width: double.infinity,
                    color: Colors.grey[900], // Background if image fails
                    child: Image.asset(
                      item.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 50),
                    ),
                  ),
                ),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/welcome'),
                      child: const Text("Skip", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                Positioned(
                  top: imageHeight + 40,
                  left: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 16),
                      Text(item.description, style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7))),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 120,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onboardingData.length, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == i ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentIndex == i ? const Color(0xFF5D00FF) : Colors.white24,
                      ),
                    )),
                  ),
                ),
                Positioned(
                  bottom: 32,
                  left: 24,
                  right: 24,
                  child: ElevatedButton(
                    onPressed: _goNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D00FF),
                      minimumSize: const Size(double.infinity, 54),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(_currentIndex == onboardingData.length - 1 ? "Get Started" : "Next", style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}