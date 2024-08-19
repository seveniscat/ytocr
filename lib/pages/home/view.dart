import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ytocr/pages/home/widgets/ocrview.dart';
import 'package:ytocr/pages/home/widgets/resultview.dart';

import 'index.dart';

final config = CalendarDatePicker2WithActionButtonsConfig(
  calendarType: CalendarDatePicker2Type.single,
  disableModePicker: true,
  selectedDayHighlightColor: Colors.amber[900],
  weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
  weekdayLabelTextStyle: const TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.bold,
  ),
  firstDayOfWeek: 1,
  controlsHeight: 50,
  dayMaxWidth: 25,
  animateToDisplayedMonthDate: false,
  controlsTextStyle: const TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  ),
  dayTextStyle: const TextStyle(
    color: Colors.amber,
    fontWeight: FontWeight.bold,
  ),
  disabledDayTextStyle: const TextStyle(
    color: Colors.grey,
  ),
  centerAlignModePicker: true,
  useAbbrLabelForMonthModePicker: false,
  // modePickerTextHandler: ({required monthDate, isMonthPicker}) {
  //   if (isMonthPicker ?? false) {
  //     // Custom month picker text
  //     return '${getLocaleShortMonthFormat(const Locale('en')).format(monthDate)} C';
  //   }

  //   return null;
  // },
  // firstDate: DateTime(DateTime.now().year - 2, DateTime.now().month - 1,
  //     DateTime.now().day - 5),
  // lastDate: DateTime(DateTime.now().year + 3, DateTime.now().month + 2,
  //     DateTime.now().day + 10),
  // selectableDayPredicate: (day) =>
  //     !day.difference(DateTime.now().add(const Duration(days: 3))).isNegative &&
  //     day.isBefore(DateTime.now().add(const Duration(days: 30))),
);

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  // 主视图
  Widget _buildView() {
    return Column(
      children: [
        _header(),
        Expanded(
          child: _content(),
        )
      ],
    );
  }

  Widget _datePicker(String id) {
    return GetBuilder<HomeController>(
      id: id,
      builder: (controller) {
        final vText = _getValueText(id == 'start'
            ? controller.startPickerValue
            : controller.endPickerValue);
        return TextButton(
          onPressed: () async {
            final values = await showCalendarDatePicker2Dialog(
              context: Get.context!,
              config: config,
              dialogSize: const Size(325, 370),
              borderRadius: BorderRadius.circular(15),
              value: controller.startPickerValue,
              dialogBackgroundColor: Colors.white,
            );
            if (values != null) {
              if (id == 'start') {
                controller.startPickerValue.value = values;
              }
              if (id == 'end') {
                controller.endPickerValue.value = values;
              }
              controller.update([id]);

              // ignore: avoid_print
              // print(_getValueText(
              //   config.calendarType,
              //   values,
              // ));
              // setState(() {
              //   _dialogCalendarPickerValue = values;
              // });
            }
          },
          child: Text(vText ?? '选择日期'),
        );
      },
    );
  }

  String? _getValueText(
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var value = values.isNotEmpty ? values[0] : null;

    if (value != null) {
      return value.toString().replaceAll('00:00:00.000', '');
    }
    return null;
  }

  Widget _pickerWrapper() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Row(
        children: [
          _datePicker('start'),
          const Text('-'),
          _datePicker('end'),
        ],
      ),
    );
  }

  Widget _keywordInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: 300,
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: const Center(
        child: Row(
          children: [
            Icon(Icons.search),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '输入关键字',
                    isDense: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return SizedBox(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _pickerWrapper(),
          const SizedBox(width: 20),
          _keywordInput(),
          TextButton(
              onPressed: () {
                controller.showPage(1);
              },
              child: Text('查询'))
        ],
      ),
    );
  }

  // Widget datePickerBuilder(BuildContext context,
  //         dynamic Function(DateRange) onDateRangeChanged) =>
  //     DateRangePickerWidget(
  //       doubleMonth: true,
  //       initialDateRange: null,
  //       onDateRangeChanged: (value) {},
  //     );

  Widget _content() {
    return IndexedStack(
      index: controller.pageIdx.value,
      children: const [OcrView(), ResultView()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      id: "home",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("home")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
