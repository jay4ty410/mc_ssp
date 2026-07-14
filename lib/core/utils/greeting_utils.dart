/// Utility to generate time-based greetings.
class GreetingUtils {
  GreetingUtils._();

  /// Returns one of: 'Morning', 'Afternoon', 'Evening' based on local time.
  static String getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return 'Morning';
    }
    if (hour >= 12 && hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }
}
