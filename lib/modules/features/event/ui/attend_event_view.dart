import 'package:flutter/material.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/shared/widgets/circle_button.dart';
import 'package:guest_allow/shared/widgets/custom_app_bar.dart';
import 'package:guest_allow/shared/widgets/custom_shimmer_widget.dart';

class AttendEventView extends StatelessWidget {
  const AttendEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(0, 0),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: _buildAppBar(context),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: MainColor.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/dummies/andreas-rasmussen-OUSa9MU4zZc-unsplash.jpg",
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Event Detail
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Event Title",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Date
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 16,
                    color: MainColor.greyTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 14,
              color: MainColor.primary,
            ),
            onTap: () => Navigator.pop(context),
          ),
          const Text(
            "Attend Event",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          CircleButton(
            icon: const Icon(
              Icons.more_horiz,
              color: MainColor.primary,
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: const Column(
                      children: [
                        ButtonBar(),
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      );
}
