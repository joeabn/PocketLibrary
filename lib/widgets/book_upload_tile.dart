import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookUploadTile extends StatelessWidget {
  // ignore: public_member_api_docs
  const BookUploadTile({
    Key? key,
    required this.task,
    required this.onDismissed,
    required this.title,
  }) : super(key: key);

  /// The [UploadTask].
  final UploadTask task;
  final String title;

  /// Triggered when the user dismisses the task from the list.
  final VoidCallback onDismissed;

  /// Triggered when the user presses the "link" button on a completed upload task.

  /// Displays the current transferred bytes of the task.
  double _bytesTransferred(TaskSnapshot snapshot) {
    return snapshot.bytesTransferred / snapshot.totalBytes;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (
        BuildContext context,
        AsyncSnapshot<TaskSnapshot> asyncSnapshot,
      ) {
        Widget? subtitle = const Text('---');
        TaskSnapshot? snapshot = asyncSnapshot.data;
        TaskState? state = snapshot?.state;

        if (asyncSnapshot.hasError) {
          if (asyncSnapshot.error is FirebaseException &&
              // ignore: cast_nullable_to_non_nullable
              (asyncSnapshot.error as FirebaseException).code == 'canceled') {
            subtitle = const Text('Upload canceled.');
          } else {
            // ignore: avoid_print
            print(asyncSnapshot.error);
            subtitle = const Text('Something went wrong.');
          }
        } else if (snapshot != null) {
          subtitle = Text("Uploading...");
        }

        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: ($) => onDismissed(),
          child: Container(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(title),
                    subtitle: state == TaskState.success ? null : subtitle,
                    leading: CircularProgressIndicator(
                        value: _bytesTransferred(task.snapshot)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (state == TaskState.running)
                          IconButton(
                            icon: const Icon(Icons.pause),
                            onPressed: task.pause,
                          ),
                        if (state == TaskState.running ||
                            state == TaskState.paused)
                          IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: task.cancel,
                          ),
                        if (state == TaskState.paused)
                          IconButton(
                            icon: const Icon(Icons.file_upload),
                            onPressed: task.resume,
                          ),
                        if (state == TaskState.canceled ||
                            state == TaskState.error)
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: onDismissed,
                          ),
                      ],
                    ),
                  ))),
        );
      },
    );
  }
}
