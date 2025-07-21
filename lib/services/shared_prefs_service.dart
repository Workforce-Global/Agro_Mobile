import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const _keyOnboardingDone = 'onboarding_done';
  static const _keyFirstName = 'first_name';
  static const _keyLastName = 'last_name';

  late final SharedPreferences _prefs;
  SharedPrefsService._();

  static final SharedPrefsService _instance = SharedPrefsService._();
  static SharedPrefsService get instance => _instance;

  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  // Onboarding
  bool get isOnboardingDone => _prefs.getBool(_keyOnboardingDone) ?? false;
  Future<void> setOnboardingDone() => _prefs.setBool(_keyOnboardingDone, true);

  // User names
  String get firstName => _prefs.getString(_keyFirstName) ?? '';
  String get lastName  => _prefs.getString(_keyLastName)  ?? '';
  Future<void> cacheNames(String f, String l) async {
    await _prefs.setString(_keyFirstName, f);
    await _prefs.setString(_keyLastName , l);
  }

  Future<void> clear() async => _prefs.clear();
}
