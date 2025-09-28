import 'package:flutter/material.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/widgets/custom_textfield.dart';
import 'package:frontend_app/widgets/custom_dropdownfield.dart';
import 'package:frontend_app/widgets/custom_datefield.dart';
import 'package:frontend_app/models/address/address.dart';
import 'package:frontend_app/providers/patientprofile_provider.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/models/person.dart';
import 'package:frontend_app/widgets/custom_flushbar.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/address_provider.dart';
import 'package:intl/intl.dart';
import 'package:frontend_app/utils/relation_utils.dart';
import 'package:frontend_app/utils/gender_utils.dart';
import 'package:frontend_app/utils/date.dart';

class AddEditPatientProfileScreen extends StatefulWidget {
  final Patientprofile? editedPatientprofile;
  const AddEditPatientProfileScreen({super.key, this.editedPatientprofile});

  @override
  State<AddEditPatientProfileScreen> createState() =>
      _AddEditPatientProfileScreenState();
}

class _AddEditPatientProfileScreenState
    extends State<AddEditPatientProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _insuranceCodeController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specificAddressController =
      TextEditingController();
  String selectedRelationship = "Tôi";

  final List<String> relationships = [
    "Tôi",
    "Vợ/Chồng",
    "Bố/Mẹ",
    "Anh/Chị/Em",
    "Con",
    "Khác",
  ];

  Future<void> initAddress(BuildContext context, String address) async {
    final parts = address.split(',').map((e) => e.trim()).toList();
    final addressProvider = context.read<AddressProvider>();

    _specificAddressController.text = parts[0];
    final wardName = parts[1];
    final districtName = parts[2];
    final provinceName = parts[3];

    // Load provinces trước (nếu chưa có)
    if (addressProvider.provinces.isEmpty) {
      await addressProvider.loadProvincesOnce();
    }

    // --- Province ---
    final province = addressProvider.provinces.firstWhere(
      (p) => p.name == provinceName,
      orElse: () => Province(code: -1, name: '', districts: []),
    );
    if (province.code == -1) return;
    addressProvider.setSelectedProvince(province);

    // --- District ---
    await addressProvider.loadDistricts(province);
    final district = addressProvider.districts.firstWhere(
      (d) => d.name == districtName,
      orElse: () => District(code: -1, name: '', wards: []),
    );
    if (district.code == -1) return;
    addressProvider.setSelectedDistrict(district);

    // --- Ward ---
    await addressProvider.loadWards(district);
    final ward = addressProvider.wards.firstWhere(
      (w) => w.name == wardName,
      orElse: () => Ward(code: -1, name: ''),
    );
    if (ward.code == -1) return;
    addressProvider.setSelectedWard(ward);
  }

  @override
  void initState() {
    super.initState();
    if (widget.editedPatientprofile != null) {
      final profile = widget.editedPatientprofile!;
      _fullNameController.text = profile.person.fullName;
      _dobController.text = formatDate(profile.person.dateOfBirth);
      _genderController.text = convertGenderBack(profile.person.gender);
      _idCardController.text = profile.idCard;
      _insuranceCodeController.text = profile.insuranceCode;
      _phoneController.text = profile.person.phone ?? '';
      selectedRelationship = convertRelationshipBack(profile.relation);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initAddress(context, profile.person.address);
      });
    } else {
      context.read<AddressProvider>().loadProvincesOnce();
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _idCardController.dispose();
    _insuranceCodeController.dispose();
    _phoneController.dispose();
    _specificAddressController.dispose();
    super.dispose();
  }

  void _handelSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Gather all the input data
      final fullName = _fullNameController.text;
      final dateOfBirth = _dobController.text;
      final gender = _genderController.text;
      final idCard = _idCardController.text;
      final insuranceCode = _insuranceCodeController.text;
      final phone = _phoneController.text;
      final specificAddress = _specificAddressController.text;
      final addressProvider = context.read<AddressProvider>();
      final selectedProvince = addressProvider.selectedProvince;
      final selectedDistrict = addressProvider.selectedDistrict;
      final selectedWard = addressProvider.selectedWard;
      final province = selectedProvince?.name ?? '';
      final district = selectedDistrict?.name ?? '';
      final ward = selectedWard?.name ?? '';
      final address =
          '$specificAddress, ${ward.isNotEmpty ? "$ward, " : ""}${district.isNotEmpty ? "$district, " : ""}$province';
      // Create a Patientprofile object
      final person = Person(
        fullName: fullName,
        dateOfBirth: DateFormat('dd/MM/yyyy').parse(dateOfBirth),
        gender: convertGender(gender),
        address: address,
        phone: phone,
      );
      selectedRelationship = convertRelationship(selectedRelationship);
      final newProfile = Patientprofile(
        patientProfileId: "",
        relation: selectedRelationship,
        idCard: idCard,
        insuranceCode: insuranceCode,
        person: person,
        accountId: "",
      );
      if (widget.editedPatientprofile == null) {
        context
            .read<PatientprofileProvider>()
            .addPatientprofile(newProfile)
            .then((response) {
          if (!mounted) return;
          CustomFlushbar.show(
            context,
            status: response.status,
            message: response.message,
          );
        });
      } else {
        final updateProfile = Patientprofile(
          patientProfileId: widget.editedPatientprofile!.patientProfileId,
          relation: newProfile.relation,
          idCard: newProfile.idCard,
          insuranceCode: newProfile.insuranceCode,
          person: newProfile.person,
          accountId: widget.editedPatientprofile!.accountId,
        );
        context
            .read<PatientprofileProvider>()
            .updatePatientprofile(updateProfile)
            .then((response) {
          if (!mounted) return;
          CustomFlushbar.show(
            context,
            status: response.status,
            message: response.message,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.editedPatientprofile == null
              ? 'Thêm hồ sơ bệnh nhân'
              : 'Cập nhật hồ sơ bệnh nhân',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_as_outlined, color: Colors.white),
            onPressed: () {
              _handelSubmit();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.lightBlue[50],
            padding: const EdgeInsets.all(8.0),
            height: 80,
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: AppColors.secondaryBlue,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: const Text(
                    'Vui lòng cung cấp thông tin chính xác để được hỗ trợ y tế tốt nhất.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.secondaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[200],
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thông tin chung',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _fullNameController,
                              label: "Họ và tên",
                              hintText: "Vui lòng nhập họ và tên",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Họ và tên không được để trống";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomDateField(
                              controller: _dobController,
                              label: "Ngày sinh",
                              hintText: "dd/mm/yyyy",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Ngày sinh không được để trống";
                                }
                                // Thêm kiểm tra định dạng ngày tháng nếu cần
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Giới tính',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: ['Nam', 'Nữ', 'Khác'].map((gender) {
                                return SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<String>(
                                        value: gender,
                                        groupValue: _genderController.text,
                                        onChanged: (value) {
                                          setState(() {
                                            _genderController.text =
                                                value ?? "";
                                          });
                                        },
                                      ),
                                      Text(gender),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _idCardController,
                              label: "Mã định danh/ CCCD",
                              hintText: "Vui lòng nhập mã định danh/ CCCD",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Mã định danh/ CCCD không được để trống";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _insuranceCodeController,
                              label: "Mã bảo hiểm y tế",
                              hintText: "Vui lòng nhập mã bảo hiểm y tế",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Mã bảo hiểm y tế không được để trống";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _phoneController,
                              label: "Số điện thoại",
                              hintText: "Vui lòng nhập số điện thoại",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Số điện thoại không được để trống";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            //Radio buttons for relation
                            const Text(
                              'Mối quan hệ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: relationships.map((relation) {
                                return SizedBox(
                                  width: 140,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<String>(
                                        value: relation,
                                        groupValue: selectedRelationship,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedRelationship = value ?? "";
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: Text(
                                          relation,
                                          style: TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Địa chỉ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Province
                            Consumer<AddressProvider>(
                              builder: (context, addressProvider, child) {
                                final provinces = addressProvider.provinces;
                                final districts = addressProvider.districts;
                                final wards = addressProvider.wards;
                                final selectedProvince =
                                    addressProvider.selectedProvince;
                                final selectedDistrict =
                                    addressProvider.selectedDistrict;
                                final selectedWard =
                                    addressProvider.selectedWard;

                                return Column(
                                  children: [
                                    CustomDropdownField<Province>(
                                      label: "Tỉnh/Thành phố",
                                      hintText: "Vui lòng chọn Tỉnh/Thành phố",
                                      value: selectedProvince,
                                      items: provinces,
                                      itemLabel: (p) => p.name,
                                      onChanged: (value) {
                                        if (value != null) {
                                          addressProvider
                                              .setSelectedProvince(value);
                                          addressProvider.loadDistricts(value);
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return "Tỉnh/Thành phố không được để trống";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    // District
                                    CustomDropdownField<District>(
                                      label: "Quận/Huyện",
                                      hintText: "Vui lòng chọn Quận/Huyện",
                                      value: selectedDistrict,
                                      items: districts,
                                      itemLabel: (d) => d.name,
                                      onChanged: (value) {
                                        if (value != null) {
                                          addressProvider
                                              .setSelectedDistrict(value);
                                          addressProvider.loadWards(value);
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return "Quận/Huyện không được để trống";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    // Ward
                                    CustomDropdownField<Ward>(
                                      label: "Phường/Xã",
                                      hintText: "Vui lòng chọn Phường/Xã",
                                      value: selectedWard,
                                      items: wards,
                                      itemLabel: (w) => w.name,
                                      onChanged: (value) {
                                        if (value != null) {
                                          addressProvider
                                              .setSelectedWard(value);
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return "Phường/Xã không được để trống";
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _specificAddressController,
                              label: "Địa chỉ cụ thể",
                              hintText: "Vui lòng nhập địa chỉ cụ thể",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Địa chỉ cụ thể không được để trống";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _handelSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              widget.editedPatientprofile == null
                  ? 'Thêm hồ sơ'
                  : 'Cập nhật hồ sơ',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
