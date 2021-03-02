class RouteNotFoundException extends Error {
  final String name;

  RouteNotFoundException(this.name);

  @override
  String toString() => "RouteNotFoundException: The route $name was not found.";
}
