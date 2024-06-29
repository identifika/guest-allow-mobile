import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/routes/main_route.dart';
import 'package:guest_allow/modules/features/auth/repositories/auth.repository.dart';
import 'package:guest_allow/modules/features/profile/models/responses/get_my_event_response.dart';
import 'package:guest_allow/modules/features/profile/repositories/profile.repository.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/utils/db/user_collection.db.dart';
import 'package:guest_allow/utils/services/local_db.service.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AuthRepository _authRepository = AuthRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  UserLocalData? user;
  Rx<UIState<MetaOfListMyEventResponse>> mineEventState =
      const UIState<MetaOfListMyEventResponse>.idle().obs;
  Rx<UIState<MetaOfListMyEventResponse>> joinedEventState =
      const UIState<MetaOfListMyEventResponse>.idle().obs;
  Rx<UIState<MetaOfListMyEventResponse>> receptionistEventState =
      const UIState<MetaOfListMyEventResponse>.idle().obs;

  Rx<UIState<Totals>> totalsState = const UIState<Totals>.idle().obs;

  TabController? tabController;

  Future<void> logout() async {
    CustomDialogWidget.showLoading();
    var response = await _authRepository.logout();
    CustomDialogWidget.closeLoading();
    if (response.statusCode == 200) {
      LocalDbService.clearLocalData();
    } else {
      CustomDialogWidget.showDialogProblem(
        description: response.message ?? 'Terjadi kesalahan',
      );
    }
  }

  Future<void> getMyEvents({
    bool isLoadMore = false,
    bool isRefresh = false,

    /// mine, joined, receptionist
    String type = 'joined',
  }) async {
    if (isRefresh) {
      switch (type) {
        case 'mine':
          mineEventState.value =
              const UIState<MetaOfListMyEventResponse>.loading();
          break;
        case 'joined':
          joinedEventState.value =
              const UIState<MetaOfListMyEventResponse>.loading();
          break;
        case 'receptionist':
          receptionistEventState.value =
              const UIState<MetaOfListMyEventResponse>.loading();
          break;
      }
    }

    ListOfMyEventsResponse response = await _profileRepository.getMyEvents(
      page: isLoadMore
          ? (type == 'mine'
              ? (mineEventState.value.whenOrNull(
                  success: (data) => (data.currentPage ?? 0) + 1,
                ))
              : type == 'joined'
                  ? (joinedEventState.value.whenOrNull(
                      success: (data) => (data.currentPage ?? 0) + 1,
                    ))
                  : (receptionistEventState.value.whenOrNull(
                      success: (data) => (data.currentPage ?? 0) + 1,
                    )))
          : 1,
      limit: 10,
      type: type,
    );

    totalsState.value = UIState.success(data: response.totals ?? Totals());

    if (isLoadMore) {
      switch (type) {
        case 'mine':
          var prevData = mineEventState.value.whenOrNull(
            success: (data) => data.data,
          );

          if (response.meta?.data?.isNotEmpty ?? false) {
            mineEventState.value = UIState.success(
                data: (response.meta ?? MetaOfListMyEventResponse()).copyWith(
              data: [...(prevData ?? []), ...(response.meta?.data ?? [])],
            ));
          } else {
            mineEventState.value = UIState.success(
              data: (response.meta ?? MetaOfListMyEventResponse()).copyWith(
                data: prevData,
              ),
            );
          }
          break;
        case 'joined':
          var prevData = joinedEventState.value.whenOrNull(
            success: (data) => data.data,
          );

          if (response.meta?.data?.isNotEmpty ?? false) {
            joinedEventState.value = UIState.success(
                data: (response.meta ?? MetaOfListMyEventResponse()).copyWith(
              data: [...(prevData ?? []), ...(response.meta?.data ?? [])],
            ));
          } else {
            joinedEventState.value = UIState.success(
              data: (response.meta ?? MetaOfListMyEventResponse()).copyWith(
                data: prevData,
              ),
            );
          }
          break;
        case 'receptionist':
          var prevData = receptionistEventState.value.whenOrNull(
            success: (data) => data.data,
          );

          if (response.meta?.data?.isNotEmpty ?? false) {
            receptionistEventState.value = UIState.success(
                data: (response.meta ?? MetaOfListMyEventResponse()).copyWith(
              data: [...(prevData ?? []), ...(response.meta?.data ?? [])],
            ));
          } else {
            receptionistEventState.value = UIState.success(
              data: (response.meta ?? MetaOfListMyEventResponse()).copyWith(
                data: prevData,
              ),
            );
          }
          break;
      }
    } else {
      if (response.meta?.data?.isNotEmpty ?? false) {
        switch (type) {
          case 'mine':
            mineEventState.value = UIState.success(
                data: response.meta ?? MetaOfListMyEventResponse());
            break;
          case 'joined':
            joinedEventState.value = UIState.success(
                data: response.meta ?? MetaOfListMyEventResponse());
            break;
          case 'receptionist':
            receptionistEventState.value = UIState.success(
                data: response.meta ?? MetaOfListMyEventResponse());
            break;
        }
      } else {
        switch (type) {
          case 'mine':
            mineEventState.value =
                const UIState<MetaOfListMyEventResponse>.empty();
            break;
          case 'joined':
            joinedEventState.value =
                const UIState<MetaOfListMyEventResponse>.empty();
            break;
          case 'receptionist':
            receptionistEventState.value =
                const UIState<MetaOfListMyEventResponse>.empty();
            break;
        }
      }
    }
  }

  void onTabChange(int index) {
    switch (index) {
      case 0:
        getMyEvents(type: 'joined');

        break;
      case 1:
        getMyEvents(type: 'mine');

        break;
      case 2:
        getMyEvents(type: 'receptionist');
        break;
    }
  }

  void dialogLogout() {
    CustomDialogWidget.showDialogChoice(
      description: 'Apakah anda yakin ingin keluar?',
      onTapPositiveButton: () async {
        await logout();
        Get.offAllNamed(MainRoute.signIn);
      },
      onTapNegativeButton: () => Get.back(),
    );
  }

  @override
  void onInit() {
    user = LocalDbService.getUserLocalDataSync();
    getMyEvents();
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }
}
