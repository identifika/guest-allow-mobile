import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

abstract class BaseEditParticipantsController<T> extends GetxController {
  Rx<UIState<List<T>>> participantsState = UIState<List<T>>.idle().obs;

  TextEditingController searchController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController photoController = TextEditingController();

  late String eventId;

  List<T> selectedParticipants = [];
  List<T> participants = [];
  List<String> idSelectedParticipants = [];
  XFile? imageFile;

  void callback() async {
    Get.back(result: selectedParticipants);
  }

  bool hasEditedData(List<T> participants, List<T> selectedParticipants);

  bool isSelected(String participantId) {
    return idSelectedParticipants.contains(participantId);
  }

  void selectParticipant(T data);

  void searchParticipant(String keyword);

  void dialogAddParticipant(BuildContext context);

  Future<void> addNewParticipant();

  Future<void> deleteParticipant(String participantId);
}
