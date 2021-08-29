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
  List<Map>tasks=[];

  void createDatabase() async {
    database = await openDatabase(
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
        getDataFromDatabase(database).then((value){

          tasks=value;
          print(tasks);
          emit(AppGetDatabaseState());

        });
        print('Database opened');
      },
    ).then((value){
      database=value;
      emit(AppCreateDatabaseState());
    });
  }

  Future insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  })async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
      }).catchError((error) {
        print('error when Insert New Record ${error.toString()}');
      });
      return null;
    });
  }

  Future<List <Map>> getDataFromDatabase(database)async{
    return await database.rawQuery('SELECT * FROM tasks');


  }
}