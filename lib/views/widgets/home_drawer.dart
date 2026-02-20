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
                    child: Image.asset("assets/profiles/default.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    "Appearance",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.blue,
                    ),
                  ),
                ),
                //Toggle theme
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.dark_mode, size: 26),
                      title: Text("Dark Mode", style: TextStyle(fontSize: 18)),
                      trailing: Switch(
                        value: isDark,
                        onChanged: (value) {
                          ref
                              .read(themeNotifierProvider.notifier)
                              .toggleTheme();
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    "Actions",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.blue,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Column(
                      children: [
                        // github
                        ListTile(
                          leading: Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 26,
                          ),
                          title: Text(
                            "star us on Github",
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            GithubLauncher().openGitHub();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: const Divider(height: 1),
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
                              MaterialPageRoute(
                                builder: (context) => SigninPage(),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: const Divider(height: 1),
                        ),
                        //about
                        ListTile(
                          leading: const Icon(
                            Icons.info,
                            size: 26,
                            color: Colors.blueAccent,
                          ),
                          title: const Text(
                            "About",
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () {
                            Navigator.pop(context); // Close drawer
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AboutPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Drawer(child: Center(child: Text("No user found")));
      },
    );
  }
}
