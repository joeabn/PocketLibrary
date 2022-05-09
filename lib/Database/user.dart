class AppUser {
  final int? id;
  final String name;
  final String externalID;

  const AppUser({required this.name, required this.externalID, this.id});
}
