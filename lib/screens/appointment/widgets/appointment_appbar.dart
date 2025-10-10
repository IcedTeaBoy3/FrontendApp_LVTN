import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:frontend_app/widgets/confirm_dialog.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/widgets/custom_datefield.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app/providers/appointment_provider.dart';
import 'package:frontend_app/utils/date_utils.dart';

class AppointmentAppbar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onBackToHome;
  const AppointmentAppbar({super.key, required this.onBackToHome});

  @override
  State<AppointmentAppbar> createState() => _AppointmentAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppointmentAppbarState extends State<AppointmentAppbar> {
  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.read<AuthProvider>().isAuthenticated;
    return AppBar(
      leading: IconButton(
        onPressed: widget.onBackToHome,
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
        ),
      ),
      title: Center(
        child: const Text(
          'Lịch hẹn của bạn',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Stack(
            children: [
              const FaIcon(
                FontAwesomeIcons.filter,
                color: Colors.white,
                size: 20,
              ),
              if (context.watch<AppointmentProvider>().isFilters())
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () {
            if (!isAuthenticated) {
              ConfirmDialog.show(
                context,
                title: 'Xác nhận',
                content: 'Bạn cần đăng nhập để thực hiện hành động này.',
                confirmText: 'Đăng nhập',
                cancelText: 'Hủy',
                confirmColor: AppColors.primaryBlue,
                onConfirm: () {
                  context.goNamed('login');
                },
              );
              return;
            }
            _showFilters(context);
          },
        )
      ],
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true, // <-- cái này tạo luôn thanh xám nhỏ ở ngoài
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheet) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 40, // đảm bảo có cùng chiều cao với AppBar mini
                    child: Stack(
                      children: [
                        const Center(
                          child: Text(
                            "Lọc lịch khám",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            padding: EdgeInsets.zero, // bỏ padding mặc định
                            constraints:
                                const BoxConstraints(), // bỏ constraint thừa
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Trạng thái',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: context
                                      .read<AppointmentProvider>()
                                      .filterStatus ==
                                  'all'
                              ? AppColors.primaryBlue
                              : Colors.transparent),
                    ),
                    child: ListTile(
                      title: const Text('Tất cả'),
                      trailing: Radio<String>(
                        value: 'all',
                        groupValue:
                            context.read<AppointmentProvider>().filterStatus,
                        onChanged: (val) {
                          context
                              .read<AppointmentProvider>()
                              .setFilterStatus(val!);
                          setStateSheet(() {});
                        },
                      ),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: context
                                      .read<AppointmentProvider>()
                                      .filterStatus ==
                                  'pending'
                              ? AppColors.primaryBlue
                              : Colors.transparent),
                    ),
                    child: ListTile(
                      title: const Text('Chờ xác nhận'),
                      trailing: Radio<String>(
                        value: 'pending',
                        groupValue:
                            context.read<AppointmentProvider>().filterStatus,
                        onChanged: (val) {
                          context
                              .read<AppointmentProvider>()
                              .setFilterStatus(val!);
                          setStateSheet(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: context
                                      .read<AppointmentProvider>()
                                      .filterStatus ==
                                  'confirmed'
                              ? AppColors.primaryBlue
                              : Colors.transparent),
                    ),
                    child: ListTile(
                      title: const Text('Đã xác nhận'),
                      trailing: Radio<String>(
                        value: 'confirmed',
                        groupValue:
                            context.read<AppointmentProvider>().filterStatus,
                        onChanged: (val) {
                          context
                              .read<AppointmentProvider>()
                              .setFilterStatus(val!);
                          setStateSheet(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: context
                                      .read<AppointmentProvider>()
                                      .filterStatus ==
                                  'completed'
                              ? AppColors.primaryBlue
                              : Colors.transparent),
                    ),
                    child: ListTile(
                      title: const Text('Hoàn thành'),
                      trailing: Radio<String>(
                        value: 'completed',
                        groupValue:
                            context.read<AppointmentProvider>().filterStatus,
                        onChanged: (val) {
                          context
                              .read<AppointmentProvider>()
                              .setFilterStatus(val!);
                          setStateSheet(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: context
                                      .read<AppointmentProvider>()
                                      .filterStatus ==
                                  'canceled'
                              ? AppColors.primaryBlue
                              : Colors.transparent),
                    ),
                    child: ListTile(
                      title: const Text('Đã huỷ'),
                      trailing: Radio<String>(
                        value: 'cancelled',
                        groupValue:
                            context.read<AppointmentProvider>().filterStatus,
                        onChanged: (val) {
                          context
                              .read<AppointmentProvider>()
                              .setFilterStatus(val!);
                          setStateSheet(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomDateField(
                    label: 'Thời gian đặt khám',
                    hintText: 'Chọn ngày',
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    controller: TextEditingController(
                      text: context.read<AppointmentProvider>().filterDate !=
                              null
                          ? formatDate(
                              context.read<AppointmentProvider>().filterDate!)
                          : '',
                    ),
                    onDateSelected: (date) {
                      context.read<AppointmentProvider>().setFilterDate(date);
                      setStateSheet(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng chọn ngày';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(
                            Icons.replay_circle_filled_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            context.read<AppointmentProvider>().resetFilters();
                            setStateSheet(() {});
                            context.pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(
                              color: Colors.grey[400]!,
                            ),
                          ),
                          label: Text(
                            'Xoá bộ lọc',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<AppointmentProvider>()
                                .filterAppointments();
                            context.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Áp dụng',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
