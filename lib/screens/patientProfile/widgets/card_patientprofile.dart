import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/utils/date_utils.dart';
import 'package:frontend_app/widgets/confirm_dialog.dart';
import 'package:frontend_app/utils/relation_utils.dart';

class CardPatientProfile extends StatelessWidget {
  final Patientprofile patientprofile;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete; // 👈 thêm callback để xử lý delete tuỳ nơi
  final bool dismissible; // 👈 cho phép bật/tắt vuốt xóa

  const CardPatientProfile({
    super.key,
    required this.patientprofile,
    this.selected = false,
    this.onTap,
    this.onDelete,
    this.dismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: selected ? Border.all(color: Colors.blue, width: 1) : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue[100],
            child: const Icon(
              FontAwesomeIcons.idCard,
              size: 40,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientprofile.person.fullName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ngày sinh: ${formatDate(patientprofile.person.dateOfBirth)}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                Text(
                  'Quan hệ: ${convertRelationshipBack(patientprofile.relation)}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
    );

    if (dismissible && onDelete != null) {
      return Dismissible(
        key: ValueKey(patientprofile.patientProfileId),
        direction: DismissDirection.endToStart,
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
        onDismissed: (_) => onDelete?.call(),
        child: InkWell(
          onTap: onTap,
          child: cardContent,
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: cardContent,
    );
  }
}
