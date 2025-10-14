import 'package:flutter/material.dart';
import 'package:frontend_app/models/patientprofile.dart';
import 'package:frontend_app/models/payment.dart';
import 'package:frontend_app/models/schedule.dart';
import 'package:frontend_app/models/slot.dart';
import 'package:frontend_app/models/doctorservice.dart';
import 'package:frontend_app/models/appointment.dart';
import 'package:frontend_app/services/appointment_service.dart';
import 'package:frontend_app/models/responseapi.dart';
import 'package:frontend_app/services/websocket_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final WebSocketService _socketService = WebSocketService();
  AppointmentProvider() {
    _socketService.on('appointment_confirmed', (data) {
      debugPrint('Received appointment_confirmed: $data');
      final appointmentId = data['appointmentId'];
      final newStatus = data['status'];
      _updateAppointmentStatus(appointmentId, newStatus);
    });
  }
  List<Appointment> _appointments = [];
  List<Appointment> _filteredAppointments = [];
  DateTime? _filterDate;
  String _filterStatus = 'all';

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
  List<Appointment> get filteredAppointments => _filteredAppointments;
  DateTime? get filterDate => _filterDate;
  String get filterStatus => _filterStatus;

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
        status: 'unpaid',
      );
      final result =
          await AppointmentService.createAppointment(appointment, payment);
      if (result.status == 'success' && result.data != null) {
        _appointments.insert(0, result.data!); // thêm vào đầu danh sách
        filterAppointments(); // cập nhật lại danh sách lọc
      }
      return result;
    } catch (e) {
      throw Exception('Error creating appointment: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ResponseApi<Appointment>> cancelAppointment(
    String appointmentId,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await AppointmentService.cancelAppointment(appointmentId);
      if (result.status == 'success' && result.data != null) {
        final index =
            _appointments.indexWhere((a) => a.appointmentId == appointmentId);
        if (index != -1) {
          _appointments[index] = result.data!;
          filterAppointments(); // cập nhật lại danh sách lọc
        }
      }
      return result;
    } catch (e) {
      throw Exception('Error cancelling appointment: $e');
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
        _filteredAppointments = List.from(_appointments);
      }
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void disableSlot(Slot slot) {
    if (_selectedSchedule == null) return;

    for (var shift in _selectedSchedule!.shifts) {
      final index = shift.slots.indexWhere((s) => s.slotId == slot.slotId);
      if (index != -1) {
        shift.slots[index] = slot.copyWith(status: 'booked');
        notifyListeners();
        return;
      }
    }
  }

  void enableSlot(Slot slot) {
    if (_selectedSchedule == null) return;

    for (var shift in _selectedSchedule!.shifts) {
      final index = shift.slots.indexWhere((s) => s.slotId == slot.slotId);
      if (index != -1) {
        shift.slots[index] = shift.slots[index].copyWith(status: 'available');
        notifyListeners();
        return;
      }
    }
  }

  Appointment updatePaymentStatus(String appointmentId, String status) {
    final index =
        _appointments.indexWhere((a) => a.appointmentId == appointmentId);
    if (index != -1) {
      final appointment = _appointments[index];
      if (appointment.payment != null) {
        final updatedPayment = appointment.payment!.copyWith(
          status: status,
          payAt: DateTime.now(),
        );
        _appointments[index] = appointment.copyWith(payment: updatedPayment);
        filterAppointments();
        notifyListeners();
      }
      return _appointments[index];
    }
    throw Exception('Appointment not found');
  }

  void _updateAppointmentStatus(String id, String newStatus) {
    final index = _appointments.indexWhere((a) => a.appointmentId == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(status: newStatus);
      filterAppointments();
    }
  }

  void filterAppointments() {
    _isLoading = true;
    notifyListeners();
    try {
      var temp = List<Appointment>.from(_appointments);

      if (_filterStatus != null && _filterStatus != 'all') {
        temp = temp.where((a) => a.status == _filterStatus).toList();
      }

      if (_filterDate != null) {
        temp = temp.where((a) {
          final d = a.schedule.workday;
          return d.year == _filterDate?.year &&
              d.month == _filterDate?.month &&
              d.day == _filterDate?.day;
        }).toList();
      }

      _filteredAppointments = temp;
    } catch (e) {
      debugPrint('Error filtering: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setFilterDate(DateTime? date) {
    _filterDate = date;
    notifyListeners();
  }

  void resetFilters() {
    _filterDate = null;
    _filterStatus = 'all';
    _filteredAppointments = List.from(_appointments);
    notifyListeners();
  }

  bool isFilters() {
    return _filterDate != null ||
        (_filterStatus != 'all' && _filterStatus.isNotEmpty);
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

  void clearSelections() {
    _selectedPatientProfile = null;
    _selectedSlot = null;
    _selectedDoctorService = null;
    _selectedSchedule = null;
    _selectedDate = null;
    notifyListeners();
  }

  void clear() {
    _appointments = [];
    _filteredAppointments = [];
    notifyListeners();
  }
}
