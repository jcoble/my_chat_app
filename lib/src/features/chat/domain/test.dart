import 'package:freezed_annotation/freezed_annotation.dart';

part 'test.freezed.dart';
part 'test.g.dart';

@freezed
class Test with _$Test {
  factory Test(
    String id,
    String name,
  ) = _Test;

  factory Test.fromJson(Map<String, dynamic> json) => _$TestFromJson(json);
}

// @freezed
// class Test1 with _$Test1 {
//   factory Test1(String id, String name, String email, String phone) = _Test1;

//   factory Test1.fromJson(Map<String, dynamic> json) => _$Test1FromJson(json);
//   Map<String, dynamic> toJson() => _$Test1ToJson(this);
// }
