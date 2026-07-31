// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileViewModelHash() => r'a9645e2c72ed042ff526b2785bb8d765577afbe1';

/// Holds the local user profile (name / email / avatar). `null` means the user
/// has not completed profile setup yet.
///
/// Copied from [ProfileViewModel].
@ProviderFor(ProfileViewModel)
final profileViewModelProvider =
    AutoDisposeAsyncNotifierProvider<ProfileViewModel, UserProfile?>.internal(
      ProfileViewModel.new,
      name: r'profileViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profileViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProfileViewModel = AutoDisposeAsyncNotifier<UserProfile?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
