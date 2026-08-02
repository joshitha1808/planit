import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit/core/constants/app_constants.dart';
import 'package:planit/core/theme/app_colors.dart';
import 'package:planit/core/utils/show_snackbar.dart';
import 'package:planit/models/user_profile.dart';
import 'package:planit/viewmodels/profile_viewmodel.dart';
import 'package:planit/views/widgets/neo_box.dart';

class ProfileSetupPage extends ConsumerStatefulWidget {
  final UserProfile? existing;

  const ProfileSetupPage({super.key, this.existing});

  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late String _avatar;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _emailController = TextEditingController(
      text: widget.existing?.email ?? '',
    );
    _avatar = widget.existing?.avatar ?? AppConstants.avatars.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty) {
      showSnackBar(context, "Please enter your name", SnackBarType.error);
      return;
    }
    if (email.isNotEmpty && !_isValidEmail(email)) {
      showSnackBar(context, "Please enter a valid email", SnackBarType.error);
      return;
    }

    await ref
        .read(profileViewModelProvider.notifier)
        .save(UserProfile(name: name, email: email, avatar: _avatar));

    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit profile" : "Your profile"),
        automaticallyImplyLeading: false,
        leading: isEditing
            ? Padding(
                padding: const EdgeInsets.only(left: 12),
                child: NeoButton(
                  padding: const EdgeInsets.all(8),
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.ink,
                  ),
                ),
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isEditing) ...[
              const Text(
                "Say hi!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                "Tell us a little about you.",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 28),
            ],

            // Selected avatar preview
            Center(
              child: NeoBox(
                color: AppColors.pastels[3],
                shadowOffset: const Offset(5, 5),
                padding: const EdgeInsets.all(10),
                radius: 100,
                child: ClipOval(
                  child: Image.asset(
                    _avatar,
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person_rounded,
                      size: 60,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(child: _label("PICK AN AVATAR")),
            const SizedBox(height: 14),
            _AvatarPicker(
              selected: _avatar,
              onSelected: (a) => setState(() => _avatar = a),
            ),

            const SizedBox(height: 28),
            _label("NAME"),
            const SizedBox(height: 12),
            _field(controller: _nameController, hint: "Your name"),

            const SizedBox(height: 20),
            _label("EMAIL"),
            const SizedBox(height: 12),
            _field(
              controller: _emailController,
              hint: "you@example.com (optional)",
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: NeoButton(
                color: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                onTap: _save,
                child: Center(
                  child: Text(
                    isEditing ? "Save" : "Let's go",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.2,
    ),
  );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return NeoBox(
      color: AppColors.surfaceLight,
      shadowOffset: const Offset(3, 3),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.ink.withValues(alpha: 0.4),
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _AvatarPicker({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        alignment: WrapAlignment.center,
        children: AppConstants.avatars.map((avatar) {
          final isSelected = avatar == selected;
          return GestureDetector(
            onTap: () => onSelected(avatar),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                shape: BoxShape.circle,
                border: AppStyles.border(),
                boxShadow: isSelected
                    ? AppStyles.shadow(offset: const Offset(3, 3))
                    : null,
              ),
              padding: const EdgeInsets.all(6),
              child: ClipOval(
                child: Image.asset(
                  avatar,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person_rounded, color: AppColors.ink),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
