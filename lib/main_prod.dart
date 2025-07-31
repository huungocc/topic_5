import 'package:phase_5/flavors/flavor_config.dart';
import 'package:phase_5/main_common.dart';

void main() {
  mainCommon(flavor: Flavor.prod, baseUrl: 'https://prod.api.com', name: 'Prod');
}