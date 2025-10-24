import 'package:flutter/material.dart';
import 'package:frontend_app/models/medicalresult.dart';
import 'package:frontend_app/providers/doctorreview_provider.dart';
import 'package:frontend_app/utils/date_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/widgets/custom_flushbar.dart';
import 'package:provider/provider.dart';
import 'doctorreview_dialog.dart';

class CardMedicalResult extends StatelessWidget {
  const CardMedicalResult({super.key, required this.medicalResult});

  final MedicalResult medicalResult;

  @override
  Widget build(BuildContext context) {
    final doctorName =
        medicalResult.appointment?.doctorService?.doctor?.person.fullName ??
            '--';
    final serviceName =
        medicalResult.appointment?.doctorService?.service?.name ?? '--';
    final appointmentDate =
        medicalResult.appointment?.schedule?.workday ?? DateTime.now();
    final doctorId =
        medicalResult.appointment?.doctorService?.doctor?.doctorId ?? '';
    final appointmentId = medicalResult.appointment?.appointmentId ?? '';

    void _handleShowDoctorReviewDialog(
      BuildContext context,
    ) async {
      final data = await showDialog(
        context: context,
        builder: (context) {
          return DoctorReviewDialog();
        },
      );
      if (data != null) {
        if (!context.mounted) return;
        final response =
            await context.read<DoctorreviewProvider>().createDoctorReview(
                  doctorId: doctorId,
                  appointmentId: appointmentId,
                  rating: data['rating'],
                  comment: data['comment'],
                );
        if (!context.mounted) return;
        await CustomFlushbar.show(
          context,
          message: response.message,
          status: response.status,
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ngày khám
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.calendar,
                color: Colors.blue,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                formatDate(appointmentDate),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bác sĩ
          _buildInfoRow(
            icon: FontAwesomeIcons.userDoctor,
            label: 'Bác sĩ:',
            value: doctorName,
          ),
          // Dịch vụ
          _buildInfoRow(
            icon: FontAwesomeIcons.stethoscope,
            label: 'Dịch vụ:',
            value: serviceName,
          ),

          // Chuẩn đoán
          _buildInfoRow(
            icon: FontAwesomeIcons.notesMedical,
            label: 'Chuẩn đoán:',
            value: medicalResult.diagnosis ?? '--',
          ),

          // Đơn thuốc
          _buildInfoRow(
            icon: FontAwesomeIcons.prescriptionBottleMedical,
            label: 'Đơn thuốc:',
            value: medicalResult.prescription ?? '--',
          ),

          // Ghi chú
          _buildInfoRow(
            icon: FontAwesomeIcons.noteSticky,
            label: 'Ghi chú:',
            value: medicalResult.notes ?? '--',
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisSize: MainAxisSize.min, // chỉ đủ cho hai nút
            children: [
              // 🔹 Nút Đánh giá bác sĩ
              ElevatedButton.icon(
                onPressed: () {
                  _handleShowDoctorReviewDialog(context);
                },
                icon: const Icon(
                  Icons.star_rate,
                  size: 18,
                  color: Colors.orange,
                ),
                label: const Text(
                  'Đánh giá bác sĩ',
                  style: TextStyle(fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(width: 10), // khoảng cách giữa 2 nút
              // 🔹 Nút Xem chi tiết
              ElevatedButton(
                onPressed: () {
                  // TODO: Xử lý khi nhấn nút "Xem chi tiết"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.blue),
                  ),
                ),
                child: Text('Xem chi tiết', style: TextStyle(fontSize: 15)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: '$label '),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
