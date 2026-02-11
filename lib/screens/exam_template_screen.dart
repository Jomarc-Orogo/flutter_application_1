// exam_template_screen.dart
import 'package:flutter/material.dart';

class ExamTemplateScreen extends StatelessWidget {
  final String subjectName;
  final String examName;
  final String timeAllowed;
  final String totalPoints;
  final bool isTeacherView;

  const ExamTemplateScreen({
    super.key,
    required this.subjectName,
    required this.examName,
    this.timeAllowed = "1 hour",
    this.totalPoints = "100",
    this.isTeacherView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(examName),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exam Header
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subjectName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        examName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildExamInfoItem(Icons.access_time, timeAllowed),
                          _buildExamInfoItem(Icons.score, "$totalPoints points"),
                          _buildExamInfoItem(Icons.person, isTeacherView ? "Teacher View" : "Student View"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (!isTeacherView)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue[100]!),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue, size: 20),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "This is a preview of what the exam will look like. In the actual implementation, you'll be able to answer questions and submit your exam.",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Exam Instructions
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Instructions:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "1. Read each question carefully before answering.\n"
                        "2. Select only ONE answer for multiple choice questions.\n"
                        "3. You have $timeAllowed to complete the exam.\n"
                        "4. Submit your answers before the time expires.\n"
                        "5. All questions are mandatory.",
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                      if (isTeacherView)
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                              label: const Text("Edit Exam Instructions"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Questions Section
              Text(
                "Questions",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Multiple Choice Questions (Select the correct answer)",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 20),

              // Sample Questions
              _buildQuestionCard(
                questionNumber: 1,
                question: "What is the result of 5 + 3 × 2?",
                options: [
                  "11",
                  "16",
                  "13",
                  "10",
                ],
                correctAnswer: 0,
                isTeacherView: isTeacherView,
              ),

              _buildQuestionCard(
                questionNumber: 2,
                question: "Which of the following is NOT a programming language?",
                options: [
                  "Python",
                  "Java",
                  "HTML",
                  "Flutter",
                ],
                correctAnswer: 2,
                isTeacherView: isTeacherView,
              ),

              _buildQuestionCard(
                questionNumber: 3,
                question: "What does CPU stand for?",
                options: [
                  "Central Processing Unit",
                  "Computer Processing Unit",
                  "Central Processor Unit",
                  "Computer Processor Unit",
                ],
                correctAnswer: 0,
                isTeacherView: isTeacherView,
              ),

              _buildQuestionCard(
                questionNumber: 4,
                question: "In object-oriented programming, what is encapsulation?",
                options: [
                  "Bundling of data and methods",
                  "Inheritance of properties",
                  "Polymorphism in classes",
                  "Abstraction of implementation",
                ],
                correctAnswer: 0,
                isTeacherView: isTeacherView,
              ),

              const SizedBox(height: 30),

              // Submit Section
              if (!isTeacherView)
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Ready to submit?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Once submitted, you cannot change your answers.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showSubmissionDialog(context);
                          },
                          icon: const Icon(Icons.send),
                          label: const Text("Submit Exam"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (isTeacherView)
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Teacher Controls",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                              label: const Text("Edit"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.preview),
                              label: const Text("Preview"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.people),
                              label: const Text("Assign"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildQuestionCard({
    required int questionNumber,
    required String question,
    required List<String> options,
    required int correctAnswer,
    required bool isTeacherView,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Q$questionNumber",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "(${options.length} points)",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isTeacherView && index == correctAnswer
                          ? Colors.green
                          : Colors.grey[300]!,
                      width: isTeacherView && index == correctAnswer ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: isTeacherView && index == correctAnswer
                        ? Colors.green[50]
                        : Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isTeacherView && index == correctAnswer
                                  ? Colors.green
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(child: Text(option)),
                      if (isTeacherView && index == correctAnswer)
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    ],
                  ),
                ),
              );
            }).toList(),
            if (!isTeacherView)
              const SizedBox(height: 10),
            if (!isTeacherView)
              Text(
                "Click to select your answer",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSubmissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Submit Exam"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning,
              color: Colors.orange,
              size: 50,
            ),
            SizedBox(height: 20),
            Text(
              "Are you sure you want to submit your exam?\n\n"
              "This action cannot be undone.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSubmissionSuccess(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text("Submit Exam"),
          ),
        ],
      ),
    );
  }

  void _showSubmissionSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exam Submitted"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            const SizedBox(height: 20),
            const Text(
              "Your exam has been submitted successfully!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "You will receive your results soon.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}