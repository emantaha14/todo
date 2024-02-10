import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/sqldb.dart';
import 'package:todo/widgets/bottom_sheet_custom_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {

  SqlDb sqlDb = SqlDb();
  Future<List<Map>> readData() async {
    List<Map> response = await sqlDb.readData('SELECT * FROM TODO');
    print(response);
    return response;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await showModalBottomSheet(
            context: context,
            builder:(context) {
              return const BottomSheetCustomWidget();
            }, );
        setState(() {

        });
      },child: Icon(Icons.add)),
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.notes,size: 30,),onPressed: (){
          sqlDb.onDeleteDataBase();
        },),
        title: Text('Tasker',style: TextStyle(fontSize: 35),),
        elevation: 0,
      ),
      body:  Column(
        children: [
          Container(
            color: Colors.blue,
            width: double.infinity,
            height: 100,
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('2',style: TextStyle(color: Colors.white,fontSize: 40),),
                      Column(children: [
                        Text('OCT',style: TextStyle(color: Colors.white),),
                        Text('2024',style: TextStyle(color: Colors.white),)
                      ],),
                      Spacer(),
                      Text('Saturday',style: TextStyle(color: Colors.white,fontSize: 17),)
                    ],
                  )
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: readData(),
            builder: (BuildContext context, AsyncSnapshot<List<Map>>snapshot) {
            if(snapshot.hasData){
              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      print(snapshot.data![index]);
                      return Card(
                        child: CheckboxListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                          ),
                          value: snapshot.data![index]['isChecked'] == 1 ? true :false,
                          onChanged: (value) {

                            setState(() {
                              sqlDb.updateData('UPDATE TODO SET isChecked = ${ value == true ? 1 :0} WHERE id = ${snapshot.data![index]['id']}');
                            });
                          },
                          secondary:  IconButton(onPressed: () async {
                            int response = await sqlDb.deleteData("DELETE FROM TODO WHERE id = ${snapshot.data![index]['id']} ");
                            print(response);
                            if(response > 0){
                              setState(() {

                              });
                            }
                          }, icon: const Icon(Icons.delete,color: Colors.red,),),
                          title: Text('${snapshot.data![index]['title']}'),
                          subtitle: Text('${snapshot.data![index]['date']}'),
                          controlAffinity: ListTileControlAffinity.leading,

                        ),);
                    },),
              );
            }
            else if(snapshot.hasError){
              return Text('Error: ${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator(),);
          },)
        ],
      ),

    );
  }
}




