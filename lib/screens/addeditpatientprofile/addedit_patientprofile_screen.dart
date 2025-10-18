import 'package:flutter/material.dart';
import 'package:frontend_app/themes/colors.dart';
import 'package:frontend_app/widgets/custom_textfield.dart';
import 'package:frontend_app/widgets/custom_dropdownfield.dart';
import 'package:frontend_app/widgets/custom_datefield.dart';
import 'package:frontend_app/models/address/address.dart';
import 'package:frontend_app/providers/patientprofile_provider.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/models/person.dart';
import 'package:frontend_app/models/ethnic.dart';

import 'package:frontend_app/widgets/custom_flushbar.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app/providers/address_provider.dart';
import 'package:frontend_app/providers/ethnic_provider.dart';
import 'package:frontend_app/utils/relation_utils.dart';
import 'package:frontend_app/utils/gender_utils.dart';
import 'package:frontend_app/utils/date_utils.dart';
import 'package:go_router/go_router.dart';

class AddEditPatientProfileScreen extends StatefulWidget {
  final String? infoIdCard;
  final Patientprofile? editedPatientprofile;
  final String? from;
  const AddEditPatientProfileScreen({
    super.key,
    this.editedPatientprofile,
    this.infoIdCard,
    this.from,
  });

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
  Ethnic? selectedEthnic = Ethnic(code: '01', name: 'Kinh');
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
    final wardName = parts.length > 1 ? parts[1] : '';
    final districtName = parts.length > 2 ? parts[2] : '';
    final provinceName = parts.length > 3 ? parts[3] : '';

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

    final ethnicityProvider = context.read<EthnicityProvider>();
    final addressProvider = context.read<AddressProvider>();

    if (widget.editedPatientprofile != null) {
      final profile = widget.editedPatientprofile!;
      _fullNameController.text = profile.person.fullName;
      _dobController.text = formatDate(profile.person.dateOfBirth);
      _genderController.text = convertGenderBack(profile.person.gender);
      _idCardController.text = profile.idCard;
      _insuranceCodeController.text = profile.insuranceCode;
      _phoneController.text = profile.person.phone ?? '';
      selectedRelationship = convertRelationshipBack(profile.relation);

      // ✅ Gán selectedEthnic sau khi provider đã load danh sách
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        // Load danh sách dân tộc nếu chưa có
        await ethnicityProvider.loadEthnicGroups();

        final ethnicValue = profile.person.ethnic;
        final matchedEthnic = ethnicityProvider.findByCodeOrName(ethnicValue!);
        setState(() {
          selectedEthnic = matchedEthnic;
        });
        // Load địa chỉ
        initAddress(context, profile.person.address);
      });
    } else if (widget.infoIdCard != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _parseInfoCard(widget.infoIdCard!);
      });
      addressProvider.loadProvincesOnce();
      ethnicityProvider.loadEthnicGroups();
    } else {
      ethnicityProvider.loadEthnicGroups();
      addressProvider.loadProvincesOnce();
    }
  }

  void _parseInfoCard(String rawValue) {
    final parts = rawValue.split('|');
    if (parts.length < 7) return;
    final idCard = parts[0];
    final fullName = parts[2];
    final dateOfBirth = parts[3];
    final gender = parts[4].trim();
    debugPrint('gender: $gender');
    final address = parts[5];
    // final soCCCD = parts[1];
    // final ngayCap = parts[6];;

    // Gán thẳng vào controller
    _idCardController.text = idCard;
    _fullNameController.text = fullName;
    _dobController.text = formatDob(dateOfBirth);
    _genderController.text = normalizeGender(gender);
    setState(() {});
    parseAddress(context, address);
  }

  Future<void> parseAddress(BuildContext context, String rawAddress) async {
    final addressProvider = context.read<AddressProvider>();
    final parts = rawAddress.split(',').map((e) => e.trim()).toList();
    if (addressProvider.provinces.isEmpty) {
      await addressProvider.loadProvincesOnce();
    }
    // province
    final provinceName = parts.isNotEmpty ? parts.last : '';
    final province = addressProvider.findProvinceByName(provinceName);
    if (province?.code == -1) return;
    addressProvider.setSelectedProvince(province!);
    await addressProvider.loadDistricts(province);

    // cần đợi districts được load xong
    if (addressProvider.districts.isEmpty) return;
    final districtName = parts.length >= 2 ? parts[parts.length - 2] : '';
    final district = addressProvider.findDistrictByName(
        districtName, addressProvider.districts);
    if (district?.code == -1) return;
    addressProvider.setSelectedDistrict(district!);

    await addressProvider.loadWards(district);
    // cần đợi wards được load xong
    if (addressProvider.wards.isEmpty) return;
    final wardName = parts.length >= 3 ? parts[parts.length - 3] : '';
    final ward =
        addressProvider.findWardByName(wardName, addressProvider.wards);
    if (ward?.code != -1) {
      addressProvider.setSelectedWard(ward!);
    }
    if (parts.length > 3) {
      final specific = parts.sublist(0, parts.length - 3).join(", ");
      _specificAddressController.text = specific;
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
        dateOfBirth: DateTime.utc(
          int.parse(dateOfBirth.split('/')[2]),
          int.parse(dateOfBirth.split('/')[1]),
          int.parse(dateOfBirth.split('/')[0]),
        ),
        gender: convertGender(gender),
        address: address,
        phone: phone,
        ethnic: selectedEthnic?.name,
      );
      selectedRelationship = convertRelationship(selectedRelationship);

      final newProfile = Patientprofile(
        patientProfileId: "",
        patientProfileCode: "",
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
          patientProfileCode: "",
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
    } else {
      // Form is not valid
      CustomFlushbar.show(
        context,
        status: "error",
        message: 'Vui lòng kiểm tra lại thông tin',
      );
    }
  }

  String? validateInsuranceCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mã thẻ BHYT';
    }

    // BHYT có 15 ký tự
    if (value.length != 15) {
      return 'Mã thẻ BHYT phải có đúng 15 ký tự';
    }

    // 2 ký tự đầu phải là chữ
    if (!RegExp(r'^[A-Z]{2}').hasMatch(value)) {
      return '2 ký tự đầu phải là chữ in hoa (mã đối tượng)';
    }

    // Ký tự thứ 3 phải là số từ 1-5
    if (!RegExp(r'^[A-Z]{2}[1-5]').hasMatch(value)) {
      return 'Ký tự thứ 3 phải là số từ 1 đến 5 (mã quyền lợi)';
    }

    // 12 ký tự cuối phải là số
    if (!RegExp(r'^[A-Z]{2}[1-5][0-9]{12}$').hasMatch(value)) {
      return '12 ký tự cuối phải là số';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.from != null) {
              context.go(widget.from!);
            } else {
              context.goNamed('home', queryParameters: {
                'initialIndex': '1',
              });
            }
          },
        ),
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
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              label: "Ngày sinh",
                              hintText: "dd/mm/yyyy",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Ngày sinh không được để trống";
                                }

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
                                        activeColor: AppColors.primaryBlue,
                                      ),
                                      Text(gender),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              keyboardType: TextInputType.number,
                              controller: _idCardController,
                              label: "Mã định danh/ CCCD",
                              hintText: "Vui lòng nhập mã định danh/ CCCD",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Mã định danh/ CCCD không được để trống";
                                }
                                if (!RegExp(r'^[0-9]{12}$').hasMatch(value)) {
                                  return 'CCCD phải gồm đúng 12 chữ số';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _insuranceCodeController,
                              label: "Mã bảo hiểm y tế",
                              hintText: "Vui lòng nhập mã bảo hiểm y tế",
                              validator: validateInsuranceCode,
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
                                // Regex: bắt đầu 0, theo sau 9–10 chữ số
                                if (!RegExp(r'^0\d{9,10}$').hasMatch(value)) {
                                  return 'Số điện thoại không hợp lệ';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Consumer<EthnicityProvider>(
                              builder: (context, ethnicProvider, child) {
                                return CustomDropdownField<Ethnic>(
                                  label: "Dân tộc",
                                  hintText: "Vui lòng chọn dân tộc",
                                  value: selectedEthnic,
                                  items: ethnicProvider.ethnicGroups,
                                  itemLabel: (item) => item.name,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedEthnic = value;
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Dân tộc không được để trống";
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 16),
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
                                        mouseCursor: SystemMouseCursors.click,
                                        activeColor: AppColors.primaryBlue,
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
                                return Column(
                                  children: [
                                    CustomDropdownField<Province>(
                                      label: "Tỉnh/Thành phố",
                                      hintText: "Vui lòng chọn Tỉnh/Thành phố",
                                      value: addressProvider.selectedProvince,
                                      items: addressProvider.provinces,
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
                                      value: addressProvider.selectedDistrict,
                                      items: addressProvider.districts,
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
                                      value: addressProvider.selectedWard,
                                      items: addressProvider.wards,
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
