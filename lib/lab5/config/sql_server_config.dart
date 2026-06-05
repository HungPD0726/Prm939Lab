class SqlServerConfig {
  const SqlServerConfig({
    required this.host,
    required this.port,
    required this.database,
    required this.username,
    required this.password,
    required this.connectionId,
    required this.ssl,
    required this.trustServerCertificate,
  });

  factory SqlServerConfig.fromEnvironment() {
    return const SqlServerConfig(
      host: String.fromEnvironment('LAB5_DB_HOST', defaultValue: '10.0.2.2'),
      port: int.fromEnvironment('LAB5_DB_PORT', defaultValue: 1433),
      database: String.fromEnvironment(
        'LAB5_DB_NAME',
        defaultValue: 'LibraryManager_V2',
      ),
      username: String.fromEnvironment('LAB5_DB_USER'),
      password: String.fromEnvironment('LAB5_DB_PASSWORD'),
      connectionId: String.fromEnvironment(
        'LAB5_DB_CONNECTION_ID',
        defaultValue: 'libraryManagerV2',
      ),
      ssl: bool.fromEnvironment('LAB5_DB_SSL', defaultValue: false),
      trustServerCertificate: bool.fromEnvironment(
        'LAB5_DB_TRUST_CERT',
        defaultValue: true,
      ),
    );
  }

  final String host;
  final int port;
  final String database;
  final String username;
  final String password;
  final String connectionId;
  final bool ssl;
  final bool trustServerCertificate;

  bool get hasCredentials => username.isNotEmpty && password.isNotEmpty;
}
