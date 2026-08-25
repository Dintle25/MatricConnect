import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  String _grade = 'Grade 12';
  bool _submitting = false;

  final _grades = const ['Grade 10', 'Grade 11', 'Grade 12'];

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty || _schoolController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in your name and school')),
      );
      return;
    }
    setState(() => _submitting = true);
    await ref.read(authProvider.notifier).login(
          name: _nameController.text.trim(),
          grade: _grade,
          school: _schoolController.text.trim(),
        );
    // No need to navigate manually — the router redirect in
    // app_router.dart watches authProvider and moves us to /home.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to\nMatricConnect',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, height: 1.15),
              ),
              const SizedBox(height: 8),
              const Text(
                'Past papers, study guides, and real students who\'ve been through it — without eating your data.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 36),
              _buildField(_nameController, 'Your name', Icons.person_outline_rounded),
              const SizedBox(height: 14),
              _buildField(_schoolController, 'Your school', Icons.school_outlined),
              const SizedBox(height: 14),
              _buildGradePicker(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                        )
                      : const Text('Get started'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surfaceMuted,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildGradePicker() {
    return Row(
      children: _grades.map((g) {
        final selected = g == _grade;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(g),
            selected: selected,
            onSelected: (_) => setState(() => _grade = g),
            selectedColor: AppColors.primaryDark,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: AppColors.surfaceMuted,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }).toList(),
    );
  }
}
