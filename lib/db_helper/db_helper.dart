// class DBHelper{
//
//   void createDatabase() async {
//     database = await openDatabase(
//       'todo.db',
//       version: 1,
//       onCreate: (database, version) {
//         print('Database created');
//         //id integer
//         //title string
//         //date string
//         //time string
//         //status string
//
//         database
//             .execute(
//             'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
//             .then((value) {
//           print('Table is creating');
//         }).catchError((error) {
//           print('error when creating table ${error.toString()}');
//         });
//       },
//       onOpen: (database) {
//         getDataFromDatabase(database).then((value){
//           setState(() {
//             tasks=value;
//             print(tasks);
//           });
//
//         });
//         print('Database opened');
//       },
//     );
//   }
//
//   Future insertToDatabase({
//     @required String title,
//     @required String time,
//     @required String date,
//   })async {
//     return await database.transaction((txn) {
//       txn
//           .rawInsert(
//           'INSERT INTO tasks(title, date, time, status) VALUES ("$title","$date","$time","new")')
//           .then((value) {
//         print('$value inserted successfully');
//       }).catchError((error) {
//         print('error when Insert New Record ${error.toString()}');
//       });
//       return null;
//     });
//   }
//
//   Future<List <Map>> getDataFromDatabase(database)async{
//     return await database.rawQuery('SELECT * FROM tasks');
//
//
//   }
// }
//
// }