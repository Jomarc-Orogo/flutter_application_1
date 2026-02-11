import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'exam_template_screen.dart'; // ADD THIS IMPORT

class TeacherHomeScreen extends StatefulWidget {
  final String? username;
  final String? email;
  final String? teacherId;

  const TeacherHomeScreen({
    super.key,
    this.username,
    this.email,
    this.teacherId,
  });

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  // ==================== STATE VARIABLES ====================
  String _selectedSection = 'dashboard';
  String? _selectedSubjectForDetails;
  String? _selectedSubjectInSidebar;
  bool _isDarkMode = false;
  bool _isSubjectsExpanded = false;
  String _selectedSubTab = 'createActivity'; // createActivity, students, grades

  // Sample teacher subjects data
  final List<Map<String, dynamic>> _teacherSubjects = [
    {
      'name': 'Mathematics',
      'code': 'MATH101',
      'color': Colors.blue,
      'icon': Icons.calculate,
      'grading_weight': {
        'activities': 0.50,
        'quizzes': 0.30,
        'exams': 0.20,
      },
      'students': [
        {
          'id': 'S001',
          'name': 'John Doe',
          'email': 'john@example.com',
          'grades': {
            'prelim': 85.5,
            'midterm': 88.0,
            'final': 90.5,
            'overall': 88.0
          }
        },
        {
          'id': 'S002',
          'name': 'Jane Smith',
          'email': 'jane@example.com',
          'grades': {
            'prelim': 92.0,
            'midterm': 89.5,
            'final': 95.0,
            'overall': 92.2
          }
        },
        {
          'id': 'S003',
          'name': 'Mike Johnson',
          'email': 'mike@example.com',
          'grades': {
            'prelim': 78.0,
            'midterm': 82.5,
            'final': 85.0,
            'overall': 81.8
          }
        },
      ],
      'activities': [
        {'name': 'Activity 1 - Algebra Basics', 'date': 'Sep 15, 2023', 'total': 30},
        {'name': 'Activity 2 - Linear Equations', 'date': 'Sep 22, 2023', 'total': 20},
      ],
      'quizzes': [
        {'name': 'Quiz 1 - Algebraic Expressions', 'date': 'Sep 28, 2023', 'total': 50},
      ],
      'exams': [
        {'name': 'Exam 1 - Preliminary Exam', 'date': 'Oct 5, 2023', 'total': 75},
      ],
    },
    {
      'name': 'Science',
      'code': 'SCI201',
      'color': Colors.green,
      'icon': Icons.science,
      'grading_weight': {
        'activities': 0.40,
        'quizzes': 0.30,
        'exams': 0.30,
      },
      'students': [
        {
          'id': 'S004',
          'name': 'Sarah Wilson',
          'email': 'sarah@example.com',
          'grades': {
            'prelim': 88.0,
            'midterm': 90.5,
            'final': 92.0,
            'overall': 90.2
          }
        },
        {
          'id': 'S005',
          'name': 'David Brown',
          'email': 'david@example.com',
          'grades': {
            'prelim': 76.5,
            'midterm': 80.0,
            'final': 85.5,
            'overall': 80.7
          }
        },
      ],
      'activities': [
        {'name': 'Lab Report 1 - Chemistry Basics', 'date': 'Sep 16, 2023', 'total': 30},
        {'name': 'Lab Report 2 - Chemical Reactions', 'date': 'Sep 23, 2023', 'total': 20},
      ],
      'quizzes': [
        {'name': 'Quiz 1 - Periodic Table', 'date': 'Sep 29, 2023', 'total': 50},
      ],
      'exams': [
        {'name': 'Exam 1 - Chemistry Exam', 'date': 'Oct 6, 2023', 'total': 75},
      ],
    },
  ];

  // Form controllers for creating activities
  final TextEditingController _activityNameController = TextEditingController();
  final TextEditingController _activityTotalController = TextEditingController();
  final TextEditingController _quizNameController = TextEditingController();
  final TextEditingController _quizTotalController = TextEditingController();
  final TextEditingController _examNameController = TextEditingController();
  final TextEditingController _examTotalController = TextEditingController();

  // Weight controllers
  final TextEditingController _activitiesWeightController = TextEditingController();
  final TextEditingController _quizzesWeightController = TextEditingController();
  final TextEditingController _examsWeightController = TextEditingController();

  // ==================== EXAM TEMPLATE FUNCTION ====================
  void _openExamTemplate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExamTemplateScreen(
          subjectName: "Mathematics",
          examName: "Midterm Exam",
          timeAllowed: "1 hour 30 minutes",
          totalPoints: "100",
          isTeacherView: true,
        ),
      ),
    );
  }

  // ==================== MAIN BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: _buildAppBar(context),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openExamTemplate,
        icon: const Icon(Icons.quiz),
        label: const Text('Exam Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    );
  }

  // ==================== APP BAR ====================
  AppBar _buildAppBar(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    return AppBar(
      backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.deepPurple,
      elevation: 2,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedSection = 'dashboard';
              _selectedSubjectForDetails = null;
              _selectedSubjectInSidebar = null;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.school,
              color: Colors.deepPurple,
              size: 24,
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          const Text(
            'Examify',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Teacher: ${widget.teacherId ?? '---'}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: _isDarkMode ? Colors.grey[800] : Colors.deepPurple,
            ),
          ),
          onSelected: (value) {
            if (value == 'theme') {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            } else if (value == 'logout') {
              authService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  const Icon(Icons.person_outline, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Profile: ${widget.username ?? 'Teacher'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'theme',
              child: Row(
                children: [
                  Icon(
                    _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 20),
                  SizedBox(width: 10),
                  Text('Settings'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  const Icon(Icons.logout, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Logout',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  // ==================== SIDEBAR ====================
  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: _isDarkMode ? Colors.grey[800] : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome,',
                  style: TextStyle(
                    fontSize: 14,
                    color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                Text(
                  widget.username ?? 'Teacher',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(),
          const SizedBox(height: 10),
          
          _buildNavItem('dashboard', Icons.dashboard, 'Dashboard'),
          _buildSubjectsTree(),
          
          const Spacer(),
          
          // Add Subject Button
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: _showAddSubjectDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add New Subject'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsTree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isSubjectsExpanded = !_isSubjectsExpanded;
              if (_isSubjectsExpanded) {
                _selectedSection = 'subjects';
                _selectedSubjectForDetails = null;
                _selectedSubjectInSidebar = null;
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: _selectedSection == 'subjects' && _selectedSubjectForDetails == null
                  ? (_isDarkMode ? Colors.deepPurple[800] : Colors.deepPurple[100])
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.school,
                  color: _selectedSection == 'subjects' && _selectedSubjectForDetails == null
                      ? Colors.deepPurple
                      : (_isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                  size: 22,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'My Subjects',
                    style: TextStyle(
                      fontWeight: _selectedSection == 'subjects' && _selectedSubjectForDetails == null 
                          ? FontWeight.bold : FontWeight.normal,
                      color: _selectedSection == 'subjects' && _selectedSubjectForDetails == null
                          ? (_isDarkMode ? Colors.white : Colors.deepPurple)
                          : (_isDarkMode ? Colors.grey[400] : Colors.grey[700]),
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  _isSubjectsExpanded ? Icons.expand_less : Icons.expand_more,
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        
        if (_isSubjectsExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 5, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _teacherSubjects.map((subject) {
                return _buildSubjectTreeItem(subject);
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSubjectTreeItem(Map<String, dynamic> subject) {
    final bool isSelected = _selectedSubjectInSidebar == subject['name'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedSection = 'subjects';
              _selectedSubjectForDetails = subject['name'];
              _selectedSubjectInSidebar = subject['name'];
              _selectedSubTab = 'createActivity';
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? (_isDarkMode ? Colors.deepPurple[700] : Colors.deepPurple[50])
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_right,
                  color: _isDarkMode ? Colors.grey[500] : Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 5),
                Icon(
                  subject['icon'],
                  color: subject['color'],
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    subject['name'],
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? (_isDarkMode ? Colors.white : Colors.deepPurple)
                          : (_isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '${(subject['students'] as List).length}',
                  style: TextStyle(
                    color: subject['color'],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  ' students',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        if (isSelected && _selectedSubjectForDetails == subject['name'])
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Create Activity Tab
                _buildSubTabItem('createActivity', Icons.add_circle, 'Create Activity', subject),
                // Students Tab
                _buildSubTabItem('students', Icons.people, 'Students', subject),
                // Grades Tab (Weight Settings)
                _buildSubTabItem('grades', Icons.grade, 'Grading Setup', subject),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSubTabItem(String tab, IconData icon, String title, Map<String, dynamic> subject) {
    final bool isSelected = _selectedSubTab == tab;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSubTab = tab;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (_isDarkMode ? Colors.deepPurple[600] : Colors.deepPurple[100])
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(
              Icons.arrow_right,
              color: _isDarkMode ? Colors.grey[500] : Colors.grey[600],
              size: 14,
            ),
            const SizedBox(width: 5),
            Icon(
              icon,
              color: subject['color'],
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? (_isDarkMode ? Colors.white : Colors.deepPurple)
                    : (_isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String section, IconData icon, String title) {
    final isSelected = _selectedSection == section && _selectedSubjectForDetails == null;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSection = section;
          _selectedSubjectForDetails = null;
          _selectedSubjectInSidebar = null;
          _isSubjectsExpanded = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (_isDarkMode ? Colors.deepPurple[800] : Colors.deepPurple[100])
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.deepPurple
                  : (_isDarkMode ? Colors.grey[400] : Colors.grey[600]),
              size: 22,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? (_isDarkMode ? Colors.white : Colors.deepPurple)
                    : (_isDarkMode ? Colors.grey[400] : Colors.grey[700]),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== MAIN CONTENT ====================
  Widget _buildMainContent() {
    switch (_selectedSection) {
      case 'dashboard':
        return _buildDashboard();
      case 'subjects':
        return _buildSubjectsView();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    final int totalStudents = _teacherSubjects.fold(
      0, (sum, subject) => sum + (subject['students'] as List).length);
    final int totalSubjects = _teacherSubjects.length;
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${widget.username ?? 'Teacher'}!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Teacher Dashboard - Manage your classes and students',
              style: TextStyle(
                fontSize: 16,
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 30),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.5,
              children: [
                _buildOverviewCard(
                  'Total Subjects',
                  '$totalSubjects',
                  Icons.school,
                  Colors.blue,
                ),
                _buildOverviewCard(
                  'Total Students',
                  '$totalStudents',
                  Icons.people,
                  Colors.green,
                ),
                _buildOverviewCard(
                  'Average Class Size',
                  '${(totalStudents / totalSubjects).toStringAsFixed(1)}',
                  Icons.group,
                  Colors.orange,
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            Text(
              'Recent Activities Created',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 15),
            
            ..._getRecentActivities().take(3).map<Widget>((activity) {
              return _buildRecentActivityCard(activity);
            }).toList(),
            
            const SizedBox(height: 30),
            
            Text(
              'Subjects Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 15),
            
            ..._teacherSubjects.map<Widget>((subject) {
              return _buildSubjectPreviewCard(subject);
            }).toList(),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getRecentActivities() {
    List<Map<String, dynamic>> allActivities = [];
    
    for (var subject in _teacherSubjects) {
      for (var activity in subject['activities']) {
        allActivities.add({
          'name': activity['name'],
          'subject': subject['name'],
          'date': activity['date'],
          'type': 'Activity',
          'color': subject['color'],
          'icon': subject['icon'],
        });
      }
      for (var quiz in subject['quizzes']) {
        allActivities.add({
          'name': quiz['name'],
          'subject': subject['name'],
          'date': quiz['date'],
          'type': 'Quiz',
          'color': subject['color'],
          'icon': subject['icon'],
        });
      }
      for (var exam in subject['exams']) {
        allActivities.add({
          'name': exam['name'],
          'subject': subject['name'],
          'date': exam['date'],
          'type': 'Exam',
          'color': subject['color'],
          'icon': subject['icon'],
        });
      }
    }
    
    allActivities.sort((a, b) => b['date'].compareTo(a['date']));
    return allActivities;
  }

  Widget _buildRecentActivityCard(Map<String, dynamic> activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: activity['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                activity['icon'],
                color: activity['color'],
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['subject'],
                    style: TextStyle(
                      color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        activity['type'] == 'Activity' ? Icons.assignment :
                        activity['type'] == 'Quiz' ? Icons.quiz : Icons.assignment_turned_in,
                        size: 14,
                        color: _isDarkMode ? Colors.grey[500] : Colors.grey[600],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${activity['type'].toUpperCase()}',
                        style: TextStyle(
                          color: _isDarkMode ? Colors.grey[500] : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: _isDarkMode ? Colors.grey[500] : Colors.grey[600],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        activity['date'],
                        style: TextStyle(
                          color: _isDarkMode ? Colors.grey[500] : Colors.grey[600],
                          fontSize: 12,
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
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 15),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectPreviewCard(Map<String, dynamic> subject) {
    final int studentCount = (subject['students'] as List).length;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: subject['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(subject['icon'], color: subject['color']),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subject['code'],
                    style: TextStyle(
                      color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$studentCount',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: subject['color'],
                  ),
                ),
                Text(
                  'students',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedSection = 'subjects';
                  _selectedSubjectForDetails = subject['name'];
                  _selectedSubjectInSidebar = subject['name'];
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: subject['color'],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Manage'),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== SUBJECTS VIEW ====================
  Widget _buildSubjectsView() {
    if (_selectedSubjectForDetails != null) {
      final subject = _teacherSubjects.firstWhere(
        (s) => s['name'] == _selectedSubjectForDetails,
        orElse: () => _teacherSubjects[0],
      );
      return _buildSubjectDetailsView(subject);
    }
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Subjects',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Select a subject to manage',
            style: TextStyle(
              color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.5,
              ),
              itemCount: _teacherSubjects.length,
              itemBuilder: (context, index) {
                final subject = _teacherSubjects[index];
                return _buildSubjectCard(subject);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final int studentCount = (subject['students'] as List).length;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedSubjectForDetails = subject['name'];
          _selectedSubjectInSidebar = subject['name'];
          _isSubjectsExpanded = true;
          _selectedSubTab = 'createActivity';
        });
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: subject['color'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(subject['icon'], color: subject['color']),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          subject['code'],
                          style: TextStyle(
                            color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Students',
                        style: TextStyle(
                          color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      Text(
                        '$studentCount enrolled',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Grading Weight',
                        style: TextStyle(
                          color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      Text(
                        'A:${(subject['grading_weight']['activities'] * 100).toInt()}% '
                        'Q:${(subject['grading_weight']['quizzes'] * 100).toInt()}% '
                        'E:${(subject['grading_weight']['exams'] * 100).toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: subject['color'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectDetailsView(Map<String, dynamic> subject) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedSubjectForDetails = null;
                      _selectedSubjectInSidebar = null;
                    });
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: subject['color'].withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(subject['icon'], color: subject['color']),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject['name'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    Text(
                      subject['code'],
                      style: TextStyle(
                        color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: subject['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(subject['students'] as List).length} Students',
                    style: TextStyle(
                      color: subject['color'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Tab Bar for Subject Management
            Row(
              children: [
                _buildSubjectTabButton('Create Activity', 'createActivity', subject['color']),
                const SizedBox(width: 10),
                _buildSubjectTabButton('Students', 'students', subject['color']),
                const SizedBox(width: 10),
                _buildSubjectTabButton('Grading Setup', 'grades', subject['color']),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Tab Content
            if (_selectedSubTab == 'createActivity')
              _buildCreateActivityTab(subject)
            else if (_selectedSubTab == 'students')
              _buildStudentsTab(subject)
            else if (_selectedSubTab == 'grades')
              _buildGradingSetupTab(subject),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectTabButton(String label, String tab, Color color) {
    final bool isSelected = _selectedSubTab == tab;
    
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedSubTab = tab;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : Colors.transparent,
          foregroundColor: isSelected ? Colors.white : color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: color),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateActivityTab(Map<String, dynamic> subject) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create New Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 20),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _activityNameController,
                  decoration: const InputDecoration(
                    labelText: 'Activity Name',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Activity 1 - Algebra Basics',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _activityTotalController,
                  decoration: const InputDecoration(
                    labelText: 'Total Points',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., 30',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    _createNewActivity(subject);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create Activity'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Quiz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _quizNameController,
                  decoration: const InputDecoration(
                    labelText: 'Quiz Name',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Quiz 1 - Algebraic Expressions',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _quizTotalController,
                  decoration: const InputDecoration(
                    labelText: 'Total Points',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., 50',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    _createNewQuiz(subject);
                  },
                  icon: const Icon(Icons.quiz),
                  label: const Text('Create Quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Exam',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _examNameController,
                  decoration: const InputDecoration(
                    labelText: 'Exam Name',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Exam 1 - Preliminary Exam',
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _examTotalController,
                  decoration: const InputDecoration(
                    labelText: 'Total Points',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., 75',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    _createNewExam(subject);
                  },
                  icon: const Icon(Icons.assignment_turned_in),
                  label: const Text('Create Exam'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        
        // ADDED: Exam Template Preview Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Exam',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create a comprehensive exam with multiple question types.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: _openExamTemplate,
                  icon: const Icon(Icons.assignment_turned_in),
                  label: const Text('View Exam Template'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        
        Text(
          'Existing Activities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 15),
        
        // Show existing activities
        _buildExistingActivitiesList(subject),
      ],
    );
  }

  Widget _buildExistingActivitiesList(Map<String, dynamic> subject) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if ((subject['activities'] as List).isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Activities:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...(subject['activities'] as List).map<Widget>((activity) {
                return ListTile(
                  leading: const Icon(Icons.assignment, color: Colors.blue),
                  title: Text(activity['name']),
                  subtitle: Text('Total: ${activity['total']} points • ${activity['date']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteActivity(subject, 'activity', activity);
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        
        if ((subject['quizzes'] as List).isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Quizzes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...(subject['quizzes'] as List).map<Widget>((quiz) {
                return ListTile(
                  leading: const Icon(Icons.quiz, color: Colors.orange),
                  title: Text(quiz['name']),
                  subtitle: Text('Total: ${quiz['total']} points • ${quiz['date']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteActivity(subject, 'quiz', quiz);
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        
        if ((subject['exams'] as List).isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Exams:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...(subject['exams'] as List).map<Widget>((exam) {
                return ListTile(
                  leading: const Icon(Icons.assignment_turned_in, color: Colors.red),
                  title: Text(exam['name']),
                  subtitle: Text('Total: ${exam['total']} points • ${exam['date']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteActivity(subject, 'exam', exam);
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        
        if ((subject['activities'] as List).isEmpty &&
            (subject['quizzes'] as List).isEmpty &&
            (subject['exams'] as List).isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text('No activities created yet.'),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStudentsTab(Map<String, dynamic> subject) {
    final List<Map<String, dynamic>> students = List.from(subject['students']);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Students in ${subject['name']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _showAddStudentDialog(subject);
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Add Student'),
              style: ElevatedButton.styleFrom(
                backgroundColor: subject['color'],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        if (students.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.people_outline, size: 50, color: Colors.grey),
                    SizedBox(height: 15),
                    Text(
                      'No students enrolled',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(3),
                      2: FlexColumnWidth(3),
                      3: FlexColumnWidth(1.5),
                      4: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                        ),
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Overall Grade', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      ...students.map<TableRow>((student) {
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(student['id']),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(student['name']),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(student['email']),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  Text(
                                    '${student['grades']['overall'].toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _getGradeColor(student['grades']['overall']),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_red_eye, size: 18),
                                    color: Colors.blue,
                                    onPressed: () {
                                      _viewStudentGrades(subject, student);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18),
                                    color: Colors.red,
                                    onPressed: () {
                                      _removeStudent(subject, student);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGradingSetupTab(Map<String, dynamic> subject) {
    final Map<String, double> weights = Map.from(subject['grading_weight']);
    
    // Initialize controllers with current weights
    _activitiesWeightController.text = (weights['activities']! * 100).toString();
    _quizzesWeightController.text = (weights['quizzes']! * 100).toString();
    _examsWeightController.text = (weights['exams']! * 100).toString();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grading Weight Configuration',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Set the weight distribution for ${subject['name']}. The total must equal 100%.',
          style: TextStyle(
            color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        
        const SizedBox(height: 30),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildWeightInputRow(
                  'Activities',
                  'Includes all assignments, projects, and class activities',
                  _activitiesWeightController,
                  Colors.blue,
                ),
                const SizedBox(height: 20),
                _buildWeightInputRow(
                  'Quizzes',
                  'Includes all quizzes and short assessments',
                  _quizzesWeightController,
                  Colors.orange,
                ),
                const SizedBox(height: 20),
                _buildWeightInputRow(
                  'Exams',
                  'Includes midterm and final exams',
                  _examsWeightController,
                  Colors.red,
                ),
                
                const SizedBox(height: 30),
                
                // Total calculation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Weight:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _calculateTotalWeight().toStringAsFixed(1) + '%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: _calculateTotalWeight() == 100 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                if (_calculateTotalWeight() != 100)
                  Text(
                    'Total must equal 100%. Current: ${_calculateTotalWeight().toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                
                const SizedBox(height: 30),
                
                ElevatedButton(
                  onPressed: _calculateTotalWeight() == 100 ? () {
                    _saveGradingWeights(subject);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: subject['color'],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Save Grading Weights'),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        
        // Student Grades Preview
        Text(
          'Student Grades Preview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'With current weights, here are student grades:',
          style: TextStyle(
            color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 15),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(1.5),
                    4: FlexColumnWidth(1.5),
                    5: FlexColumnWidth(1.5),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('Student', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('Prelim', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('Midterm', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('Final', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('Overall', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...(subject['students'] as List<Map<String, dynamic>>).map<TableRow>((student) {
                      final grades = student['grades'];
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(student['name']),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '${grades['prelim'].toStringAsFixed(1)}%',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _getGradeColor(grades['prelim']),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '${grades['midterm'].toStringAsFixed(1)}%',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _getGradeColor(grades['midterm']),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '${grades['final'].toStringAsFixed(1)}%',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _getGradeColor(grades['final']),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '${grades['overall'].toStringAsFixed(1)}%',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getGradeColor(grades['overall']),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: grades['overall'] >= 70 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                grades['overall'] >= 70 ? 'Passing' : 'Failing',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: grades['overall'] >= 70 ? Colors.green : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightInputRow(String label, String description, TextEditingController controller, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Weight %',
              border: const OutlineInputBorder(),
              suffixText: '%',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  // ==================== UTILITY FUNCTIONS ====================
  void _showAddSubjectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Subject Name',
                  hintText: 'e.g., Advanced Mathematics',
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Subject Code',
                  hintText: 'e.g., MATH201',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Subject added successfully'),
                  ),
                );
              },
              child: const Text('Add Subject'),
            ),
          ],
        );
      },
    );
  }

  void _createNewActivity(Map<String, dynamic> subject) {
    if (_activityNameController.text.isEmpty || _activityTotalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newActivity = {
      'name': _activityNameController.text,
      'date': DateTime.now().toString().split(' ')[0],
      'total': int.parse(_activityTotalController.text),
    };

    setState(() {
      (subject['activities'] as List).add(newActivity);
    });

    _activityNameController.clear();
    _activityTotalController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Activity created successfully'),
      ),
    );
  }

  void _createNewQuiz(Map<String, dynamic> subject) {
    if (_quizNameController.text.isEmpty || _quizTotalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newQuiz = {
      'name': _quizNameController.text,
      'date': DateTime.now().toString().split(' ')[0],
      'total': int.parse(_quizTotalController.text),
    };

    setState(() {
      (subject['quizzes'] as List).add(newQuiz);
    });

    _quizNameController.clear();
    _quizTotalController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quiz created successfully'),
      ),
    );
  }

  void _createNewExam(Map<String, dynamic> subject) {
    if (_examNameController.text.isEmpty || _examTotalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newExam = {
      'name': _examNameController.text,
      'date': DateTime.now().toString().split(' ')[0],
      'total': int.parse(_examTotalController.text),
    };

    setState(() {
      (subject['exams'] as List).add(newExam);
    });

    _examNameController.clear();
    _examTotalController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exam created successfully'),
      ),
    );
  }

  void _deleteActivity(Map<String, dynamic> subject, String type, Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Activity'),
          content: Text('Are you sure you want to delete "${activity['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (type == 'activity') {
                    (subject['activities'] as List).remove(activity);
                  } else if (type == 'quiz') {
                    (subject['quizzes'] as List).remove(activity);
                  } else if (type == 'exam') {
                    (subject['exams'] as List).remove(activity);
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Activity deleted successfully'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddStudentDialog(Map<String, dynamic> subject) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Student to Class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  hintText: 'e.g., S006',
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  hintText: 'e.g., Alex Johnson',
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Student Email',
                  hintText: 'e.g., alex@example.com',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // In a real app, you would add the student here
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Student added successfully'),
                  ),
                );
              },
              child: const Text('Add Student'),
            ),
          ],
        );
      },
    );
  }

  void _viewStudentGrades(Map<String, dynamic> subject, Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) {
        final grades = student['grades'];
        return AlertDialog(
          title: Text('${student['name']} - Grades'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Student ID: ${student['id']}'),
              Text('Email: ${student['email']}'),
              const SizedBox(height: 20),
              const Text(
                'Grades:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildGradeRow('Prelim', grades['prelim']),
              _buildGradeRow('Midterm', grades['midterm']),
              _buildGradeRow('Final', grades['final']),
              const Divider(),
              _buildGradeRow('Overall', grades['overall'], isOverall: true),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGradeRow(String label, double grade, {bool isOverall = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '${grade.toStringAsFixed(1)}%',
            style: TextStyle(
              fontWeight: isOverall ? FontWeight.bold : FontWeight.normal,
              color: _getGradeColor(grade),
            ),
          ),
        ],
      ),
    );
  }

  void _removeStudent(Map<String, dynamic> subject, Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Student'),
          content: Text('Are you sure you want to remove ${student['name']} from ${subject['name']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  (subject['students'] as List).remove(student);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${student['name']} removed from ${subject['name']}'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  double _calculateTotalWeight() {
    try {
      final activities = double.tryParse(_activitiesWeightController.text) ?? 0;
      final quizzes = double.tryParse(_quizzesWeightController.text) ?? 0;
      final exams = double.tryParse(_examsWeightController.text) ?? 0;
      return activities + quizzes + exams;
    } catch (e) {
      return 0;
    }
  }

  void _saveGradingWeights(Map<String, dynamic> subject) {
    final activities = double.tryParse(_activitiesWeightController.text) ?? 0;
    final quizzes = double.tryParse(_quizzesWeightController.text) ?? 0;
    final exams = double.tryParse(_examsWeightController.text) ?? 0;

    setState(() {
      subject['grading_weight'] = {
        'activities': activities / 100,
        'quizzes': quizzes / 100,
        'exams': exams / 100,
      };
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Grading weights saved successfully'),
      ),
    );
  }

  Color _getGradeColor(double grade) {
    if (grade >= 90) return Colors.green;
    if (grade >= 80) return Colors.blue;
    if (grade >= 70) return Colors.orange;
    return Colors.red;
  }
}