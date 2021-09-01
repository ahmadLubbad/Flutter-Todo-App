import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/modules/archive_tasks/archive_tasks_screen.dart';
import 'package:untitled/modules/done_tasks/done_tasks_screen.dart';
import 'package:untitled/modules/new_tasks/new_tasks_screen.dart';
import 'package:untitled/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(AppInitialState());
  static AppCubit get(context)=>BlocProvider.of(context);


  int currentIndex = 0;

  List<Widget> screen = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];

  List<String> titels = [
    'NEW TASKS',
    'FINISHED TASKS',
    'ARCHIVE TASKS',
  ];
  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }


  Database database;
  List<Map>newTasks=[];
  List<Map>doneTasks=[];
  List<Map>archivedTasks=[];


  void createDatabase()  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database created');
        //id integer
        //title string
        //date string
        //time string
        //status string

        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table is creating');
        }).catchError((error) {
          print('error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('Database opened');
      },
    ).then((value){
      database=value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  })async {
  await database.transaction((txn) {
      txn.rawInsert
        (
          'INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","new")'

      ) .then((value) {
        
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);

      }).catchError((error) {
        print('error when Insert New Record ${error.toString()}');
      });
      return null;
    });
  }

   getDataFromDatabase(database){

    newTasks=[];
    doneTasks=[];
    archivedTasks=[];

    emit(AppGetDatabaseLoadingState());

     database.rawQuery('SELECT * FROM tasks').then((value){

       value.forEach((element) {
         if(element['status']=='new')
           newTasks.add(element);
         else if(element['status']=='done')
           doneTasks.add(element);
         else archivedTasks.add(element);
       });
       
       emit(AppGetDatabaseState());

     });


  }

  void updateData({
  @required String status,
  @required int id,
})async
  {

     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',

        ['$status', id]//list of value
    ).then((value){

       getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
     });
  }

  void DeleteData({
    @required int id,
  })async
  {

    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value){

      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShow = false;
  IconData fabIcon=Icons.edit;

  void ChangeBottomSheerState({
    @required bool isShow,
    @required IconData icon,
}){
    isBottomSheetShow=isShow;
    fabIcon=icon;
    emit(AppChangeBottomSheetBarState());
  }
}