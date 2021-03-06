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
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();





  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context,AppStates state){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
          builder: (BuildContext context,AppStates state){

          AppCubit cubit = AppCubit.get(context);
          return  Scaffold(
            key: scaffoldKay,
            appBar: AppBar(
              title: Text( cubit.titels[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition:state is! AppGetDatabaseLoadingState,
              builder: (context)=> cubit.screen[cubit.currentIndex],
              fallback: (context)=> Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if(formKay.currentState.validate())
                  {
                    cubit.insertToDatabase
                      (
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text
                    );
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
                    cubit.ChangeBottomSheerState(isShow: false, icon: Icons.edit);
                  });
                  cubit.ChangeBottomSheerState(isShow: true, icon: Icons.add);

                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex:  cubit.currentIndex, //???????????? ???????? ?????????????? ????????
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

