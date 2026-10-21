import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Lab9App());
}

// ==================== MODEL ====================
class Student {
  final int id;
  final String name;
  final String email;
  final String major;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      major: json['major'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'major': major,
    };
  }

  Student copyWith({int? id, String? name, String? email, String? major}) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      major: major ?? this.major,
    );
  }
}

// ==================== STORAGE SERVICE ====================
class JsonStorageService {
  final String fileName;
  JsonStorageService({required this.fileName});

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  Future<List<Student>> readStudents() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      if (contents.trim().isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => Student.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<File> writeStudents(List<Student> students) async {
    final file = await _localFile;
    final List<Map<String, dynamic>> jsonList =
    students.map((s) => s.toJson()).toList();
    return file.writeAsString(jsonEncode(jsonList));
  }
}

// ==================== APP ROOT ====================
class Lab9App extends StatelessWidget {
  const Lab9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - JSON Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    Lab91Screen(),
    Lab92Screen(),
    Lab93Screen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'Lab 9.1 Asset',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Lab 9.2 Storage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dataset),
            label: 'Lab 9.3 CRUD',
          ),
        ],
      ),
    );
  }
}

// ==================== LAB 9.1 SCREEN ====================
class Lab91Screen extends StatefulWidget {
  const Lab91Screen({super.key});

  @override
  State<Lab91Screen> createState() => _Lab91ScreenState();
}

class _Lab91ScreenState extends State<Lab91Screen> {
  List<Student> _assetStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssetJson();
  }

  Future<void> _loadAssetJson() async {
    setState(() => _isLoading = true);
    try {
      final String response =
      await rootBundle.loadString('assets/data/students_asset.json');
      final List<dynamic> data = jsonDecode(response);
      setState(() {
        _assetStudents = data.map((json) => Student.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9.1: Read Assets JSON')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadAssetJson,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _assetStudents.length,
          itemBuilder: (context, index) {
            final item = _assetStudents[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: CircleAvatar(child: Text('${item.id}')),
                title: Text(item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Email: ${item.email}\nMajor: ${item.major}'),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==================== LAB 9.2 SCREEN ====================
class Lab92Screen extends StatefulWidget {
  const Lab92Screen({super.key});

  @override
  State<Lab92Screen> createState() => _Lab92ScreenState();
}

class _Lab92ScreenState extends State<Lab92Screen> {
  final JsonStorageService _storageService =
  JsonStorageService(fileName: 'students_lab9_2.json');
  List<Student> _students = [];
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _majorController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _storageService.readStudents();
    setState(() {
      _students = data;
      _isLoading = false;
    });
  }

  void _addItem() {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) return;

    final newId = _students.isEmpty
        ? 1
        : _students.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

    setState(() {
      _students.add(Student(
        id: newId,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        major: _majorController.text.trim().isEmpty
            ? 'Software Engineering'
            : _majorController.text.trim(),
      ));
      _nameController.clear();
      _emailController.clear();
      _majorController.clear();
    });
  }

  Future<void> _saveData() async {
    await _storageService.writeStudents(_students);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Saved to Device Storage successfully!'),
            backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9.2: Local Storage Save & Load')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                        controller: _nameController,
                        decoration:
                        const InputDecoration(labelText: 'Name')),
                    TextField(
                        controller: _emailController,
                        decoration:
                        const InputDecoration(labelText: 'Email')),
                    TextField(
                        controller: _majorController,
                        decoration:
                        const InputDecoration(labelText: 'Major')),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: _addItem,
                                child: const Text('Add'))),
                        const SizedBox(width: 8),
                        Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white),
                              onPressed: _saveData,
                              child: const Text('Save JSON'),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final item = _students[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${item.id}')),
                      title: Text(item.name),
                      subtitle: Text('Email: ${item.email}\nMajor: ${item.major}'),
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

// ==================== LAB 9.3 SCREEN ====================
class Lab93Screen extends StatefulWidget {
  const Lab93Screen({super.key});

  @override
  State<Lab93Screen> createState() => _Lab93ScreenState();
}

class _Lab93ScreenState extends State<Lab93Screen> {
  final JsonStorageService _storageService =
  JsonStorageService(fileName: 'students_crud.json');
  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndInitData();
  }

  Future<void> _loadAndInitData() async {
    setState(() => _isLoading = true);
    List<Student> loaded = await _storageService.readStudents();
    if (loaded.isEmpty) {
      loaded = [
        Student(id: 101, name: 'Phạm Minh Đức', email: 'ducpm@fpt.edu.vn', major: 'SE'),
        Student(id: 102, name: 'Nguyễn Thanh Hà', email: 'hant@fpt.edu.vn', major: 'AI'),
      ];
      await _storageService.writeStudents(loaded);
    }
    setState(() {
      _allStudents = loaded;
      _filteredStudents = loaded;
      _isLoading = false;
    });
  }

  Future<void> _autoSave() async {
    await _storageService.writeStudents(_allStudents);
    _filterStudents(_searchController.text);
  }

  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = List.from(_allStudents);
      } else {
        _filteredStudents = _allStudents
            .where((s) =>
        s.name.toLowerCase().contains(query.toLowerCase()) ||
            s.email.toLowerCase().contains(query.toLowerCase()) ||
            s.major.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showStudentDialog({Student? student}) {
    final nameCtrl = TextEditingController(text: student?.name ?? '');
    final emailCtrl = TextEditingController(text: student?.email ?? '');
    final majorCtrl = TextEditingController(text: student?.major ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(student == null ? 'Add Student' : 'Edit Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: majorCtrl, decoration: const InputDecoration(labelText: 'Major')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              if (student == null) {
                final newId = _allStudents.isEmpty
                    ? 1
                    : _allStudents.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
                _allStudents.add(Student(
                  id: newId,
                  name: nameCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  major: majorCtrl.text.trim(),
                ));
              } else {
                final index = _allStudents.indexWhere((s) => s.id == student.id);
                if (index != -1) {
                  _allStudents[index] = student.copyWith(
                    name: nameCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    major: majorCtrl.text.trim(),
                  );
                }
              }
              await _autoSave();
              if (mounted) Navigator.pop(context);
            },
            child: Text(student == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete "${student.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              setState(() => _allStudents.removeWhere((s) => s.id == student.id));
              await _autoSave();
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9.3: Local JSON CRUD')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterStudents,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final item = _filteredStudents[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${item.id}')),
                    title: Text(item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Email: ${item.email}\nMajor: ${item.major}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showStudentDialog(student: item)),
                        IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(item)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStudentDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}