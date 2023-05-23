import 'package:dtnd/=models=/response/cash_transaction_model.dart';
import 'package:dtnd/data/i_user_service.dart';
import 'package:dtnd/data/implementations/user_service.dart';
import 'package:dtnd/ui/screen/account/component/cash_transaction_component.dart';
import 'package:dtnd/ui/widget/calendar/day_input.dart';
import 'package:dtnd/ui/widget/empty_list_widget.dart';
import 'package:dtnd/utilities/time_utils.dart';
import 'package:flutter/material.dart';

class AccumulatorHistory extends StatefulWidget {
  const AccumulatorHistory({super.key});

  @override
  State<AccumulatorHistory> createState() => _AccumulatorHistoryState();
}

class _AccumulatorHistoryState extends State<AccumulatorHistory> {
  final IUserService userService = UserService();

  final List<CashTransactionHistoryModel> list = [];
  late DateTime fromDay;
  late DateTime toDay;
  late DateTime firstDay;
  late DateTime lastDay;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    fromDay = TimeUtilities.getPreviousDateTime(TimeUtilities.month(1));
    toDay = DateTime.now();
    firstDay = TimeUtilities.getPreviousDateTime(TimeUtilities.month(3));
    lastDay = toDay;
    _scrollController.addListener(_scrollListener);
    super.initState();
    getData();
  }

  Future<void> getData({int? recordPerPage}) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    final res = await userService.getHistoryContract(
        fromDay: fromDay, toDay: toDay, recordPerPage: recordPerPage);

    if ((res?.isEmpty ?? true) || res == null) {
      throw Exception('Empty history contract');
    } else {
      list.clear();
      list.addAll(res);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      getData(recordPerPage: list.length + 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: DayInput(
                color: Colors.white,
                initialDay: fromDay,
                firstDay: firstDay,
                lastDay: lastDay,
                onChanged: (value) {
                  setState(() {
                    fromDay = value;
                  });
                  getData();
                },
              ),
            ),
            const Text("    -    "),
            Expanded(
              flex: 1,
              child: DayInput(
                color: Colors.white,
                initialDay: toDay,
                firstDay: firstDay,
                lastDay: lastDay,
                onChanged: (value) {
                  setState(() {
                    toDay = value;
                  });
                  getData();
                },
              ),
            )
          ],
        ),
      ),
      const SizedBox(height: 16),
      Expanded(child: Builder(builder: (context) {
        if (list.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              EmptyListWidget(),
            ],
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: list.length + 1,
                  itemBuilder: (context, index) {
                    if (index < list.length) {
                      return CashTransactionComponent(
                        data: list.elementAt(index),
                      );
                    } else if (index == list.length && isLoading) {
                      return _buildLoader();
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          );
        }
      }))
    ]);
  }
}

Widget _buildLoader() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: const CircularProgressIndicator(),
  );
}
