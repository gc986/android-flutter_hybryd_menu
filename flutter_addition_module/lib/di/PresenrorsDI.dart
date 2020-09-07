import 'package:flutteradditionmodule/presenters/settings_screen_presenter.dart';
import 'package:kiwi/kiwi.dart';

class RegPresenters{
  RegPresenters(){
    KiwiContainer container = KiwiContainer();
    container.registerSingleton((container) => SettingsScreenPresenter());
  }
}