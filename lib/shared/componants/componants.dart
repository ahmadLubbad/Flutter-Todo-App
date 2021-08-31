import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/shared/cubit/cubit.dart';

Widget dufaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  @required Function function,
  @required String text,
}) =>
    Container(
      width: width,
      child: MaterialButton(onPressed:function,child: Text(text),),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
    );

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChang,
  Function onTap,
  bool isPassword = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressed,
  bool readonly=false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChang,
      readOnly: readonly,
      onTap: onTap,
      validator: validate,

      decoration: InputDecoration(
        labelText: label,

        prefixIcon: Icon(prefix),

        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed(),
                icon: Icon(suffix),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTasksItem(Map model, context)=>Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      CircleAvatar(
        radius: 40.0,
        child: Text('${model['time']}'),
      ),
      SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${model['title']}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '${model['date']}',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
      SizedBox(
        width: 20.0,
      ),
      IconButton(
        onPressed: ()
        {
          AppCubit.get(context).updateData
            (
            status: 'done', id: model['id'],
          );
        },
        icon:Icon(
            Icons.check_box,
          color: Colors.green,
        ),
      ),
      IconButton(
        onPressed: ()
        {
          AppCubit.get(context).updateData
            (
            status: 'archive', id: model['id'],
          );
        },
        icon:Icon(
            Icons.archive,
          color: Colors.black45,
        ),
      ),
    ],
  ),
);
