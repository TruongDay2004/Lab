import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Ứng dụng chính cấu hình Theme và Dark Mode
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - Flutter UI Fundamentals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
      ),
    );
  }
}

// Màn hình chính chứa danh sách các Exercise (Mẫu như hình 1)
class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({super.key, required this.isDarkMode, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 – Flutter UI Fundamentals'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuCard(context, 'Exercise 1 – Core Widgets Demo', const CoreWidgetsDemo()),
          const SizedBox(height: 12),
          _buildMenuCard(context, 'Exercise 2 – Input Controls Demo', const InputControlsDemo()),
          const SizedBox(height: 12),
          _buildMenuCard(context, 'Exercise 3 – Layout Demo', const LayoutDemo()),
          const SizedBox(height: 12),
          _buildMenuCard(context, 'Exercise 4 – App Structure & Theme', AppStructureDemo(isDarkMode: isDarkMode, onThemeChanged: onThemeChanged)),
          const SizedBox(height: 12),
          _buildMenuCard(context, 'Exercise 5 – Common UI Fixes', const CommonUIFixesDemo()),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, Widget destinationScreen) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationScreen),
          );
        },
      ),
    );
  }
}

// ==========================================
// EXERCISE 1 – Core Widgets: Text, Image, Icon, Card, ListTile
// ==========================================
class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 1 – Core Widgets')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Flutter UI',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Icon(
                Icons.movie_creation,
                size: 80,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://picsum.photos/600/300',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const ListTile(
                leading: Icon(Icons.star, color: Colors.grey),
                title: Text('Movie Item', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('This is a sample ListTile inside a Card.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// EXERCISE 2 – Input Widgets: Slider, Switch, RadioListTile, DatePicker
// ==========================================
class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderValue = 50;
  bool _switchValue = false;
  String? _selectedGenre;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 2 – Input Controls')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Rating (Slider)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Slider(
            value: _sliderValue,
            min: 0,
            max: 100,
            divisions: 100,
            label: _sliderValue.round().toString(),
            onChanged: (value) {
              setState(() {
                _sliderValue = value;
              });
            },
          ),
          Text('Current value: ${_sliderValue.round()}'),
          const SizedBox(height: 20),
          const Text('Active (Switch)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('Is movie active?'),
            value: _switchValue,
            onChanged: (value) {
              setState(() {
                _switchValue = value;
              });
            },
          ),
          const SizedBox(height: 10),
          const Text('Genre (RadioListTile)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          RadioListTile<String>(
            title: const Text('Action'),
            value: 'Action',
            groupValue: _selectedGenre,
            onChanged: (value) {
              setState(() {
                _selectedGenre = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Comedy'),
            value: 'Comedy',
            groupValue: _selectedGenre,
            onChanged: (value) {
              setState(() {
                _selectedGenre = value;
              });
            },
          ),
          Text('Selected genre: ${_selectedGenre ?? "None"}'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: const Text('Open Date Picker'),
          ),
          const SizedBox(height: 10),
          if (_selectedDate != null)
            Text('Selected Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
        ],
      ),
    );
  }
}

// ==========================================
// EXERCISE 3 – Layout Basics: Column, Row, Padding, ListView
// ==========================================
class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> movies = [
      {'title': 'Avatar', 'letter': 'A', 'desc': 'Sample description'},
      {'title': 'Inception', 'letter': 'I', 'desc': 'Sample description'},
      {'title': 'Interstellar', 'letter': 'I', 'desc': 'Sample description'},
      {'title': 'Joker', 'letter': 'J', 'desc': 'Sample description'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 3 – Layout Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Now Playing',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(movie['letter']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      title: Text(movie['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(movie['desc']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// EXERCISE 4 – App Structure with Scaffold, AppBar, FAB & Theme
// ==========================================
class AppStructureDemo extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const AppStructureDemo({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 4 – App Structure'),
        actions: [
          Row(
            children: [
              const Text('Dark', style: TextStyle(fontSize: 14)),
              Switch(
                value: isDarkMode,
                onChanged: onThemeChanged,
              ),
            ],
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'This is a simple screen with theme toggle.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floating Action Button Pressed!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ==========================================
// EXERCISE 5 – Debug & Fix Common UI Errors
// ==========================================
class CommonUIFixesDemo extends StatelessWidget {
  const CommonUIFixesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 5 – Common UI Fixes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ListTile(
                    leading: Icon(Icons.movie),
                    title: Text('Movie A'),
                  ),
                  ListTile(
                    leading: Icon(Icons.movie),
                    title: Text('Movie B'),
                  ),
                  ListTile(
                    leading: Icon(Icons.movie),
                    title: Text('Movie C'),
                  ),
                  ListTile(
                    leading: Icon(Icons.movie),
                    title: Text('Movie D'),
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