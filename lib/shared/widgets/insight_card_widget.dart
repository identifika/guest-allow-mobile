import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guest_allow/configs/themes/main_color.dart';

class InsightCard extends StatelessWidget {
  final String title;
  final TabController? controller;
  final String subtitle;
  final bool subtitleSmall;
  final bool isLoading;
  final int index;
  final String subtitle2;
  final List<String> labels;
  final void Function()? onInfoTap;
  final int initialIndex;
  final void Function(int)? onTabChanged;
  final bool tabBarVisible;
  final FontWeight? titleFontWeight;

  const InsightCard({
    super.key,
    required this.controller,
    required this.title,
    this.subtitle = '',
    this.subtitle2 = '',
    required this.labels,
    this.onInfoTap,
    this.index = 0,
    this.onTabChanged,
    this.titleFontWeight = FontWeight.w400,
    required this.tabBarVisible,
    this.subtitleSmall = false,
    this.isLoading = false,
  }) : initialIndex = 0;

  const InsightCard.simple({
    super.key,
    required this.title,
    this.initialIndex = 0,
    this.subtitle = '',
    this.index = 0,
    this.subtitle2 = '',
    required this.labels,
    this.subtitleSmall = false,
    this.onInfoTap,
    this.onTabChanged,
    this.titleFontWeight = FontWeight.w600,
    required this.tabBarVisible,
    this.isLoading = false,
  }) : controller = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.fromLTRB(30.w, 15.w, 30.w, 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 78, 83, 164 - (index * 30)),
            MainColor.primary,
            // Color.fromARGB(255, 26, 168, 158 - (index * 30)),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title.isNotEmpty) ...[
                    Container(
                      constraints: BoxConstraints(maxWidth: 0.6.sw),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: titleFontWeight,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 5.w),
                  if (subtitle.isNotEmpty)
                    Row(children: [
                      Text(
                        subtitle,
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  color: Colors.white,
                                  fontSize: subtitleSmall ? 14.sp : 20.sp,
                                ),
                      ),
                      SizedBox(width: 7.w),
                      Text(
                        subtitle2,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ]),
                ],
              ),
              if (onInfoTap != null) ...[
                const Spacer(),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: onInfoTap,
                    splashRadius: 20.w,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.info, size: 20.w, color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 10.w),
          if (labels.isNotEmpty)
            ...Conditional.list(
              context: context,
              conditionBuilder: (context) => tabBarVisible,
              widgetBuilder: (context) => [
                Material(
                  color: Colors.transparent,
                  child: DefaultTabController(
                    length: labels.length,
                    initialIndex: initialIndex,
                    child: TabBar(
                      isScrollable: labels.length > 3,
                      controller: controller,
                      indicatorColor: Colors.white,
                      dividerColor: Colors.transparent,
                      indicatorWeight: 3.h,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: labels.length > 3
                          ? const EdgeInsets.symmetric(
                              horizontal: 15,
                            ).r
                          : EdgeInsets.zero,
                      onTap: onTabChanged,
                      tabs: labels.map((label) {
                        return Tab(
                          height: 46.w,
                          child: Text(
                            label,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 10.w),
              ],
              fallbackBuilder: (context) => [SizedBox(height: 40.w)],
            ),
        ],
      ),
    );
  }
}
