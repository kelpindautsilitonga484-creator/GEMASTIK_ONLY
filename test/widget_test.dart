// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_gemastik/data/dummy_data.dart';
import 'package:app_gemastik/main.dart';
import 'package:app_gemastik/screens/payment_confirmation_screen.dart';
import 'package:app_gemastik/screens/profile_screen.dart';
import 'package:app_gemastik/screens/travel_detail_screen.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TravelTrackApp());

    // Verify that the login screen is displayed.
    expect(find.text('TravelTrack'), findsOneWidget);
    expect(find.text('Masuk Akun'), findsOneWidget);
  });

  testWidgets('Register screen navigation and validation test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(const TravelTrackApp());

    // Tap on 'Daftar Sekarang'
    final registerLinkFinder = find.text('Daftar Sekarang');
    await tester.ensureVisible(registerLinkFinder);
    await tester.tap(registerLinkFinder);
    await tester.pumpAndSettle();

    // Verify RegisterScreen is loaded
    expect(find.text('Daftar Akun Penumpang'), findsOneWidget);

    // Tap submit button with empty form
    await tester.tap(find.text('DAFTAR SEKARANG'));
    await tester.pump();

    // Verify validation error messages
    expect(find.text('Nama lengkap tidak boleh kosong'), findsOneWidget);
    expect(find.text('Email tidak boleh kosong'), findsOneWidget);
    expect(find.text('Nomor telepon tidak boleh kosong'), findsOneWidget);
    expect(find.text('Kata sandi tidak boleh kosong'), findsOneWidget);

    // Tap 'Masuk' to navigate back to LoginScreen
    final loginLinkFinder = find.text('Masuk');
    await tester.ensureVisible(loginLinkFinder);
    await tester.tap(loginLinkFinder);
    await tester.pumpAndSettle();

    expect(find.text('Masuk Akun'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('TravelDetailScreen renders details and opens BookingScreen',
      (WidgetTester tester) async {
    final sampleTravel = TravelRepository.dummyTravels.first;

    await tester.pumpWidget(
      MaterialApp(
        home: TravelDetailScreen(
          travel: sampleTravel,
          onBookingSuccess: () {},
        ),
      ),
    );

    // Verify TravelDetailScreen content
    expect(find.text(sampleTravel.providerName), findsOneWidget);
    expect(find.text('Detail Travel'), findsOneWidget);
    expect(find.text(sampleTravel.departureTime), findsOneWidget);
    expect(find.text(sampleTravel.origin), findsOneWidget);
    expect(find.text('PILIH KURSI'), findsOneWidget);

    // Tap on 'PILIH KURSI' button
    await tester.tap(find.text('PILIH KURSI'));
    await tester.pumpAndSettle();

    // Verify BookingScreen is displayed
    expect(find.text('Pilih Kursi & Booking'), findsOneWidget);
  });

  testWidgets('ProfileScreen opens EditProfileScreen and handles logout dialog',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileScreen(),
      ),
    );

    // Verify ProfileScreen contents
    expect(find.text('Penumpang'), findsOneWidget);
    expect(find.text('Edit Profil'), findsOneWidget);

    // Tap on Edit Profil
    await tester.tap(find.text('Edit Profil'));
    await tester.pumpAndSettle();

    // Verify EditProfileScreen loaded
    expect(find.text('Edit Profil'), findsOneWidget);
    expect(find.text('SIMPAN PERUBAHAN'), findsOneWidget);

    // Kembali ke ProfileScreen tanpa menyimpan.
    // Penyimpanan profile sekarang membutuhkan Firebase user yang aktif
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Verify kembali ke ProfileScreen
    expect(find.text('Profil Penumpang'), findsOneWidget);

    // Tap Keluar Akun button
    final logoutButtonFinder = find.text('Keluar Akun');
    await tester.ensureVisible(logoutButtonFinder);
    await tester.tap(logoutButtonFinder);
    await tester.pumpAndSettle();

    // Verify confirmation dialog appears
    expect(find.text('Konfirmasi Keluar'), findsOneWidget);
    expect(find.text('Apakah Anda yakin ingin keluar dari akun TravelTrack?'),
        findsOneWidget);

    // Tap Keluar inside dialog
    await tester.tap(find.widgetWithText(ElevatedButton, 'Keluar'));
    await tester.pumpAndSettle();

    // Verify navigated to LoginScreen
    expect(find.text('Masuk Akun'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets(
      'PaymentConfirmationScreen requires checkbox before booking submission',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    final sampleTravel = TravelRepository.dummyTravels.first;

    await tester.pumpWidget(
      MaterialApp(
        home: PaymentConfirmationScreen(
          travel: sampleTravel,
          passengerName: 'Posman Test',
          passengerPhone: '081234567890',
          selectedSeats: const ['1A'],
          serviceType: 'Pool to Pool',
          pickupAddress: '',
          notes: '',
          paymentMethod: 'Transfer Bank BCA',
          onBookingCompleted: () {},
        ),
      ),
    );

    // Verify PaymentConfirmationScreen content
    expect(find.text('Konfirmasi Pembayaran'), findsOneWidget);
    expect(find.text('Rincian Perjalanan'), findsOneWidget);
    expect(find.text('Posman Test'), findsOneWidget);
    expect(find.text('BUAT PESANAN'), findsOneWidget);

    // Check button disabled state when checkbox is unchecked
    final submitButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'BUAT PESANAN'),
    );
    expect(submitButton.onPressed, isNull);

    // Tap checkbox
    final checkboxFinder = find.byType(Checkbox);
    await tester.tap(checkboxFinder);
    await tester.pumpAndSettle();

    // Verify button is now enabled and tap it
    final enabledSubmitButton = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'BUAT PESANAN'),
    );
    expect(enabledSubmitButton.onPressed, isNotNull);

    // Booking button is enabled after passenger confirmation.
    // Firestore booking creation is handled by BookingService
    // and is not executed in this widget test.
    expect(enabledSubmitButton.onPressed, isNotNull);

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}
