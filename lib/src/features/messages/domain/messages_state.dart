import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagesState {
  final AsyncValue value;

  MessagesState({
    this.value = const AsyncValue.data(null),
  });

  MessagesState copyWith({AsyncValue? value}) {
    return MessagesState(
      value: value ?? this.value,
    );
  }

  bool get isLoading => value.isLoading;

  @override
  String toString() {
    return 'MessagesState(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessagesState && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
