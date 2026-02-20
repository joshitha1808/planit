import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit/core/theme/theme_provider.dart';
import 'package:planit/screens/about_page.dart';
import 'package:planit/services/github_launcher.dart';
import 'package:planit/viewmodels/auth_viewmodel.dart';
import 'package:planit/views/signin_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  const HomeDrawer({super.key});

  @override
  ConsumerState<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends ConsumerState<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    final isDark = ThemeMode == ThemeMode.dark;
    final Future<UserResponse> user = ref
        .watch(authViewModelProvider.notifier)
        .user;
    return FutureBuilder<UserResponse>(
      future: user,
      builder: (context, snapshot) {
        //loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Drawer(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        //error state
        if (snapshot.hasError) {
          return Drawer(child: Text("Error: ${snapshot.error}"));
        }
        //success
        if (snapshot.hasData) {
          final user = snapshot.data!.user;
          return Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    user?.userMetadata?['username'] ?? "No name",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  accountEmail: Text(
                    user?.email ?? "No email",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  currentAccountPicture: CircleAvatar(
                    radius: 40,
                    child: ClipOval(
                      child: Image.asset(
                        "assets/profiles/default.png",
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),

                //Toggle theme
                ListTile(
                  leading: Icon(Icons.dark_mode, size: 26),
                  title: Text("Dark Mode", style: TextStyle(fontSize: 18)),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) {
                      ref.read(themeNotifierProvider.notifier).toggleTheme();
                    },
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.star, color: Colors.amber, size: 26),
                  title: Text(
                    "star us on Github",
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    GithubLauncher().openGitHub();
                  },
                ),
                Padding(padding: const EdgeInsets.only(left: 8, right: 8)),

                //About
                ListTile(
                  leading: const Icon(
                    Icons.info,
                    size: 26,
                    color: Colors.blueAccent,
                  ),
                  title: const Text("About", style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),
                //logout
                ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    size: 26,
                    color: Colors.red,
                  ),
                  title: Text("Logout", style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SigninPage()),
                    );
                  },
                ),
                Padding(padding: const EdgeInsets.only(left: 8, right: 8)),
              ],
            ),
          );
        }
        return Drawer(child: Center(child: Text("No user found")));
      },
    );
  }
}
