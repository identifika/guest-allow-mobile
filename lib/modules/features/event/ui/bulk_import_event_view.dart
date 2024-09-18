import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guest_allow/configs/themes/main_color.dart';
import 'package:guest_allow/modules/features/event/controllers/bulk_import_event.controller.dart';

class BulkImportEventView extends StatelessWidget {
  const BulkImportEventView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BulkImportEventController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bulk Import Event',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: MainColor.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(
                  Icons.import_export_rounded,
                  size: 100,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Import your event data in bulk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'You can import your event data in bulk by uploading a Excel file. You can download the template file below to get started.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    controller.downloadTemplate();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.download_rounded),
                        SizedBox(width: 8),
                        Text('Download Template'),
                      ],
                    ),
                  ),
                ),

                // add container as an area to drop the file
                const SizedBox(height: 48),
                GetBuilder<BulkImportEventController>(builder: (state) {
                  return Conditional.single(
                    context: context,
                    conditionBuilder: (BuildContext context) =>
                        controller.selectedFile != null,
                    widgetBuilder: (_) => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.document_scanner,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    controller.nameFile ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.removeSelectedFile();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: MainColor.danger,
                            ),
                          ),
                        ],
                      ),
                    ),
                    fallbackBuilder: (_) => GestureDetector(
                      onTap: () {
                        controller.selectFile();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
                        height: 200.h,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_rounded),
                            SizedBox(height: 8),
                            Text("Select your template file to upload")
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                const Text(
                  'Supported file types: .xls, .xlsx',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.askUploadFile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColor.primary,
                    ),
                    child: const Text('Upload File',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
