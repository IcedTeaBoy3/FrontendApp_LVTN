import 'package:flutter/material.dart';
import 'package:frontend_app/providers/appointment_provider.dart';
import 'package:frontend_app/screens/appointment/widgets/appointment_card.dart';
import 'package:frontend_app/widgets/custom_loading.dart';
import 'package:provider/provider.dart';

class ApppointmentList extends StatefulWidget {
  const ApppointmentList({super.key});

  @override
  State<ApppointmentList> createState() => _ApppointmentListState();
}

class _ApppointmentListState extends State<ApppointmentList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<AppointmentProvider>()
          .fetchAppointments(page: 1, limit: 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, child) {
        if (appointmentProvider.isLoading) {
          return const CustomLoading();
        } else if (appointmentProvider.filteredAppointments.isEmpty) {
          return const Center(child: Text('Không có lịch hẹn nào.'));
        } else {
          return ListView.separated(
            itemCount: appointmentProvider.filteredAppointments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              final appointment =
                  appointmentProvider.filteredAppointments[index];
              return AppointmentCard(appointment: appointment);
            },
          );
        }
      },
    );
  }
}
