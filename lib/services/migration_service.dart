import '../repositories/user_repository.dart';
import '../repositories/task_repository.dart';
import '../models/user.dart';
import '../models/task.dart';

class MigrationService {
  final UserRepository _userRepository;
  final TaskRepository _taskRepository;

  MigrationService(this._userRepository, this._taskRepository);

  Future<void> runMigration() async {
    final existingTasks = await _taskRepository.getAllTasks();
    if (existingTasks.isNotEmpty) return;

    await _createSampleUsers();
    await _createSampleTasks();
  }

  Future<void> _createSampleUsers() async {
    final users = [
      User(
        id: 'sample_user_1',
        name: 'Maria Santos',
        email: 'maria.santos@email.com',
        createdAt: DateTime.now(),
      ),
      User(
        id: 'sample_user_2',
        name: 'John Dela Cruz',
        email: 'john.delacruz@email.com',
        createdAt: DateTime.now(),
      ),
      User(
        id: 'sample_user_3',
        name: 'Ana Reyes',
        email: 'ana.reyes@email.com',
        createdAt: DateTime.now(),
      ),
      User(
        id: 'sample_user_4',
        name: 'Carlos Mendoza',
        email: 'carlos.mendoza@email.com',
        createdAt: DateTime.now(),
      ),
      User(
        id: 'sample_user_5',
        name: 'Lisa Garcia',
        email: 'lisa.garcia@email.com',
        createdAt: DateTime.now(),
      ),
      User(
        id: 'sample_user_6',
        name: 'Miguel Torres',
        email: 'miguel.torres@email.com',
        createdAt: DateTime.now(),
      ),
    ];

    for (final user in users) {
      await _userRepository.createUser(user);
    }
  }

  Future<void> _createSampleTasks() async {
    final tasks = [
      Task(
        id: '1',
        title: 'Grocery Shopping',
        description: 'Need someone to buy groceries from SM Tagum. List will be provided.',
        category: 'Home & Errands',
        price: 150,
        location: 'SM Tagum, Pioneer Avenue',
        deadline: DateTime.now().add(const Duration(hours: 3)),
        status: 'open',
        postedByUserId: 'sample_user_1',
        latitude: 7.4479,
        longitude: 125.8072,
      ),
      Task(
        id: '2',
        title: 'House Cleaning',
        description: 'Deep cleaning for 2-bedroom apartment. Supplies provided.',
        category: 'Home & Errands',
        price: 800,
        location: 'Apokon, Tagum City',
        deadline: DateTime.now().add(const Duration(days: 1)),
        status: 'open',
        postedByUserId: 'sample_user_2',
        latitude: 7.4500,
        longitude: 125.8100,
      ),
      Task(
        id: '3',
        title: 'Math Tutoring',
        description: 'Need help with Grade 10 Mathematics. 2 hours session.',
        category: 'Learning & Tutoring',
        price: 300,
        location: 'Magugpo East, Tagum City',
        deadline: DateTime.now().add(const Duration(days: 2)),
        status: 'open',
        postedByUserId: 'sample_user_3',
        latitude: 7.4520,
        longitude: 125.8150,
      ),
      Task(
        id: '4',
        title: 'Appliance Repair',
        description: 'Fix washing machine that won\'t drain properly.',
        category: 'Repairs & Maintenance',
        price: 500,
        location: 'Mankilam, Tagum City',
        deadline: DateTime.now().add(const Duration(hours: 6)),
        status: 'open',
        postedByUserId: 'sample_user_4',
        latitude: 7.4450,
        longitude: 125.8050,
      ),
      Task(
        id: '5',
        title: 'Pet Walking',
        description: 'Walk my Golden Retriever for 1 hour in the morning.',
        category: 'Care & Personal Assistance',
        price: 200,
        location: 'New Visayas, Tagum City',
        deadline: DateTime.now().add(const Duration(hours: 12)),
        status: 'open',
        postedByUserId: 'sample_user_5',
        latitude: 7.4480,
        longitude: 125.8120,
      ),
      Task(
        id: '6',
        title: 'Event Setup',
        description: 'Help setup birthday party decorations and tables.',
        category: 'Events & Miscellaneous',
        price: 400,
        location: 'Pagsabangan, Tagum City',
        deadline: DateTime.now().add(const Duration(days: 3)),
        status: 'open',
        postedByUserId: 'sample_user_6',
        latitude: 7.4510,
        longitude: 125.8080,
      ),
    ];

    for (final task in tasks) {
      await _taskRepository.createTask(task);
    }
  }
}