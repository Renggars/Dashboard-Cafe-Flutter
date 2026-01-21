import 'package:cafe/features/pos/data/models/setting_model.dart';
import 'package:cafe/features/pos/data/services/setting_service.dart';

abstract class SettingRepository {
  Future<SettingModel> getGlobalSettings();
}

class SettingRepositoryImpl implements SettingRepository {
  final SettingService service;
  SettingRepositoryImpl(this.service);

  @override
  Future<SettingModel> getGlobalSettings() => service.getGlobalSettings();
}
