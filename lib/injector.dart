import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

final getItInjector = GetIt.instance;

void init() {
  getItInjector.registerLazySingleton(() => ImagePicker());
}
