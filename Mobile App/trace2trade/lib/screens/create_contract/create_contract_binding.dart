import 'package:get/get.dart';
import 'package:trace2trade/screens/create_contract/create_contract_controller.dart';

class CreateContractBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateContractController>(
      () => CreateContractController(),
      fenix: true,
    );
  }
}