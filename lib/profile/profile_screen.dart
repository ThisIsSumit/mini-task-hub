import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_taskhub/auth/auth_service.dart';
import 'package:mini_taskhub/auth/profile_model.dart';
import 'package:mini_taskhub/services/supabase_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabaseService = SupabaseService();
  AppUser? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userData = await _supabaseService.getUserProfile();
    if (userData != null) {
      setState(() {
        _user = AppUser.fromJson(userData);
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await Provider.of<AuthService>(context, listen: false).logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2429), // Dark background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2429),
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFFDD835)),
              )
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildProfilePicture(),
                      const SizedBox(height: 16),
                      _buildNameField(),
                      const SizedBox(height: 12),
                      _buildEmailField(),

                      const SizedBox(height: 30),
                      _buildLogoutButton(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFDD835), // Yellow border color
                width: 2,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A3038),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFDD835), width: 1),
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.add_a_photo,
                color: Color(0xFFFDD835),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField({
    required String value,
    required IconData iconData,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A3038),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(iconData, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
            onPressed: onEdit,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(195, 54, 54, 54),
      ),
      child: ListTile(
        title: Text(
          _user?.fullName ?? '',
          style: TextStyle(color: Colors.white),
        ),
        leading: Icon(Icons.email_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(195, 54, 54, 54),
      ),
      child: ListTile(
        title: Text(_user?.email ?? '', style: TextStyle(color: Colors.white)),
        leading: Icon(Icons.email_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFFFDD835),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout, color: Colors.black87),
        label: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
