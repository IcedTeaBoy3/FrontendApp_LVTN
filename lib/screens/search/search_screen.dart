import 'package:flutter/material.dart';
import 'package:frontend_app/screens/home/widgets/home_search.dart';
import 'package:frontend_app/widgets/doctor_card.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/doctor_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/widgets/custom_dropdownfield.dart';
import 'package:frontend_app/models/specialty.dart';
import 'package:frontend_app/models/service.dart';
import 'package:frontend_app/models/degree.dart';

class SearchScreen extends StatefulWidget {
  final String? query;
  const SearchScreen({super.key, this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    final doctorProvider = context.read<DoctorProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (doctorProvider.doctors.isEmpty) {
        doctorProvider.fetchDoctors();
      }
      doctorProvider.setQuery(widget.query ?? '');
    });
  }

  void _showFilters(BuildContext context) {
    final doctorSpecialties = context
        .read<DoctorProvider>()
        .doctors
        .expand((doc) => doc.doctorSpecialties.map((ds) => ds.specialty))
        .fold<Map<String, Specialty>>({}, (map, specialty) {
          map[specialty.specialtyId] = specialty;
          return map;
        })
        .values
        .toList();

    final services = context
        .read<DoctorProvider>()
        .doctors
        .expand((doc) => doc.doctorServices.map((ds) => ds.service))
        .fold<Map<String, Service>>({}, (map, service) {
          map[service!.serviceId] = service;
          return map;
        })
        .values
        .toList();
    final degrees = context
        .read<DoctorProvider>()
        .doctors
        .map((doc) => doc.degree)
        .whereType<Degree>()
        .fold<Map<String, Degree>>({}, (map, degree) {
          map[degree.degreeId] = degree;
          return map;
        })
        .values
        .toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40,
                child: Stack(
                  children: [
                    const Center(
                      child: Text(
                        "Bộ lọc",
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
              const SizedBox(height: 10),
              CustomDropdownField<String>(
                hintText: 'Chuyên khoa',
                label: 'Chuyên khoa',
                value: context.watch<DoctorProvider>().selectedSpecialty.isEmpty
                    ? null
                    : context.watch<DoctorProvider>().selectedSpecialty,
                itemLabel: (item) => item,
                items: doctorSpecialties.map((e) => e.name).toList(),
                onChanged: (value) {
                  // Xử lý khi chọn trạng thái
                  context.read<DoctorProvider>().setSelectedSpecialty(value);
                },
              ),
              const SizedBox(
                height: 8,
              ),
              CustomDropdownField<String>(
                hintText: 'Dịch vụ',
                value: context.watch<DoctorProvider>().selectedService.isEmpty
                    ? null
                    : context.watch<DoctorProvider>().selectedService,
                label: 'Dịch vụ',
                itemLabel: (item) => item,
                items: services.map((e) => e.name).toList(),
                onChanged: (value) {
                  // Xử lý khi chọn trạng thái
                  context.read<DoctorProvider>().setSelectedService(value);
                },
              ),
              const SizedBox(
                height: 8,
              ),
              CustomDropdownField<String>(
                hintText: 'Học vị',
                value: context.watch<DoctorProvider>().selectedDegree.isEmpty
                    ? null
                    : context.watch<DoctorProvider>().selectedDegree,
                label: 'Học vị',
                itemLabel: (item) => item,
                items: degrees.map((e) => e.title).toList(),
                onChanged: (value) {
                  // Xử lý khi chọn trạng thái
                  context.read<DoctorProvider>().setSelectedDegree(value);
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
                        context.read<DoctorProvider>().clearFilters();
                        Navigator.of(context).pop();
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
                        context.read<DoctorProvider>().filterDoctors();
                        Navigator.of(context).pop();
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
  }

  @override
  Widget build(BuildContext context) {
    final filterDoctors = context.watch<DoctorProvider>().filteredDoctors;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Tìm kiếm bác sĩ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
                if (context.read<DoctorProvider>().isFilter() == true)
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
              _showFilters(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            HomeSearch(
              hintText: 'Tìm kiếm bác sĩ, chuyên khoa, dịch vụ',
              onSearch: (newQuery) {
                context.read<DoctorProvider>().setQuery(newQuery);
              },
            ),
            if (context.read<DoctorProvider>().query.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Kết quả tìm kiếm cho: "${context.read<DoctorProvider>().query}"',
                ),
              ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filterDoctors.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final doctor = filterDoctors[index];
                return DoctorCard(
                  doctorId: doctor.doctorId,
                  name: doctor.person.fullName,
                  specialtyName: doctor.primarySpecialtyName,
                  avatar: doctor.person.avatar,
                  onTap: () {
                    context.goNamed(
                      'doctorDetail',
                      pathParameters: {'doctorId': doctor.doctorId},
                      queryParameters: {'from': 'search'},
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
