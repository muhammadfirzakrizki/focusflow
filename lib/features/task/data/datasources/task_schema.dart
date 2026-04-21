import 'package:powersync/powersync.dart';

const mySchema = Schema([
  Table('tasks', [
    Column.text('title'),
    Column.text('description'),
    Column.integer('duration'),
    Column.integer('is_done'),
    Column.text('created_at'),
  ]),
]);
