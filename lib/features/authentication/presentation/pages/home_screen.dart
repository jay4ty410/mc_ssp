import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF246BFD),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.schedule,
                          size: 30,
                          color: Color(0xFF246BFD),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MC-SS",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            "Smart Scheduler",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Stack(
                          children: [
                            const Icon(Icons.notifications_none),
                            Positioned(
                              right: 0,
                              child: Container(
                                height: 18,
                                width: 18,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF246BFD),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    "3",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_outline),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// GREETING
              const Text(
                "Good morning, Alex 👋",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              const Text(
                "Here's your schedule overview",
                style: TextStyle(color: Colors.grey, fontSize: 17),
              ),

              const SizedBox(height: 25),

              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xFF246BFD),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Today",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// STATS
              Container(
                padding: const EdgeInsets.symmetric(vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatCard(
                      icon: Icons.calendar_today,
                      color: Color(0xFF5B8CFF),
                      title: "Today's Events",
                      value: "5",
                      subtitle: "Upcoming",
                    ),
                    StatCard(
                      icon: Icons.check_circle,
                      color: Color(0xFF65D89A),
                      title: "Completed",
                      value: "2",
                      subtitle: "Tasks",
                    ),
                    StatCard(
                      icon: Icons.access_time,
                      color: Color(0xFFF5C04E),
                      title: "Pending",
                      value: "3",
                      subtitle: "Tasks",
                    ),
                    StatCard(
                      icon: Icons.flag,
                      color: Color(0xFF8B5CF6),
                      title: "Overdue",
                      value: "1",
                      subtitle: "Task",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// TODAY SCHEDULE
              _sectionHeader("Today's Schedule", "View All"),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Column(
                  children: [
                    ScheduleTile(
                      time: "09:00 AM",
                      title: "Team Stand-up",
                      category: "Work",
                      location: "Conference Room",
                      duration: "30m",
                      icon: Icons.work_outline,
                      color: Color(0xFF5B8CFF),
                    ),
                    ScheduleTile(
                      time: "10:30 AM",
                      title: "Project Planning",
                      category: "Work",
                      location: "Conference Room",
                      duration: "1h",
                      icon: Icons.book_outlined,
                      color: Color(0xFF65D89A),
                    ),
                    ScheduleTile(
                      time: "01:00 PM",
                      title: "Lunch Break",
                      category: "Personal",
                      location: "-",
                      duration: "1h",
                      icon: Icons.restaurant,
                      color: Color(0xFFF5C04E),
                    ),
                    ScheduleTile(
                      time: "02:00 PM",
                      title: "Code Review",
                      category: "Work",
                      location: "Online Meeting",
                      duration: "45m",
                      icon: Icons.code,
                      color: Color(0xFF8B5CF6),
                    ),
                    ScheduleTile(
                      time: "04:00 PM",
                      title: "Gym Session",
                      category: "Personal",
                      location: "FitLife Gym",
                      duration: "1h",
                      icon: Icons.fitness_center,
                      color: Color(0xFF246BFD),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              _sectionHeader("Quick Actions", "Customize"),

              const SizedBox(height: 15),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QuickActionCard(
                    icon: Icons.add_box_outlined,
                    title: "Add\nEvent",
                  ),
                  QuickActionCard(icon: Icons.task_alt, title: "Add\nTask"),
                  QuickActionCard(
                    icon: Icons.calendar_month,
                    title: "Calendar\nView",
                  ),
                  QuickActionCard(icon: Icons.bar_chart, title: "Analytics"),
                  QuickActionCard(
                    icon: Icons.auto_awesome,
                    title: "AI\nSuggestions",
                  ),
                ],
              ),

              const SizedBox(height: 25),

              _sectionHeader("AI Suggestions", "See All"),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Color(0xFFEAF2FF),
                      child: Icon(
                        Icons.smart_toy_outlined,
                        color: Color(0xFF246BFD),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You have a free gap at 11:45 AM",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Would you like to schedule a focus session?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text("Schedule"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          action,
          style: const TextStyle(
            color: Color(0xFF246BFD),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final String subtitle;

  const StatCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: .15),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(title, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text(subtitle),
      ],
    );
  }
}

class ScheduleTile extends StatelessWidget {
  final String time;
  final String title;
  final String category;
  final String location;
  final String duration;
  final IconData icon;
  final Color color;

  const ScheduleTile({
    super.key,
    required this.time,
    required this.title,
    required this.category,
    required this.location,
    required this.duration,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              time,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
          CircleAvatar(
            backgroundColor: color.withValues(alpha: .15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Text(category, style: TextStyle(color: color)),
                Text(location, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Chip(label: Text(duration)),
        ],
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const QuickActionCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Color(0xFF246BFD)),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
