import 'package:get/get.dart';
import 'package:guest_allow/modules/features/event/models/responses/each_date_total_event.response.dart';
import 'package:guest_allow/modules/features/event/models/responses/my_joined_event.response.dart';
import 'package:guest_allow/modules/features/event/repositories/event.repository.dart';
import 'package:guest_allow/utils/enums/api_status.enum.dart';
import 'package:guest_allow/utils/helpers/api_status.helper.dart';
import 'package:guest_allow/utils/states/ui_state_model/ui_state_model.dart';

class EventController extends GetxController {
  static EventController get to => Get.find();

  final EventRepository _eventRepository = EventRepository();

  Rx<UIState<MetaMyJoinedEvent>> userJoinedEventState =
      const UIState<MetaMyJoinedEvent>.idle().obs;
  Rx<UIState<MetaMyJoinedEvent>> userAsReceptionistState =
      const UIState<MetaMyJoinedEvent>.idle().obs;
  Rx<UIState<List<DatumEventTotal>>> eachDateTotalEventState =
      const UIState<List<DatumEventTotal>>.idle().obs;
  List<DatumEventTotal> eachDateTotalEvent = [];

  DateTime selectedDate = DateTime.now();
  late DateTime startDate;
  late DateTime endDate;

  void changeSelectedDate(DateTime date) {
    selectedDate = date;
    fetchUserJoinedEvent(date);
    fetchUserAsReceptionist(date);
    update(['calendar']);
  }

  Future<void> fetchUserJoinedEvent(DateTime startDate) async {
    userJoinedEventState.value = const UIState<MetaMyJoinedEvent>.loading();

    DateTime endDate = startDate.add(const Duration(days: 1));

    MyJoinedEventResponse response = await _eventRepository.getMyJoinedEvent(
      startDate: startDate,
      endDate: endDate,
      limit: 1,
    );

    if (ApiStatusHelper.getApiStatus(response.statusCode ?? 0) ==
        ApiStatusEnum.success) {
      if (response.data?.data?.isNotEmpty ?? false) {
        userJoinedEventState.value = UIState.success(data: response.data!);
      } else {
        userJoinedEventState.value = const UIState.empty();
      }
    } else {
      userJoinedEventState.value =
          UIState.error(message: response.message ?? 'Something went wrong');
    }
  }

  Future<void> fetchUserAsReceptionist(DateTime startDate) async {
    userAsReceptionistState.value = const UIState<MetaMyJoinedEvent>.loading();

    DateTime endDate = startDate.add(const Duration(days: 1));

    MyJoinedEventResponse response = await _eventRepository.getMyJoinedEvent(
      startDate: startDate,
      endDate: endDate,
      limit: 1,
      isReceptionist: true,
    );

    if (ApiStatusHelper.getApiStatus(response.statusCode ?? 0) ==
        ApiStatusEnum.success) {
      if (response.data?.data?.isNotEmpty ?? false) {
        userAsReceptionistState.value = UIState.success(data: response.data!);
      } else {
        userAsReceptionistState.value = const UIState.empty();
      }
    } else {
      userAsReceptionistState.value =
          UIState.error(message: response.message ?? 'Something went wrong');
    }
  }

  void setDateRange(DateTime date) {
    startDate = date.subtract(Duration(days: date.weekday - 1));
    endDate = date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
    fetchEachDateTotalEvent();
  }

  Future<void> fetchEachDateTotalEvent() async {
    eachDateTotalEventState.value =
        const UIState<List<DatumEventTotal>>.loading();

    EachDateTotalEventResponse response =
        await _eventRepository.getEachDateTotalEvent(
      startDate: startDate,
      endDate: endDate,
    );

    if (ApiStatusHelper.getApiStatus(response.statusCode ?? 0) ==
        ApiStatusEnum.success) {
      if (response.data?.isNotEmpty ?? false) {
        eachDateTotalEventState.value =
            UIState.success(data: response.data ?? []);
        eachDateTotalEvent = response.data ?? [];
      } else {
        eachDateTotalEventState.value = const UIState.empty();
      }
    } else {
      eachDateTotalEventState.value =
          UIState.error(message: response.message ?? 'Something went wrong');
    }
  }

  bool checkIfDateOnList(DateTime date) {
    bool isDateOnList = false;
    for (DatumEventTotal data in eachDateTotalEvent) {
      if (data.date?.day == date.day) {
        isDateOnList = true;
        break;
      }
    }
    return isDateOnList;
  }

  @override
  void onInit() {
    fetchUserJoinedEvent(selectedDate);
    fetchUserAsReceptionist(selectedDate);
    setDateRange(selectedDate);
    super.onInit();
  }
}
