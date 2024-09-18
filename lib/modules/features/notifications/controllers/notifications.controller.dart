import 'package:get/get.dart';
import 'package:guest_allow/modules/features/notifications/models/responses/get_list_notifications_response.dart';
import 'package:guest_allow/modules/features/notifications/repositories/notifications_repository.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

class NotificationsController extends GetxController {
  static NotificationsController get to => Get.find<NotificationsController>();

  Rx<UIState<MetaNotifications>> stateNotifList =
      const UIState<MetaNotifications>.idle().obs;

  final _notificationsRepository = NotificationsRepository();

  Future<void> getListNotif({
    bool isLoadMore = false,
    bool isRefresh = false,
    String? keyword,
  }) async {
    if (isRefresh) {
      stateNotifList.value = const UIState<MetaNotifications>.loading();
    }

    GetNotificationListResponse res =
        await _notificationsRepository.getListNofif(
      page: isLoadMore
          ? (stateNotifList.value.whenOrNull(
              success: (data) => (data.currentPage ?? 0) + 1,
            ))
          : 1,
      limit: 10,
    );

    if (isLoadMore) {
      var prevData = stateNotifList.value.whenOrNull(
        success: (data) => data.data,
      );

      if (res.meta?.data?.isNotEmpty ?? false) {
        stateNotifList.value = UIState.success(
            data: (res.meta ?? MetaNotifications()).copyWith(
          data: [...(prevData ?? []), ...(res.meta?.data ?? [])],
        ));
      } else {
        stateNotifList.value = UIState.success(
          data: (res.meta ?? MetaNotifications()).copyWith(
            data: prevData,
          ),
        );
      }
    } else {
      if (res.meta?.data?.isNotEmpty ?? false) {
        stateNotifList.value =
            UIState.success(data: res.meta ?? MetaNotifications());
      } else {
        stateNotifList.value = const UIState<MetaNotifications>.empty();
      }
    }
  }

  Future<void> readNotif(String id) async {
    await _notificationsRepository.readNotif(id: id);
  }

  @override
  void onInit() {
    getListNotif(isRefresh: true);

    super.onInit();
  }
}
