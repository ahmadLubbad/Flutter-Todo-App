import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:untitled/modules/archive_tasks/archive_tasks_screen.dart';
// import 'package:untitled/modules/done_tasks/done_tasks_screen.dart';
// import 'package:untitled/modules/new_tasks/new_tasks_screen.dart';
import 'package:untitled/shared/componants/componants.dart';
import 'package:intl/intl.dart';
// import 'package:untitled/shared/componants/constants.dart';
import 'package:untitled/shared/cubit/cubit.dart';
import 'package:untitled/shared/cubit/states.dart';



class HomeLayout extends StatelessWidget

{


  var scaffoldKay = GlobalKey<ScaffoldState>();
  var formKay = GlobalKey<FormState>();
  bool isBottomSheetShow = false;
  IconData fabIcon=Icons.edit;
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();





  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context,AppStates state){},
          builder: (BuildContext context,AppStates state){

          AppCubit cubit = AppCubit.get(context);
          return  Scaffold(
            key: scaffoldKay,
            appBar: AppBar(
              title: Text( cubit.titels[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition:true,
              builder: (context)=> cubit.screen[cubit.currentIndex],
              fallback: (context)=> Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (isBottomSheetShow) {
                  if(formKay.currentState.validate())
                  {
                    // AppCubit.get(context).insertToDatabase(
                    //   title: titleController.text,
                    //   date: dateController.text,
                    //   time: timeController.text,
                    // ).then((value){
                    //   AppCubit.get(context).getDataFromDatabase( AppCubit.get(context).database).then((value){
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isBottomSheetShow = false;
                    //     //   fabIcon=Icons.edit;
                    //     //   tasks=value;
                    //     //   print('tasks from database : $tasks');
                    //     // });
                    //
                    //   });
                    //
                    // });
                  }
                } else {
                  scaffoldKay.currentState.showBottomSheet((context) => Container(
                    color: Colors.white70,
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: formKay,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            controller: titleController,
                            type: TextInputType.text,
                            validate: (String value){
                              if(value.isEmpty){
                                return 'title must not be empty';
                              }
                              return null;
                            },
                            label: 'Task Title',
                            prefix: Icons.title,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            controller: timeController,
                            type: TextInputType.datetime,
                            readonly: true,
                            onTap: (){
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value){
                                timeController.text=value.format(context).toString();
                                print(value.format(context));
                              });
                            },
                            validate: (String value){
                              if(value.isEmpty){
                                return 'time must not be empty';
                              }
                              return null;
                            },
                            label: 'Task Time',
                            prefix: Icons.watch_later_outlined,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            controller: dateController,
                            type: TextInputType.datetime,
                            readonly: true,
                            onTap: (){
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate:  DateTime.now(),
                                lastDate: DateTime.parse('2021-09-06'),
                              ).then((value){
                                print(DateFormat.yMMMd().format(value));
                                dateController.text=DateFormat.yMMMd().format(value);
                              });
                            },
                            validate: (String value){
                              if(value.isEmpty){
                                return 'date must not be empty';
                              }
                              return null;
                            },
                            label: 'Task Date',
                            prefix: Icons.calendar_today,
                          ),
                        ],
                      ),
                    ),
                  ),
                    elevation: 20.0,
                  ).closed.then((value){
                    isBottomSheetShow = false;
                    // setState(() {
                    //   fabIcon=Icons.edit;
                    // });
                  });
                  isBottomSheetShow = true;
                  // setState(() {
                  //   fabIcon=Icons.add;
                  // });
                }
              },
              child: Icon(fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex:  cubit.currentIndex, //لتحديد الزر المضغوط عليه
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
                print(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'TASKS',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'DONE',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'ARCHIVE',
                ),
              ],
            ),
          );
          },
      ),
    );
  }

  // Future<String> getName() async {
  //   return 'Ahmed Ali';
  // }




}

