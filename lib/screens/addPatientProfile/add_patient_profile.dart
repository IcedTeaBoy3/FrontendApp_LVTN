import 'package:flutter/material.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/widgets/custom_textfield.dart';
import 'package:frontend_app/widgets/custom_dropdownfield.dart';
import 'package:frontend_app/widgets/custom_datefield.dart';
import 'package:frontend_app/services/province_service.dart';
import 'package:frontend_app/models/address/address.dart';
import 'package:frontend_app/providers/patientprofile_provider.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/models/person.dart';
import 'package:frontend_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddPatientProfile extends StatefulWidget {
  const AddPatientProfile({super.key});

  @override
  State<AddPatientProfile> createState() => _AddPatientProfileState();
}

class _AddPatientProfileState extends State<AddPatientProfile> {
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
  void _convertRelationship(String? relation) {
    switch (relation) {
      case "Tôi":
        selectedRelationship = "self";
        break;
      case "Vợ/Chồng":
        selectedRelationship = "spouse";
        break;
      case "Mẹ/Bố":
        selectedRelationship = "parent";
        break;
      case "Anh/Chị/Em":
        selectedRelationship = "sibling";
        break;
      case "Con":
        selectedRelationship = "child";
        break;
      default:
        selectedRelationship = "other";
    }
  }

  String _convertGender(String gender) {
    switch (gender) {
      case "Nam":
        return "male";
      case "Nữ":
        return "female";
      default:
        return "other";
    }
  }

  List<Province> provinces = [];
  List<District> districts = [];
  List<Ward> wards = [];

  Province? selectedProvince;
  District? selectedDistrict;
  Ward? selectedWard;
  @override
  void initState() {
    super.initState();
    _loadProvinces();
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

  Future<void> _loadProvinces() async {
    final data = await ProvinceService.getProvinces();
    setState(() => provinces = data);
  }

  Future<void> _loadDistricts(int provinceId) async {
    final data = await ProvinceService.getDistricts(provinceId);
    setState(() {
      districts = data;
      wards = [];
      selectedDistrict = null;
      selectedWard = null;
    });
  }

  void _loadWards(int districtId) async {
    final data = await ProvinceService.getWards(districtId);
    setState(() {
      wards = data;
      selectedWard = null;
    });
  }

  void _handleCreateProfile() {
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
      final province = selectedProvince?.name ?? '';
      final district = selectedDistrict?.name ?? '';
      final ward = selectedWard?.name ?? '';
      final address =
          '$specificAddress, ${ward.isNotEmpty ? "$ward, " : ""}${district.isNotEmpty ? "$district, " : ""}$province';
      // Create a Patientprofile object
      final person = Person(
        fullName: fullName,
        dateOfBirth: dateOfBirth.isNotEmpty
            ? DateFormat('dd/MM/yyyy').parse(dateOfBirth)
            : null,
        gender: _convertGender(gender),
        address: address,
        phone: phone,
      );
      _convertRelationship(selectedRelationship);
      final newProfile = Patientprofile(
        patientProfileId: '',
        relation: selectedRelationship,
        idCard: idCard,
        insuranceCode: insuranceCode,
        person: person,
        accountId: '',
      );
      // Use the newProfile variable, for example:
      final result =
          context.read<PatientprofileProvider>().addPatientprofile(newProfile);
      result.then((response) {
        if (!mounted) return;
        if (response.status == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo hồ sơ thành công')),
          );
          Navigator.pop(context, true); // Return true to indicate success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${response.message}')),
          );
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Thêm hồ sơ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                            Row(
                              children: [
                                Expanded(
                                  child: CustomDateField(
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
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomDropdownField(
                                    itemLabel: (value) => value,
                                    label: "Giới tính",
                                    hintText: "Nam/Nữ",
                                    items: ["Nam", "Nữ"],
                                    onChanged: (value) {
                                      setState(() {
                                        _genderController.text = value ?? "";
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Giới tính không được để trống";
                                      }
                                      if (value != "Nam" && value != "Nữ") {
                                        return "Giới tính phải là 'Nam' hoặc 'Nữ'";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
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
                            CustomDropdownField<Province>(
                              label: "Tỉnh/Thành phố",
                              hintText: "Vui lòng chọn Tỉnh/Thành phố",
                              value: selectedProvince,
                              items: provinces,
                              itemLabel: (p) => p.name,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    selectedProvince = value;
                                  });
                                  _loadDistricts(value.code);
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
                                  setState(() {
                                    selectedDistrict = value;
                                  });
                                  _loadWards(value.code);
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
                                  setState(() {
                                    selectedWard = value;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Phường/Xã không được để trống";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _handleCreateProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Tạo mới hồ sơ',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
