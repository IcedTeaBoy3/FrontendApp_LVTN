import 'package:flutter/material.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/models/payment.dart';
import 'package:frontend_app/models/schedule.dart';
import 'package:frontend_app/models/slot.dart';
import 'package:frontend_app/models/doctorservice.dart';
import 'package:frontend_app/models/appointment.dart';
import 'package:frontend_app/services/appointment_service.dart';
import 'package:frontend_app/models/responseapi.dart';

class AppointmentProvider extends ChangeNotifier {
  List<Appointment> _appointments = [];

  Patientprofile? _selectedPatientProfile;
  Schedule? _selectedSchedule;
  DoctorService? _selectedDoctorService;
  String? _paymentType;
  String? _paymentMethod;
  Slot? _selectedSlot;
  DateTime? _selectedDate;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  // int get total => _total;
  List<Appointment> get appointments => _appointments;
  Patientprofile? get selectedPatientProfile => _selectedPatientProfile;
  Slot? get selectedSlot => _selectedSlot;
  DateTime? get selectedDate => _selectedDate;
  DoctorService? get selectedDoctorService => _selectedDoctorService;
  Schedule? get selectedSchedule => _selectedSchedule;
  String? get paymentType => _paymentType;
  String? get paymentMethod => _paymentMethod;

  Future<ResponseApi<Appointment>> createAppointment() async {
    _isLoading = true;
    notifyListeners();
    try {
      final appointment = Appointment(
        appointmentId: '',
        appointmentNumber: 0,
        patientProfile: _selectedPatientProfile!,
        doctorService: _selectedDoctorService!,
        schedule: _selectedSchedule!,
        slot: _selectedSlot!,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final payment = Payment(
        paymentId: '',
        appointment: appointment,
        amount: _paymentType == 'service'
            ? _selectedDoctorService!.price
            : _selectedDoctorService!.price * 0.2,
        method: _paymentMethod ?? 'cash',
        paymentType: _paymentType ?? 'service',
        status: 'pending',
      );
      final result =
          await AppointmentService.createAppointment(appointment, payment);
      if (result.status == 'success' && result.data != null) {
        _appointments.add(result.data!);
      }
      return result;
    } catch (e) {
      throw Exception('Error creating appointment: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAppointments({int page = 1, int limit = 10}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await AppointmentService.fetchAppointments(
        page: page,
        limit: limit,
      );
      debugPrint('Fetched appointments provider: $response');
      if (response.status == 'success' && response.data != null) {
        _appointments = response.data!;
      }
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void setPaymentType(String type) {
    _paymentType = type;
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
