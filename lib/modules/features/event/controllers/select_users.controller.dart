import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guest_allow/modules/features/event/models/responses/get_registered_users_response.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/global_models/user_model.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

class SelectUsersController extends GetxController {
  static SelectUsersController get to => Get.find();

  Rx<UIState<MetaRegisteredUsers>> usersState =
      const UIState<MetaRegisteredUsers>.idle().obs;

  TextEditingController searchController = TextEditingController();

  final EventRepository _eventRepository = EventRepository();

  List<String> idSelectedUsers = [];
  List<UserModel> selectedUsers = [];

  Future<void> getRegisteredUsers({
    bool isLoadMore = false,
    bool isRefresh = false,
    String? keyword,
  }) async {
    if (isRefresh) {
      usersState.value = const UIState<MetaRegisteredUsers>.loading();
    }

    GetRegisteredUsersResponse res = await _eventRepository.getRegisteredUsers(
      page: isLoadMore
          ? (usersState.value.whenOrNull(
              success: (data) => (data.currentPage ?? 0) + 1,
            ))
          : 1,
      limit: 10,
      keyword: keyword,
    );

    if (isLoadMore) {
      var prevData = usersState.value.whenOrNull(
        success: (data) => data.data,
      );

      if (res.meta?.data?.isNotEmpty ?? false) {
        usersState.value = UIState.success(
            data: (res.meta ?? MetaRegisteredUsers()).copyWith(
          data: [...(prevData ?? []), ...(res.meta?.data ?? [])],
        ));
      } else {
        usersState.value = UIState.success(
          data: (res.meta ?? MetaRegisteredUsers()).copyWith(
            data: prevData,
          ),
        );
      }
    } else {
      if (res.meta?.data?.isNotEmpty ?? false) {
        usersState.value =
            UIState.success(data: res.meta ?? MetaRegisteredUsers());
      } else {
        usersState.value = const UIState<MetaRegisteredUsers>.empty();
      }
    }
  }

  void selectUser(String userId) {
    if (idSelectedUsers.contains(userId)) {
      idSelectedUsers.remove(userId);
      selectedUsers.removeWhere((element) => element.id == userId);
    } else {
      idSelectedUsers.add(userId);
      selectedUsers.add(
        usersState.value.whenOrNull(
          success: (data) => data.data?.firstWhere(
            (element) => element.id == userId,
          ),
        )!,
      );
    }
    update(['users']);
  }

  bool isSelected(String userId) {
    return idSelectedUsers.contains(userId);
  }

  void callback() {
    Get.back(result: selectedUsers);
  }

  void setSelectUsers(List<UserModel> users) {
    selectedUsers = users;
    idSelectedUsers = users.map((e) => e.id ?? '').toList();
    update(['users']);
  }

  @override
  void onInit() {
    getRegisteredUsers(isRefresh: true);
    var args = Get.arguments;
    if (args != null) {
      args = args as Map;
      if (args['selectedUsers'] != null) {
        setSelectUsers(args['selectedUsers']);
      }
    }
    super.onInit();
  }
}
