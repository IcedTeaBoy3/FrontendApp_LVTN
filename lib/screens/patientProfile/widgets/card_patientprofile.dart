import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/patientprofile_provider.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/widgets/confirm_dialog.dart';
import 'package:intl/intl.dart';

class CardPatientProfile extends StatefulWidget {
  final Patientprofile? patientprofile;
  const CardPatientProfile({super.key, this.patientprofile});

  @override
  State<CardPatientProfile> createState() => _CardPatientProfileState();
}

class _CardPatientProfileState extends State<CardPatientProfile> {
  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return Dismissible(
      key: ValueKey(
        widget.patientprofile?.patientProfileId,
      ), // key duy nhất cho mỗi item
      direction: DismissDirection.endToStart, // vuốt từ phải qua trái
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        final result = await ConfirmDialog.show(
          context,
          title: 'Xoá hồ sơ bệnh nhân',
          content: 'Bạn có chắc chắn muốn xoá hồ sơ này không?',
        );
        return result == true;
      },
      onDismissed: (direction) async {
        final response = await context
            .read<PatientprofileProvider>()
            .deletePatientprofile(widget.patientprofile!.patientProfileId)
            .then((value) {
          if (!mounted) return;
          if (value.status == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Xoá hồ sơ bệnh nhân thành công'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(value.message ?? 'Xoá hồ sơ bệnh nhân thất bại'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue[100],
              child: const Icon(
                Icons.person,
                size: 40,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.patientprofile?.person.fullName ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Ngày sinh: ${widget.patientprofile?.person.dateOfBirth != null ? formatter.format(widget.patientprofile!.person.dateOfBirth!) : ''}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 30,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
