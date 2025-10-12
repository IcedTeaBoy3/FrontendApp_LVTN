import 'package:flutter/material.dart';
import 'package:frontend_app/models/appointment.dart';
import 'package:frontend_app/configs/api_config.dart';
import 'package:frontend_app/utils/date_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app/utils/status_appointment_utils.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final doctor = appointment.doctorService.doctor;
    final patient = appointment.patientProfile;
    final slot = appointment.slot;
    final schedule = appointment.schedule;
    final doctorService = appointment.doctorService;
    final avatarUrl = (doctor != null &&
            doctor.person.avatar != null &&
            doctor.person.avatar!.isNotEmpty)
        ? ApiConfig.backendUrl + doctor.person.avatar!
        : null;
    return InkWell(
      onTap: () {
        context.goNamed('detailAppointment', extra: appointment);
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(30),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColorAppointment(appointment.status),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    converStatusAppointment(appointment.status),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'STT:',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      appointment.appointmentNumber.toString(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  doctor?.person.fullName ?? '--',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.blue.shade100,
                  child: ClipOval(
                    child: avatarUrl != null
                        ? Image.network(
                            avatarUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/avatar-default-icon.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/avatar-default-icon.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Giờ khám:',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                Text(
                  '${formatTime(slot.startTime)}-${formatTime(slot.endTime)} - ${formatDate(schedule.workday)}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chuyên khoa',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                Text(
                  doctorService.service?.specialty?.name ?? '--',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bệnh nhân:',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                Text(
                  patient.person.fullName,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
