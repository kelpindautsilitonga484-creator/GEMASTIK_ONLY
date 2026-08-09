class PassengerProfileModel {
  final String name;
  final String email;
  final String phoneNumber;

  const PassengerProfileModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  PassengerProfileModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
  }) {
    return PassengerProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
