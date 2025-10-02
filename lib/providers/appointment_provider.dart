import 'package:flutter/material.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/models/schedule.dart';
import 'package:frontend_app/models/slot.dart';
import 'package:frontend_app/models/doctorservice.dart';

class AppointmentProvider extends ChangeNotifier {
  Patientprofile? _selectedPatientProfile;
  Slot? _selectedSlot;
  DateTime? _selectedDate;
  DoctorService? _selectedDoctorService;
  Schedule? _selectedSchedule;
  String? _appointmentType;
  String? _paymentMethod;

  Patientprofile? get selectedPatientProfile => _selectedPatientProfile;
  Slot? get selectedSlot => _selectedSlot;
  DateTime? get selectedDate => _selectedDate;
  DoctorService? get selectedDoctorService => _selectedDoctorService;
  Schedule? get selectedSchedule => _selectedSchedule;
  String? get appointmentType => _appointmentType;
  String? get paymentMethod => _paymentMethod;

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void setAppointmentType(String type) {
    _appointmentType = type;
    notifyListeners();
  }

  void setSelectedPatientProfile(Patientprofile profile) {
    _selectedPatientProfile = profile;
    notifyListeners();
  }

  void setSlot(Slot? slot) {
    _selectedSlot = slot;
    notifyListeners();
  }

  void setDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSchedule(Schedule? schedule) {
    _selectedSchedule = schedule;
    _selectedSlot = null; // reset slot khi đổi lịch
    notifyListeners();
  }

  void setDoctorService(DoctorService? service) {
    _selectedDoctorService = service;
    notifyListeners();
  }

  void reset() {
    _selectedPatientProfile = null;
    _selectedSlot = null;
    _selectedDoctorService = null;
    _selectedSchedule = null;
    _selectedDate = null;
    notifyListeners();
  }
}
