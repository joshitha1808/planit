// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onboardingViewModelHash() =>
    r'ec827d881eb9a3e6204c383108ca2a4b5025452e';

/// Exposes whether onboarding has already been completed and lets the UI
/// mark it as done. Persisted locally through drift.
///
/// Copied from [OnboardingViewModel].
@ProviderFor(OnboardingViewModel)
final onboardingViewModelProvider =
    AutoDisposeAsyncNotifierProvider<OnboardingViewModel, bool>.internal(
      OnboardingViewModel.new,
      name: r'onboardingViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onboardingViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OnboardingViewModel = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
