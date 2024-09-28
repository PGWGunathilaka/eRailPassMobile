import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:erailpass_mobile/common/custom_dio.dart';
import 'package:erailpass_mobile/models/app_response.dart';
import 'package:erailpass_mobile/models/ticket.dart';
import 'package:flutter/cupertino.dart';

class PaymentService {

  static Future<AppResponse<Map<String, dynamic>>> createPaymentSheet(Ticket ticket) async {
    Map<String, dynamic> data = ticket.toJson();

    String url = getApiUrl("auth/payment/payment-sheet");
    Response<dynamic> response = await customDio.post(url, data: data);
    debugPrint(response.toString());
    // dynamic jsonResponse = jsonDecode(response.data);
    AppResponse<Map<String, dynamic>> appResponse = AppResponse.fromJson(response);
    debugPrint(response.toString());
    return appResponse;
  }
  static Future<int> calculatePayment(Ticket ticket) async {
    Map<String, dynamic> data = ticket.toJson();

    String url = getApiUrl("auth/payment/calculate-payment");
    Response<dynamic> response = await customDio.post(url, data: data);
    debugPrint(response.toString());
    // dynamic jsonResponse = jsonDecode(response.data);
    AppResponse<int> appResponse = AppResponse.fromJson(response);
    debugPrint(response.toString());
    return appResponse.data ?? 0;
  }
}
