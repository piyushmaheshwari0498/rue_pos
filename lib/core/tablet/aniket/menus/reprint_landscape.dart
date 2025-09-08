
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import '../../../../utils copy/ui_utils/text_styles/custom_text_style.dart';

class ReprintLandscape extends StatefulWidget {
  const ReprintLandscape({super.key});

  @override
  State<ReprintLandscape> createState() => _ReprintState();
}

class _ReprintState extends State<ReprintLandscape> {
  String _selectedDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 100.0, left: 50),
          child: Container(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.lightBlue,
                              blurRadius: 5.0,
                            ),
                          ]),
                      child: TextButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2015, 3, 5),
                              maxTime: DateTime(2110, 6, 7), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                            String splitDate = '$date';
                            // splitDate.split(' ');
                            setState(() {
                              _selectedDate = splitDate.split(' ')[0];
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Text('Select Date',
                            style: getTextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red[200],
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.redAccent,
                              blurRadius: 5.0,
                            ),
                          ]),
                      child: TextButton(
                        onPressed: () {},
                        child: Text('Reprint',
                            style: getTextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    if (_selectedDate != '')
                      Text(
                        'Selected Date :  $_selectedDate',
                        style: getTextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.w600),
                      ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  // dateTimePickerWidget(BuildContext context) {
  //   return DatePicker.showDatePicker(
  //     context,
  //     dateFormat: 'dd MMMM yyyy HH:mm',
  //     initialDateTime: DateTime.now(),
  //     minDateTime: DateTime(2000),
  //     maxDateTime: DateTime(3000),
  //     onMonthChangeStartWithFirstDate: true,
  //     onConfirm: (dateTime, List<int> index) {
  //       DateTime selectdate = dateTime;
  //       final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
  //       print(selIOS);
  //     },
  //   );
  // }
}
