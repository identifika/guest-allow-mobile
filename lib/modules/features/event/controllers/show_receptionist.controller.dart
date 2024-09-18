import 'package:get/get.dart';
import 'package:guest_allow/modules/features/event/models/responses/list_of_receptionist.response.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/modules/features/home/responses/get_popular_event.response.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

class ShowReceptionistController extends GetxController {
  static ShowReceptionistController get to => Get.find();

  RxInt selectedIndex = 0.obs;

  Rx<UIState<ReceptionistMerged>> receptionistState =
      const UIState<ReceptionistMerged>.idle().obs;
  final EventRepository _eventRepository = EventRepository();

  late EventData eventData;
  RxInt totalReceptionist = 0.obs;
  RxInt totalGuest = 0.obs;
  RxInt totalUser = 0.obs;

  Future<void> getEventReceptionists({
    bool isLoadMore = false,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      receptionistState.value = const UIState<ReceptionistMerged>.loading();
    }

    ListOfReceptionistResponse res =
        await _eventRepository.getEventReceptionists(
      id: eventData.id ?? "",
      page: isLoadMore
          ? (receptionistState.value.whenOrNull(
              success: (data) => (data.meta?.currentPage ?? 0) + 1,
            ))
          : 1,
      limit: 10,
    );

    if (ApiStatusHelper.isApiSuccess(res.statusCode ?? 0)) {
      _handleTotalParticipants(res);
    }

    if (isLoadMore) {
      var prevData = receptionistState.value.whenOrNull(
        success: (data) => data.data,
      );

      if (res.meta?.merged?.data?.isNotEmpty ?? false) {
        receptionistState.value = UIState.success(
          data: (res.meta?.merged ?? ReceptionistMerged()).copyWith(
            data: [...(prevData ?? []), ...(res.meta?.merged?.data ?? [])],
          ),
        );
      } else {
        receptionistState.value = UIState.success(
          data: (res.meta?.merged ?? ReceptionistMerged()).copyWith(
            data: prevData,
          ),
        );
      }
    } else {
      if (res.meta?.merged?.data?.isNotEmpty ?? false) {
        receptionistState.value =
            UIState.success(data: res.meta?.merged ?? ReceptionistMerged());
      } else {
        receptionistState.value = const UIState<ReceptionistMerged>.empty();
      }
    }
  }

  void _handleTotalParticipants(ListOfReceptionistResponse res) {
    totalReceptionist.value =
        (res.meta?.totalReceptionists ?? 0) + (res.meta?.totalGuests ?? 0);
    totalUser.value = res.meta?.totalReceptionists ?? 0;
    totalGuest.value = res.meta?.totalGuests ?? 0;
  }

  @override
  void onInit() {
    super.onInit();
    eventData = Get.arguments as EventData;
    getEventReceptionists();
  }
}
