// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider untuk akses DataSource secara global

@ProviderFor(taskDataSource)
final taskDataSourceProvider = TaskDataSourceProvider._();

/// Provider untuk akses DataSource secara global

final class TaskDataSourceProvider
    extends
        $FunctionalProvider<
          TaskLocalDataSource,
          TaskLocalDataSource,
          TaskLocalDataSource
        >
    with $Provider<TaskLocalDataSource> {
  /// Provider untuk akses DataSource secara global
  TaskDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskDataSourceHash();

  @$internal
  @override
  $ProviderElement<TaskLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskLocalDataSource create(Ref ref) {
    return taskDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskLocalDataSource>(value),
    );
  }
}

String _$taskDataSourceHash() => r'3a4743b303758eb40662bca4033528118a8be2da';

/// StreamProvider versi Riverpod 4 untuk data real-time dari PowerSync

@ProviderFor(taskListStream)
final taskListStreamProvider = TaskListStreamProvider._();

/// StreamProvider versi Riverpod 4 untuk data real-time dari PowerSync

final class TaskListStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TaskModel>>,
          List<TaskModel>,
          Stream<List<TaskModel>>
        >
    with $FutureModifier<List<TaskModel>>, $StreamProvider<List<TaskModel>> {
  /// StreamProvider versi Riverpod 4 untuk data real-time dari PowerSync
  TaskListStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskListStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskListStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<TaskModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TaskModel>> create(Ref ref) {
    return taskListStream(ref);
  }
}

String _$taskListStreamHash() => r'd833f3bca467b491c386b2d9f93a63d9ae34364d';

/// Notifier untuk mengelola state dan interaksi (CRUD)

@ProviderFor(TaskController)
final taskControllerProvider = TaskControllerProvider._();

/// Notifier untuk mengelola state dan interaksi (CRUD)
final class TaskControllerProvider
    extends $AsyncNotifierProvider<TaskController, void> {
  /// Notifier untuk mengelola state dan interaksi (CRUD)
  TaskControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskControllerHash();

  @$internal
  @override
  TaskController create() => TaskController();
}

String _$taskControllerHash() => r'c863e15fa4e65bbd2eb186d65a62cebd928d7c6e';

/// Notifier untuk mengelola state dan interaksi (CRUD)

abstract class _$TaskController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
