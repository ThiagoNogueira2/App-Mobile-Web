class AppConfig {
  // Configurações do Supabase
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // Configurações do app
  static const String appName = 'App Mobile Web';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Aplicativo para gerenciamento acadêmico';
  
  // Configurações de API
  static const int apiTimeout = 30000; // 30 segundos
  static const int maxRetries = 3;
  static const String apiBaseUrl = 'https://api.example.com';
  
  // Configurações de cache
  static const int cacheExpirationHours = 24;
  static const int maxCacheSize = 50; // MB
  
  // Configurações de notificações
  static const bool enablePushNotifications = true;
  static const bool enableEmailNotifications = false;
  static const int notificationCheckInterval = 300; // 5 minutos
  
  // Configurações de UI
  static const bool enableAnimations = true;
  static const bool enableHapticFeedback = true;
  static const double defaultAnimationDuration = 300.0;
  
  // Configurações de debug
  static const bool enableDebugMode = true;
  static const bool enableLogging = true;
  static const bool enablePerformanceMonitoring = false;
  
  // Configurações de segurança
  static const bool enableBiometricAuth = false;
  static const bool enableAutoLock = true;
  static const int autoLockTimeout = 300; // 5 minutos
  
  // Configurações de sincronização
  static const bool enableAutoSync = true;
  static const int syncInterval = 900; // 15 minutos
  static const bool syncOnWifiOnly = true;
  
  // Configurações de backup
  static const bool enableAutoBackup = true;
  static const int backupInterval = 86400; // 24 horas
  static const int maxBackupFiles = 7;
  
  // Configurações de acessibilidade
  static const bool enableScreenReader = true;
  static const bool enableHighContrast = false;
  static const bool enableLargeText = false;
  
  // Configurações de idioma
  static const String defaultLanguage = 'pt_BR';
  static const List<String> supportedLanguages = ['pt_BR', 'en_US', 'es_ES'];
  
  // Configurações de tema
  static const String defaultTheme = 'light';
  static const List<String> availableThemes = ['light', 'dark', 'auto'];
  
  // Configurações de rede
  static const bool enableOfflineMode = true;
  static const int networkTimeout = 10000; // 10 segundos
  static const bool enableNetworkMonitoring = true;
  
  // Configurações de analytics
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = true;
  static const bool enableUserTracking = false;
  
  // Configurações de desenvolvimento
  static const bool enableHotReload = true;
  static const bool enableDevTools = true;
  static const bool enableMockData = true;
  
  // Configurações de teste
  static const bool enableTestMode = false;
  static const String testApiUrl = 'https://test-api.example.com';
  static const bool enableTestData = false;
  
  // Configurações de produção
  static const bool isProduction = false;
  static const String productionApiUrl = 'https://api.example.com';
  static const bool enableProductionLogging = false;
  
  // Configurações de staging
  static const bool isStaging = false;
  static const String stagingApiUrl = 'https://staging-api.example.com';
  
  // Configurações de localização
  static const String defaultCountry = 'BR';
  static const String defaultCurrency = 'BRL';
  static const String defaultTimeZone = 'America/Sao_Paulo';
  
  // Configurações de mídia
  static const int maxImageSize = 5; // MB
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  static const int imageQuality = 80; // %
  
  // Configurações de arquivo
  static const int maxFileSize = 10; // MB
  static const List<String> supportedFileFormats = ['pdf', 'doc', 'docx', 'txt'];
  static const int maxFilesPerUpload = 5;
  
  // Configurações de sessão
  static const int sessionTimeout = 3600; // 1 hora
  static const bool enableSessionRefresh = true;
  static const int refreshTokenExpiry = 604800; // 7 dias
  
  // Configurações de validação
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const bool requireSpecialChars = false;
  static const bool requireNumbers = false;
  static const bool requireUppercase = false;
  
  // Configurações de rate limiting
  static const int maxRequestsPerMinute = 60;
  static const int maxLoginAttempts = 5;
  static const int lockoutDuration = 900; // 15 minutos
  
  // Configurações de backup de dados
  static const bool enableDataBackup = true;
  static const int backupRetentionDays = 30;
  static const bool enableEncryptedBackup = true;
  
  // Configurações de sincronização de dados
  static const bool enableDataSync = true;
  static const int syncBatchSize = 100;
  static const bool enableConflictResolution = true;
  
  // Configurações de cache de imagens
  static const bool enableImageCache = true;
  static const int imageCacheSize = 100; // MB
  static const int imageCacheExpiry = 604800; // 7 dias
  
  // Configurações de compressão
  static const bool enableDataCompression = true;
  static const int compressionLevel = 6; // 0-9
  static const bool enableImageCompression = true;
} 