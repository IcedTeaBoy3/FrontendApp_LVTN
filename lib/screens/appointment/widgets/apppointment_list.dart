import 'package:flutter/material.dart';
import 'package:frontend_app/providers/appointment_provider.dart';
import 'package:frontend_app/screens/appointment/widgets/appointment_card.dart';
import 'package:frontend_app/widgets/custom_loading.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend_app/services/websocket_service.dart';

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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/DoctorOnline.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Text(
                  'Bạn chưa có lịch khám',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lịch khám của bạn sẽ được hiển thị tại đây.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          );
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
