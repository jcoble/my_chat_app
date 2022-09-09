import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileState {
  final AsyncValue value;

  ProfileState({
    this.value = const AsyncValue.data(null),
  });

  ProfileState copyWith({AsyncValue? value}) {
    return ProfileState(
      value: value ?? this.value,
    );
  }

  bool get isLoading => value.isLoading;

  @override
  String toString() {
    return 'ProfileState(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
