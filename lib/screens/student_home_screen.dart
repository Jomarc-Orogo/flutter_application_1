import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'exam_template_screen.dart'; // ADD THIS IMPORT

class StudentHomeScreen extends StatefulWidget {
  final String? username;
  final String? email;
  final String? studentId;

  const StudentHomeScreen({
    super.key,
    this.username,
    this.email,
    this.studentId,
  });

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  // ==================== STATE VARIABLES ====================
  String _selectedSection = 'dashboard';
  String? _selectedSubjectForDetails;
  String? _selectedSubjectInSidebar;
  bool _isDarkMode = false;
  bool _isSubjectsExpanded = true; // Always expanded for better UX
  bool _isGradesExpanded = true; // Always expanded for better UX
  String _selectedGradingPeriod = 'prelim';

  // Sample data with multiple grading periods
  final List<Map<String, dynamic>> _subjects = [
    {
      'name': 'Mathematics',
      'code': 'MATH101',
      'teacher': 'Prof. Johnson',
      'color': Colors.blue,
      'icon': Icons.calculate,
      'grading_periods': {
        'prelim': {
          'activities': [
            {'name': 'Activity 1 - Algebra Basics', 'score': 25, 'total': 30, 'date': 'Sep 15, 2023'},
            {'name': 'Activity 2 - Linear Equations', 'score': 18, 'total': 20, 'date': 'Sep 22, 2023'},
          ],
          'quizzes': [
            {'name': 'Quiz 1 - Algebraic Expressions', 'score': 43, 'total': 50, 'date': 'Sep 28, 2023'},
          ],
          'exams': [
            {'name': 'Exam 1 - Preliminary Exam', 'score': 67, 'total': 75, 'date': 'Oct 5, 2023'},
          ],
        },
        'midterm': {
          'activities': [
            {'name': 'Activity 3 - Quadratic Equations', 'score': 28, 'total': 30, 'date': 'Oct 20, 2023'},
            {'name': 'Activity 4 - Functions', 'score': 19, 'total': 20, 'date': 'Oct 27, 2023'},
          ],
          'quizzes': [
            {'name': 'Quiz 2 - Quadratic Functions', 'score': 46, 'total': 50, 'date': 'Nov 3, 2023'},
          ],
          'exams': [
            {'name': 'Exam 2 - Midterm Exam', 'score': 70, 'total': 80, 'date': 'Nov 10, 2023'},
          ],
        },
        'final': {
          'activities': [
            {'name': 'Activity 5 - Trigonometry', 'score': 27, 'total': 30, 'date': 'Nov 25, 2023'},
            {'name': 'Activity 6 - Calculus Basics', 'score': 17, 'total': 20, 'date': 'Dec 2, 2023'},
          ],
          'quizzes': [
            {'name': 'Quiz 3 - Trigonometric Functions', 'score': 48, 'total': 50, 'date': 'Dec 9, 2023'},
          ],
          'exams': [
            {'name': 'Exam 3 - Final Exam', 'score': 85, 'total': 100, 'date': 'Dec 16, 2023'},
          ],
        },
      }
    },
    {
      'name': 'Science',
      'code': 'SCI201',
      'teacher': 'Dr. Smith',
      'color': Colors.green,
      'icon': Icons.science,
      'grading_periods': {
        'prelim': {
          'activities': [
            {'name': 'Lab Report 1 - Chemistry Basics', 'score': 28, 'total': 30, 'date': 'Sep 16, 2023'},
            {'name': 'Lab Report 2 - Chemical Reactions', 'score': 17, 'total': 20, 'date': 'Sep 23, 2023'},
          ],
          'quizzes': [
            {'name': 'Quiz 1 - Periodic Table', 'score': 45, 'total': 50, 'date': 'Sep 29, 2023'},
          ],
          'exams': [
            {'name': 'Exam 1 - Chemistry Exam', 'score': 65, 'total': 75, 'date': 'Oct 6, 2023'},
          ],
        },
        'midterm': {
          'activities': [
            {'name': 'Lab Report 3 - Physics Basics', 'score': 29, 'total': 30, 'date': 'Oct 21, 2023'},
            {'name': 'Lab Report 4 - Newton\'s Laws', 'score': 18, 'total': 20, 'date': 'Oct 28, 2023'},
          ],
          'quizzes': [
            {'name': 'Quiz 2 - Physics Concepts', 'score': 47, 'total': 50, 'date': 'Nov 4, 2023'},
          ],
          'exams': [
            {'name': 'Exam 2 - Physics Exam', 'score': 72, 'total': 85, 'date': 'Nov 11, 2023'},
          ],
        },
        'final': {
          'activities': [
            {'name': 'Lab Report 5 - Biology Basics', 'score': 26, 'total': 30, 'date': 'Nov 26, 2023'},
            {'name': 'Lab Report 6 - Cell Biology', 'score': 19, 'total': 20, 'date': 'Dec 3, 2023'},
          ],
          'quizzes': [
            {'name': 'Quiz 3 - Biology Concepts', 'score': 49, 'total': 50, 'date': 'Dec 10, 2023'},
          ],
          'exams': [
            {'name': 'Exam 3 - Biology Final', 'score': 88, 'total': 100, 'date': 'Dec 17, 2023'},
          ],
        },
      }
    },
    {
      'name': 'English',
      'code': 'ENG101',
      'teacher': 'Ms. Williams',
      'color': Colors.red,
      'icon': Icons.language,
      'grading_periods': {
        'prelim': {
          'activities': [
            {'name': 'Essay 1 - Descriptive Writing', 'score': 27, 'total': 30, 'date': 'Sep 17, 2023'},
            {'name': 'Essay 2 - Narrative Writing', 'score': 19, 'total': 20, 'date': 'Sep 24, 2023'},
          ],
          'quizzes': [
            {'name': 'Quiz 1 - Grammar Rules', 'score': 46, 'total': 50, 'date': 'Sep 30, 2023'},
          ],
          'exams': [
            {'name': 'Exam 1 - Grammar & Writing', 'score': 68, 'total': 75, 'date': 'Oct 7, 2023'},
          ],
        },
        'midterm': {
          'activities': [
            {'name': 'Essay 3 - Persuasive Writing', 'score': 26, 'total': 30, 'date': 'Oct 22, 2023'},
            {'name': 'Essay 4 - Expository Writing', 'score': 18, 'total': 20, 'date': 'Oct 29, 2023'},
          ],
          'quizzes': [
            {'name': 'Quiz 2 - Literature Terms', 'score': 44, 'total': 50, 'date': 'Nov 5, 2023'},
          ],
          'exams': [
            {'name': 'Exam 2 - Literature Analysis', 'score': 75, 'total': 85, 'date': 'Nov 12, 2023'},
          ],
        },
        'final': {
          'activities': [
            {'name': 'Essay 5 - Research Paper', 'score': 29, 'total': 30, 'date': 'Nov 27, 2023'},
            {'name': 'Essay 6 - Final Project', 'score': 20, 'total': 20, 'date': 'Dec 4, 2023'},
          ],
          'quizzes': [
            {'name': 'Quiz 3 - Critical Analysis', 'score': 48, 'total': 50, 'date': 'Dec 11, 2023'},
          ],
          'exams': [
            {'name': 'Exam 3 - Comprehensive Final', 'score': 90, 'total': 100, 'date': 'Dec 18, 2023'},
          ],
        },
      }
    },
  ];

  final List<Map<String, dynamic>> _announcements = [
    {
      'title': 'Midterm Exam Schedule',
      'content': 'The schedule for midterm exams has been published. Please check your subjects.',
      'date': 'Oct 15, 2023',
      'subject': 'All Subjects',
      'teacher': 'Academic Office',
    },
    {
      'title': 'Math Quiz Performance',
      'content': 'Great job on Quiz 1! Class average was 84%. Review Activity 2 before next quiz.',
      'date': 'Oct 12, 2023',
      'subject': 'Mathematics',
      'teacher': 'Prof. Johnson',
    },
    {
      'title': 'Science Lab Safety',
      'content': 'Reminder: Safety goggles must be worn at all times during lab sessions.',
      'date': 'Oct 10, 2023',
      'subject': 'Science',
      'teacher': 'Dr. Smith',
    },
    {
      'title': 'Holiday Notice',
      'content': 'University will remain closed next Friday for a public holiday.',
      'date': 'Oct 5, 2023',
      'subject': 'All',
      'teacher': 'Administration',
    },
  ];

  final TextEditingController _classCodeController = TextEditingController();

  // ==================== GRADE CALCULATION FUNCTIONS ====================
  Map<String, dynamic> _calculatePeriodGrade(Map<String, dynamic> subject, String period) {
    final periodData = subject['grading_periods'][period];
    if (periodData == null) return {'average': 0.0, 'breakdown': {}};
    
    final activities = List<Map<String, dynamic>>.from(periodData['activities'] ?? []);
    final quizzes = List<Map<String, dynamic>>.from(periodData['quizzes'] ?? []);
    final exams = List<Map<String, dynamic>>.from(periodData['exams'] ?? []);
    
    final activitiesAvg = _calculateAverage(activities);
    final quizzesAvg = _calculateAverage(quizzes);
    final examsAvg = _calculateAverage(exams);
    
    final weightedActivities = activitiesAvg * 0.50;
    final weightedQuizzes = quizzesAvg * 0.30;
    final weightedExams = examsAvg * 0.20;
    
    final periodAverage = weightedActivities + weightedQuizzes + weightedExams;
    
    return {
      'average': periodAverage,
      'breakdown': {
        'activities': activitiesAvg,
        'quizzes': quizzesAvg,
        'exams': examsAvg,
        'weighted': {
          'activities': weightedActivities,
          'quizzes': weightedQuizzes,
          'exams': weightedExams,
        }
      }
    };
  }
  
  Map<String, dynamic> _calculateOverallGrade(Map<String, dynamic> subject) {
    final gradingPeriods = subject['grading_periods'] as Map<String, dynamic>;
    List<double> periodAverages = [];
    Map<String, double> periodGrades = {};
    
    for (var period in gradingPeriods.keys) {
      final periodGrade = _calculatePeriodGrade(subject, period);
      periodAverages.add(periodGrade['average']);
      periodGrades[period] = periodGrade['average'];
    }
    
    if (periodAverages.isEmpty) return {'average': 0.0, 'periods': {}};
    
    final overallAverage = periodAverages.reduce((a, b) => a + b) / periodAverages.length;
    
    return {
      'average': overallAverage,
      'periods': periodGrades,
    };
  }
  
  double _calculateAverage(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return 0.0;
    
    double totalPercentage = 0;
    for (var item in items) {
      final score = (item['score'] as int? ?? 0).toDouble();
      final total = (item['total'] as int? ?? 1).toDouble();
      final percentage = (score / total) * 100;
      totalPercentage += percentage;
    }
    
    return totalPercentage / items.length;
  }

  List<Map<String, dynamic>> get _recentActivities {
    List<Map<String, dynamic>> allItems = [];
    
    for (var subject in _subjects) {
      final gradingPeriods = subject['grading_periods'] as Map<String, dynamic>;
      
      for (var period in gradingPeriods.keys) {
        final periodData = gradingPeriods[period];
        
        final activities = List<Map<String, dynamic>>.from(periodData['activities'] ?? []);
        final quizzes = List<Map<String, dynamic>>.from(periodData['quizzes'] ?? []);
        final exams = List<Map<String, dynamic>>.from(periodData['exams'] ?? []);
        
        for (var activity in activities) {
          allItems.add({
            'type': 'activity',
            'name': activity['name'],
            'subject': subject['name'],
            'date': activity['date'],
            'score': activity['score'],
            'total': activity['total'],
            'period': period,
            'color': subject['color'],
            'icon': subject['icon'],
          });
        }
        
        for (var quiz in quizzes) {
          allItems.add({
            'type': 'quiz',
            'name': quiz['name'],
            'subject': subject['name'],
            'date': quiz['date'],
            'score': quiz['score'],
            'total': quiz['total'],
            'period': period,
            'color': subject['color'],
            'icon': subject['icon'],
          });
        }
        
        for (var exam in exams) {
          allItems.add({
            'type': 'exam',
            'name': exam['name'],
            'subject': subject['name'],
            'date': exam['date'],
            'score': exam['score'],
            'total': exam['total'],
            'period': period,
            'color': subject['color'],
            'icon': subject['icon'],
          });
        }
      }
    }
    
    allItems.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));
    
    return allItems.take(5).toList();
  }

  double _calculateOverallAverage() {
    if (_subjects.isEmpty) return 0.0;
    
    double total = 0.0;
    for (var subject in _subjects) {
      final overallGrade = _calculateOverallGrade(subject);
      total += overallGrade['average'];
    }
    
    return total / _subjects.length;
  }

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
          isTeacherView: false,
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
              widget.studentId ?? 'Student ID: ---',
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
                    'Profile: ${widget.username ?? 'Student'}',
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
                  widget.username ?? 'Student',
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
          _buildGradesTree(),
          _buildNavItem('announcements', Icons.announcement, 'Announcements'),
          
          const Spacer(),
          
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enroll in Subject',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _classCodeController,
                  decoration: InputDecoration(
                    hintText: 'Enter class code',
                    filled: true,
                    fillColor: _isDarkMode ? Colors.grey[700] : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (_classCodeController.text.isNotEmpty) {
                          _enrollWithClassCode(_classCodeController.text);
                        }
                      },
                      icon: const Icon(Icons.add_circle, color: Colors.blue),
                    ),
                  ),
                ),
              ],
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
        // Always show the "My Subjects" header as expandable
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedSection = 'subjects';
              _selectedSubjectForDetails = null;
              _selectedSubjectInSidebar = null;
              _isSubjectsExpanded = true; // Always keep expanded
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: _selectedSection == 'subjects'
                  ? (_isDarkMode ? Colors.deepPurple[800] : Colors.deepPurple[100])
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.school,
                  color: _selectedSection == 'subjects'
                      ? Colors.deepPurple
                      : (_isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                  size: 22,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'My Subjects',
                    style: TextStyle(
                      fontWeight: _selectedSection == 'subjects' 
                          ? FontWeight.bold : FontWeight.normal,
                      color: _selectedSection == 'subjects'
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
        
        // Always show subject list when in subjects section
        if (_selectedSection == 'subjects')
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 5, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _subjects.map((subject) {
                return _buildSubjectTreeItem(subject);
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSubjectTreeItem(Map<String, dynamic> subject) {
    final bool isSelected = _selectedSubjectInSidebar == subject['name'];
    final overallGrade = _calculateOverallGrade(subject);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSection = 'subjects';
          _selectedSubjectForDetails = subject['name'];
          _selectedSubjectInSidebar = subject['name'];
          _selectedGradingPeriod = 'prelim';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? (_isDarkMode ? Colors.deepPurple[700] : Colors.deepPurple[50])
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(
            color: subject['color'] as Color,
            width: 1,
          ) : null,
        ),
        child: Row(
          children: [
            Icon(
              subject['icon'] as IconData,
              color: subject['color'] as Color,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                subject['name'] as String,
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
              '${overallGrade['average'].toStringAsFixed(1)}%',
              style: TextStyle(
                color: subject['color'] as Color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradesTree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Always show the "My Grades" header as expandable
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedSection = 'grades';
              _selectedSubjectForDetails = null;
              _selectedSubjectInSidebar = null;
              _isGradesExpanded = true; // Always keep expanded
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: _selectedSection == 'grades'
                  ? (_isDarkMode ? Colors.deepPurple[800] : Colors.deepPurple[100])
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.grade,
                  color: _selectedSection == 'grades'
                      ? Colors.deepPurple
                      : (_isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                  size: 22,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'My Grades',
                    style: TextStyle(
                      fontWeight: _selectedSection == 'grades' 
                          ? FontWeight.bold : FontWeight.normal,
                      color: _selectedSection == 'grades'
                          ? (_isDarkMode ? Colors.white : Colors.deepPurple)
                          : (_isDarkMode ? Colors.grey[400] : Colors.grey[700]),
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  _isGradesExpanded ? Icons.expand_less : Icons.expand_more,
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        
        // Always show grades list when in grades section
        if (_selectedSection == 'grades')
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 5, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _subjects.map((subject) {
                final overallGrade = _calculateOverallGrade(subject);
                final bool isSelected = _selectedSubjectInSidebar == subject['name'] && 
                                      _selectedSection == 'grades';
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSection = 'grades';
                      _selectedSubjectForDetails = subject['name'];
                      _selectedSubjectInSidebar = subject['name'];
                      _selectedGradingPeriod = 'prelim';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (_isDarkMode ? Colors.deepPurple[700] : Colors.deepPurple[50])
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected ? Border.all(
                        color: subject['color'] as Color,
                        width: 1,
                      ) : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          subject['icon'] as IconData,
                          color: subject['color'] as Color,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            subject['name'] as String,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? (_isDarkMode ? Colors.white : Colors.deepPurple)
                                  : (_isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${overallGrade['average'].toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: subject['color'] as Color,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Overall',
                              style: TextStyle(
                                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
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
      case 'grades':
        return _buildGradesView();
      case 'announcements':
        return _buildAnnouncementsView();
      default:
        return _buildDashboard();
    }
  }

  // ==================== DASHBOARD ====================
  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${widget.username ?? 'Student'}!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Here\'s what\'s new in your courses',
              style: TextStyle(
                fontSize: 16,
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 30),
            
            Text(
              'Recent Activities',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 15),
            
            if (_recentActivities.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: 50,
                        color: _isDarkMode ? Colors.grey[600] : Colors.grey[400],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'No recent activities',
                        style: TextStyle(
                          fontSize: 16,
                          color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._recentActivities.map<Widget>((item) {
                return _buildRecentActivityCard(item);
              }).toList(),
            
            const SizedBox(height: 30),
            
            Text(
              'Quick Overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 15),
            
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
                  '${_subjects.length}',
                  Icons.school,
                  Colors.blue,
                ),
                _buildOverviewCard(
                  'Overall Average',
                  '${_calculateOverallAverage().toStringAsFixed(1)}%',
                  Icons.grade,
                  Colors.green,
                ),
                _buildOverviewCard(
                  'Upcoming Deadlines',
                  '3',
                  Icons.calendar_today,
                  Colors.orange,
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // ADDED: Upcoming Exam Card
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upcoming Exam',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.quiz, color: Colors.orange),
                      ),
                      title: const Text(
                        'Mathematics Midterm Exam',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Due: Tomorrow, 10:00 AM'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: _openExamTemplate,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _openExamTemplate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Preview Exam Format'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Announcements',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedSection = 'announcements';
                    });
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            ..._announcements.take(2).map<Widget>((announcement) {
              return _buildAnnouncementPreviewCard(announcement);
            }).toList(),
          ],
        ),
      ),
    );
  }

  // ==================== SUBJECTS VIEW ====================
  Widget _buildSubjectsView() {
    if (_selectedSubjectForDetails != null) {
      final subject = _subjects.firstWhere(
        (s) => s['name'] == _selectedSubjectForDetails,
        orElse: () => _subjects[0],
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
            'Click on a subject to see detailed view',
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
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                return _buildSubjectCard(subject);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final overallGrade = _calculateOverallGrade(subject);
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedSubjectForDetails = subject['name'];
          _selectedSubjectInSidebar = subject['name'];
          _selectedGradingPeriod = 'prelim';
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
                      color: (subject['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(subject['icon'] as IconData, color: subject['color'] as Color),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject['name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          subject['code'] as String,
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
              Text(
                'Instructor: ${subject['teacher']}',
                style: TextStyle(
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: overallGrade['average'] / 100,
                backgroundColor: _isDarkMode ? Colors.grey[700] : Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(subject['color'] as Color),
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Overall Grade',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${overallGrade['average'].toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: subject['color'] as Color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== SUBJECT DETAILS VIEW ====================
  Widget _buildSubjectDetailsView(Map<String, dynamic> subject) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject header without back button (dropdown handles navigation)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (subject['color'] as Color).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(subject['icon'] as IconData, color: subject['color'] as Color),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject['name'] as String,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : Colors.grey[800],
                      ),
                    ),
                    Text(
                      subject['code'] as String,
                      style: TextStyle(
                        color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            Text(
              'Instructor: ${subject['teacher']}',
              style: TextStyle(
                fontSize: 16,
                color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Grading Period Tabs
            Text(
              'Select Grading Period',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            
            Row(
              children: [
                _buildPeriodTab('Prelim', 'prelim', subject['color'] as Color),
                const SizedBox(width: 10),
                _buildPeriodTab('Midterm', 'midterm', subject['color'] as Color),
                const SizedBox(width: 10),
                _buildPeriodTab('Final', 'final', subject['color'] as Color),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Display selected grading period details
            _buildGradingPeriodDetails(subject, _selectedGradingPeriod),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodTab(String label, String period, Color color) {
    final bool isSelected = _selectedGradingPeriod == period;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGradingPeriod = period;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: isSelected ? 0 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradingPeriodDetails(Map<String, dynamic> subject, String period) {
    final periodData = subject['grading_periods'][period];
    if (periodData == null) {
      return Center(
        child: Text(
          'No data available for this grading period',
          style: TextStyle(
            color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      );
    }
    
    final periodGrade = _calculatePeriodGrade(subject, period);
    final periodName = period == 'prelim' ? 'Prelim' : 
                      period == 'midterm' ? 'Midterm' : 'Final';
    
    final activities = List<Map<String, dynamic>>.from(periodData['activities'] ?? []);
    final quizzes = List<Map<String, dynamic>>.from(periodData['quizzes'] ?? []);
    final exams = List<Map<String, dynamic>>.from(periodData['exams'] ?? []);
    
    int totalScore = 0;
    int totalMaxScore = 0;
    
    for (var activity in activities) {
      totalScore += (activity['score'] as int? ?? 0);
      totalMaxScore += (activity['total'] as int? ?? 0);
    }
    for (var quiz in quizzes) {
      totalScore += (quiz['score'] as int? ?? 0);
      totalMaxScore += (quiz['total'] as int? ?? 0);
    }
    for (var exam in exams) {
      totalScore += (exam['score'] as int? ?? 0);
      totalMaxScore += (exam['total'] as int? ?? 0);
    }
    
    final periodPercentage = totalMaxScore > 0 ? (totalScore / totalMaxScore * 100) : 0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  '$periodName Average: ${periodGrade['average'].toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: periodGrade['average'] / 100,
                  backgroundColor: _isDarkMode ? Colors.grey[700] : Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(subject['color'] as Color),
                  minHeight: 20,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total: $totalScore/$totalMaxScore points',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        
        Text(
          'Activities',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 15),
        ...activities.map<Widget>((activity) {
          return _buildAssessmentItemCard(
            activity,
            subject,
            period,
            Icons.assignment,
            Colors.blue,
            'Activity',
          );
        }).toList(),
        
        Text(
          'Quizzes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 15),
        ...quizzes.map<Widget>((quiz) {
          return _buildAssessmentItemCard(
            quiz,
            subject,
            period,
            Icons.quiz,
            Colors.orange,
            'Quiz',
          );
        }).toList(),
        
        Text(
          'Exams',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 15),
        ...exams.map<Widget>((exam) {
          return _buildAssessmentItemCard(
            exam,
            subject,
            period,
            Icons.assignment_turned_in,
            Colors.red,
            'Exam',
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAssessmentItemCard(
    Map<String, dynamic> item,
    Map<String, dynamic> subject,
    String period,
    IconData icon,
    Color iconColor,
    String type,
  ) {
    final score = item['score'] as int? ?? 0;
    final total = item['total'] as int? ?? 1;
    final percentage = (score / total) * 100;
    final periodName = period == 'prelim' ? 'Prelim' : 
                      period == 'midterm' ? 'Midterm' : 'Final';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] as String? ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _isDarkMode ? Colors.white : Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: _isDarkMode ? Colors.grey[500] : Colors.grey[600],
                          ),
                          const SizedBox(width: 5),
                          Text(
                            item['date'] as String? ?? '',
                            style: TextStyle(
                              color: _isDarkMode ? Colors.grey[500] : Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: (subject['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              periodName,
                              style: TextStyle(
                                color: subject['color'] as Color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getPercentageColor(percentage).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: _getPercentageColor(percentage),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$score/$total',
                      style: TextStyle(
                        color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: _isDarkMode ? Colors.grey[700] : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getPercentageColor(percentage)),
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradesView() {
    if (_selectedSubjectForDetails != null) {
      final subject = _subjects.firstWhere(
        (s) => s['name'] == _selectedSubjectForDetails,
        orElse: () => _subjects[0],
      );
      return _buildGradeDetails(subject);
    }
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Grades',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Click on a subject to see detailed breakdown',
            style: TextStyle(
              color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          
          Expanded(
            child: ListView.builder(
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                return _buildGradeSummaryCard(subject);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeSummaryCard(Map<String, dynamic> subject) {
    final overallGrade = _calculateOverallGrade(subject);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      child: ListTile(
        onTap: () {
          setState(() {
            _selectedSubjectForDetails = subject['name'];
            _selectedSubjectInSidebar = subject['name'];
            _selectedGradingPeriod = 'prelim';
          });
        },
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (subject['color'] as Color).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(subject['icon'] as IconData, color: subject['color'] as Color),
        ),
        title: Text(
          subject['name'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subject['code'] as String),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${overallGrade['average'].toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: subject['color'] as Color,
              ),
            ),
            Text(
              'Overall',
              style: TextStyle(
                fontSize: 12,
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeDetails(Map<String, dynamic> subject) {
    final overallGrade = _calculateOverallGrade(subject);
    final gradingPeriods = subject['grading_periods'] as Map<String, dynamic>;
    
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
                Text(
                  '${subject['name']} Grade Breakdown',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Overall Grade: ${overallGrade['average'].toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Calculated from all grading periods',
                      style: TextStyle(
                        color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 15),
                    LinearProgressIndicator(
                      value: overallGrade['average'] / 100,
                      backgroundColor: _isDarkMode ? Colors.grey[700] : Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(subject['color'] as Color),
                      minHeight: 20,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            Text(
              'Grading Period Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 15),
            
            ...gradingPeriods.keys.map<Widget>((period) {
              final periodName = period == 'prelim' ? 'Prelim' : 
                                period == 'midterm' ? 'Midterm' : 'Final';
              final periodGrade = _calculatePeriodGrade(subject, period);
              final breakdown = periodGrade['breakdown'] as Map<String, dynamic>;
              final weighted = breakdown['weighted'] as Map<String, dynamic>;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$periodName Grading Period',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: (subject['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${periodGrade['average'].toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: subject['color'] as Color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                        },
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey)),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text('Component', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text('Average', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text('Weight', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text('Weighted', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                          _buildTableRow('Activities', breakdown['activities'] as double, 0.50, weighted['activities'] as double),
                          _buildTableRow('Quizzes', breakdown['quizzes'] as double, 0.30, weighted['quizzes'] as double),
                          _buildTableRow('Exams', breakdown['exams'] as double, 0.20, weighted['exams'] as double),
                          TableRow(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey[300]!, width: 2),
                              ),
                            ),
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  periodGrade['average'].toStringAsFixed(1),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('1.00', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  '${periodGrade['average'].toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: periodGrade['average'] >= 70 ? Colors.green : Colors.orange,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            
            const SizedBox(height: 30),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Grade Calculation',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    Column(
                      children: (overallGrade['periods'] as Map<String, double>).entries.map<Widget>((entry) {
                        final periodName = entry.key == 'prelim' ? 'Prelim' : 
                                          entry.key == 'midterm' ? 'Midterm' : 'Final';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$periodName Grade'),
                              Text('${entry.value.toStringAsFixed(1)}%'),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const Divider(height: 30),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Overall Average',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${overallGrade['average'].toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: overallGrade['average'] >= 70 ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(Map<String, dynamic> activity) {
    final score = (activity['score'] as int? ?? 0).toDouble();
    final total = (activity['total'] as int? ?? 1).toDouble();
    final percentage = (score / total) * 100;
    final periodName = activity['period'] == 'prelim' ? 'Prelim' : 
                      activity['period'] == 'midterm' ? 'Midterm' : 'Final';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (activity['color'] as Color).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                activity['icon'] as IconData,
                color: activity['color'] as Color,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['subject'] as String,
                    style: TextStyle(
                      color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity['name'] as String,
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
                        activity['type'] == 'activity' ? Icons.assignment :
                        activity['type'] == 'quiz' ? Icons.quiz : Icons.assignment_turned_in,
                        size: 14,
                        color: _isDarkMode ? Colors.grey[500] : Colors.grey[600],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${(activity['type'] as String).toUpperCase()} • $periodName',
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
                        activity['date'] as String,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getPercentageColor(percentage).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: _getPercentageColor(percentage),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${score.toInt()}/${total.toInt()}',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
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

  Widget _buildAnnouncementPreviewCard(Map<String, dynamic> announcement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    announcement['subject'] as String,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  announcement['date'] as String,
                  style: TextStyle(
                    color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              announcement['title'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              (announcement['content'] as String).length > 100 
                  ? '${(announcement['content'] as String).substring(0, 100)}...'
                  : announcement['content'] as String,
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

  // ==================== ANNOUNCEMENTS VIEW ====================
  Widget _buildAnnouncementsView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Announcements',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Important messages from your teachers',
            style: TextStyle(
              color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          
          Expanded(
            child: ListView.builder(
              itemCount: _announcements.length,
              itemBuilder: (context, index) {
                final announcement = _announcements[index];
                return _buildAnnouncementCard(announcement);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    announcement['subject'] as String,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  announcement['date'] as String,
                  style: TextStyle(
                    color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              announcement['title'] as String,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              announcement['content'] as String,
              style: TextStyle(
                fontSize: 15,
                color: _isDarkMode ? Colors.grey[300] : Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  'From: ${announcement['teacher']}',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== UTILITY FUNCTIONS ====================
  void _enrollWithClassCode(String code) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Enrolling with class code: $code'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
    _classCodeController.clear();
  }

  void _showItemDetails(Map<String, dynamic> item, Map<String, dynamic> subject, String period) {
    final score = (item['score'] as int? ?? 0).toDouble();
    final total = (item['total'] as int? ?? 1).toDouble();
    final percentage = (score / total) * 100;
    final periodName = period == 'prelim' ? 'Prelim' : 
                      period == 'midterm' ? 'Midterm' : 'Final';
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.assignment,
                color: subject['color'] as Color,
              ),
              const SizedBox(width: 10),
              Text(
                '${subject['name']} - $periodName',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['name'] as String? ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 15),
              Text('Date: ${item['date']}'),
              const SizedBox(height: 10),
              Text('Score: ${score.toInt()}/${total.toInt()}'),
              const SizedBox(height: 10),
              Text('Percentage: ${percentage.toStringAsFixed(1)}%'),
              const SizedBox(height: 10),
              Text('Grade: ${_getGradeLetter(percentage)}'),
              const SizedBox(height: 15),
              LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: _isDarkMode ? Colors.grey[700] : Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(_getPercentageColor(percentage)),
              ),
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

  TableRow _buildTableRow(String label, double average, double weight, double weighted) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${average.toStringAsFixed(1)}%',
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            weight.toStringAsFixed(2),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${weighted.toStringAsFixed(1)}%',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: weighted >= 70 ? Colors.green : Colors.orange,
            ),
          ),
        ),
      ],
    );
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.blue;
    if (percentage >= 70) return Colors.orange;
    return Colors.red;
  }

  String _getGradeLetter(double percentage) {
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'F';
  }
}