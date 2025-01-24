import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/components/water_tile.dart';
import 'package:water_intake/data/water_data.dart';
import 'package:water_intake/model/water_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final amountController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    await Provider.of<WaterData>(context, listen: false)
        .getWater()
        .then((waters) => {
              if (waters.isNotEmpty)
                {
                  setState(() {
                    _isLoading = false;
                  })
                }
              else
                {
                  setState(() {
                    _isLoading = true;
                  })
                }
            });
  }

  void saveWater() async {
    Provider.of<WaterData>(context, listen: false).addWater(WaterModel(
        amount: double.parse(amountController.text.toString()),
        dateTime: DateTime.now(),
        unit: 'ml'));

    if (!context.mounted) {
      return; //if the widget is not mounted, dont do anything
    }
    clearWater();
  }

  void addWater() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add Water'),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Add water to your daily intake'),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Amount'),
                  )
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => {Navigator.pop(context)},
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    saveWater();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          elevation: 4,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.map),
              onPressed: () {},
            )
          ],
          title: const Text('Water Intake'),
        ),
        body: !_isLoading
            ? ListView.builder(
                itemCount: value.waterDataList.length,
                itemBuilder: (context, index) {
                  final waterModel = value.waterDataList[index];
                  return WaterTile(waterModel: waterModel);
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        floatingActionButton: FloatingActionButton(
          onPressed: addWater,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void clearWater() {
    amountController.clear();
  }
}
