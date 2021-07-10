import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

class StreamingStatus extends StatelessWidget {
  final Stream<ServiceStatus> statusStream =
      LocationPermissions().serviceStatus;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('ServiceStatus'),
      subtitle: StreamBuilder<ServiceStatus>(
        stream: statusStream,
        initialData: ServiceStatus.unknown,
        builder: (_, AsyncSnapshot<ServiceStatus> snapshot) =>
            Text('${snapshot.data}'),
      ),
    );
  }
}
