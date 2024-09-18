import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/auth/modules/sign_in/controllers/sign_in.controller.dart';
import 'package:guest_allow/modules/features/main/models/event_model.dart';
import 'package:guest_allow/shared/widgets/card_this_month_event.dart';
import 'package:guest_allow/shared/widgets/custom_dialog.widget.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';

class LoginAsReceptionistSheet extends StatelessWidget {
  final SignInController state;

  const LoginAsReceptionistSheet({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.6.sh,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Masuk Sebagai Resepsionis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Masukkan kode resepsionis untuk masuk sebagai resepsionis',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: state.eventCodeController,
            onEditingComplete: () {
              FocusScope.of(context).nextFocus();
            },
            decoration: InputDecoration(
              hintText: "Event Code",
              hintStyle: const TextStyle(
                color: MainColor.black,
                fontSize: 16,
              ),
              fillColor: MainColor.lightGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: MainColor.grey,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: MainColor.primary,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: MainColor.grey,
                  width: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: state.accessCodeController,
            onEditingComplete: () {
              state.getReceptionistGuest(
                state.eventCodeController.text,
                state.accessCodeController.text,
              );
              // unfocus the text field
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              hintText: "Access Code",
              hintStyle: const TextStyle(
                color: MainColor.black,
                fontSize: 16,
              ),
              fillColor: MainColor.lightGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: MainColor.grey,
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: MainColor.primary,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: MainColor.grey,
                  width: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.receptionistGuestData == null
                  ? null
                  : () {
                      if (state.receptionistGuestData != null) {
                        if (state.receptionistGuestData!.receptionists !=
                            null) {
                          state.receiveAttende(
                              state.receptionistGuestData!.event!);
                        } else {
                          CustomDialogWidget.showDialogProblem(
                            title: 'Failed',
                            description: 'Failed to get receptionist data',
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: MainColor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Masuk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () =>
                state.receptionistGuestState.value.whenOrNull(
                  loading: () => const CustomShimmerWidget.card(
                    width: double.infinity,
                    height: 100,
                    margin: 0,
                    padding: 0,
                  ),
                  success: (data) {
                    return GestureDetector(
                      onTap: () {
                        state.setReceptionistGuestData(data);
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 12,
                            ),
                            decoration: BoxDecoration(
                              color: MainColor.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CardThisMonthEvent(
                              eventModel: EventModel.fromEventData(data.event),
                            ),
                          ),
                          // selected effect
                          Visibility(
                            visible: state.receptionistGuestData != null &&
                                state.receptionistGuestData!.event ==
                                    data.event,
                            child: Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: MainColor.info,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  "Selected",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  empty: (message) => Center(
                    child: Text(message),
                  ),
                ) ??
                const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
