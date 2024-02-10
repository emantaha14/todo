import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/sqldb.dart';

class BottomSheetCustomWidget extends StatefulWidget {
  const BottomSheetCustomWidget({super.key});

  @override
  State<BottomSheetCustomWidget> createState() => _BottomSheetCustomWidgetState();
}

class _BottomSheetCustomWidgetState extends State<BottomSheetCustomWidget> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController titleController =  TextEditingController();

  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                  hintText: 'Date'
              ),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                IconButton(onPressed: () async {
                  selectedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030));
                  print(selectedDate.toString());
                  setState(() {});
                }, icon: const Icon(Icons.date_range_outlined,color: Colors.blue,size: 30,)),
                Text(
                    selectedDate !=null ? selectedDate.toString() : 'No Date chosen'
                ),
                Spacer(),
                TextButton(onPressed: (){}, child: const Text('Cancel',style: TextStyle(color: Colors.grey),),),
                TextButton(onPressed: () async {
                  setState(() async{
                    int response = await sqlDb.insertData('INSERT INTO TODO(title, date, isChecked) VALUES("${titleController.text}", "${selectedDate!=null? selectedDate.toString():dateController.text}", ${false})');
                    print('response =================');
                    print(response);
                    if(response>0){
                      Navigator.of(context).pop();
                    }
                  });

                }, child: const Text('Save'))
              ],
            ),

          ],
        ),
      ),
    );
  }
}
