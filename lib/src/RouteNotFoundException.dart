class RouteNotFoundException extends Error {
  RouteNotFoundException(this.name);
  final String? name;

  @override
  String toString() => 'RouteNotFoundException: The route $name was not found.';
}
