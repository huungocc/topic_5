import 'package:phase_5/flavors/flavor_config.dart';
import 'package:phase_5/main_common.dart';

void main() {
  mainCommon(flavor: Flavor.staging, baseUrl: 'https://staging.api.com', name: 'Staging');
}