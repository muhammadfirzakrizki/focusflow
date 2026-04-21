import 'package:powersync/powersync.dart';

const Schema schema = Schema([
  Table('tasks', [
    Column.text('title'),
    Column.text('description'),
    Column.integer('is_done'),
    Column.text('created_at'),
  ]),
]);
