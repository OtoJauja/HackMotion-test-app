import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hack_motion_test/data/swing_data.dart';
import 'package:hack_motion_test/models/swing_capture.dart';
import 'package:hack_motion_test/pages/inspection_page.dart';

// Main home screen that displays a list of swings
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: [
          // Restore button for reloading the swings for testing - DEV TOOL
          IconButton(
            icon: Icon(Icons.restore),
            onPressed: () => context.read<SwingData>().restoreSwings(),
          )
        ],
      ),
      // Listens to the current list of swings from the Cubit
      body: BlocBuilder<SwingData, List<SwingCapture>>(
        builder: (context, swings) {
          // If no swings are available show message
          if (swings.isEmpty) {
            return Center(child: Text('No swings available.'));
          }
          // Display swings in a list
          return ListView.separated(
            itemCount: swings.length,
            separatorBuilder: (_, __) => Divider(),
            padding: EdgeInsets.all(20),
            itemBuilder: (context, idx) {
              final s = swings[idx];
              return ListTile(
                title: Text(s.name),
                trailing: Icon(Icons.arrow_forward_ios),
                // Navigate to the inspection page when tapped
                onTap: () async {
                  final deleted = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InspectionPage(
                        swings: swings,
                        initialIndex: idx,
                      ),
                    ),
                  );
                  // If a swing was deleted on the inspection page reload the swing list
                  if (deleted == true) {
                    context
                        .read<SwingData>()
                        .loadSwings(); // reload if deleted
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
