// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:dtnd/=models=/core_response_model.dart';
import 'package:dtnd/=models=/response/account_info_model.dart';
import 'package:dtnd/=models=/response/business_profile_model.dart';
import 'package:dtnd/=models=/response/company_info.dart';
import 'package:dtnd/=models=/response/deep_model.dart';
import 'package:dtnd/=models=/response/inday_matched_order.dart';
import 'package:dtnd/=models=/response/index_board.dart';
import 'package:dtnd/=models=/response/index_detail.dart';
import 'package:dtnd/=models=/response/index_chart_data.dart';
import 'package:dtnd/=models=/index.dart';
import 'package:dtnd/=models=/response/introduct_company.dart';
import 'package:dtnd/=models=/response/liquidity_model.dart';
import 'package:dtnd/=models=/response/new_order.dart';
import 'package:dtnd/=models=/response/news_detail.dart';
import 'package:dtnd/=models=/response/news_model.dart';
import 'package:dtnd/=models=/response/s_cash_balance.dart';
import 'package:dtnd/=models=/response/security_basic_info_model.dart';
import 'package:dtnd/=models=/response/stock.dart';
import 'package:dtnd/=models=/response/stock_board.dart';
import 'package:dtnd/=models=/response/stock_data.dart';
import 'package:dtnd/=models=/response/stock_financial_index_model.dart';
import 'package:dtnd/=models=/response/stock_his.dart';
import 'package:dtnd/=models=/response/stock_news.dart';
import 'package:dtnd/=models=/response/stock_ranking_financial_index_model.dart';
import 'package:dtnd/=models=/response/stock_report_res.dart';
import 'package:dtnd/=models=/response/stock_trade.dart';
import 'package:dtnd/=models=/response/stock_trading_history.dart';
import 'package:dtnd/=models=/response/stock_vol.dart';
import 'package:dtnd/=models=/response/subsidiaries_model.dart';
import 'package:dtnd/=models=/response/top_influence_model.dart';
import 'package:dtnd/=models=/response/top_interested_model.dart';
import 'package:dtnd/=models=/response/total_asset_model.dart';
import 'package:dtnd/=models=/response/user_token.dart';
import 'package:dtnd/=models=/request/request_model.dart';
import 'package:dtnd/=models=/response/world_index_model.dart';
import 'package:dtnd/=models=/ui_model/field_tree_element_model.dart';
import 'package:dtnd/config/service/environment.dart';
import 'package:dtnd/data/i_network_service.dart';
import 'package:dtnd/utilities/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../=models=/response/basic_company.dart';
import '../../=models=/response/indContrib.dart';
import '../../=models=/response/sec_event.dart';
import '../../=models=/response/sec_trading.dart';
import '../../=models=/response/stock_industry.dart';

class NetworkService implements INetworkService {
  final http.Client client = http.Client();

  NetworkService._internal();

  static final _instance = NetworkService._internal();

  static NetworkService get instance => _instance;

  factory NetworkService() => _instance;

  late Environment environment;

  late final String core_url;
  late final String core_url1;
  late final String core_endpoint;
  late final String board_url;
  late final String sbboard_url;
  late final String info_sbsi_url;
  late final String algo_url;
  late final String algo_url_apec;

  Uri url_core(
    String unencodedPath, [
    Map<String, dynamic>? queryParameters,
  ]) {
    return Uri.https(core_url, unencodedPath, queryParameters);
  }

  Uri url_core1(
    String unencodedPath, [
    Map<String, dynamic>? queryParameters,
  ]) {
    return Uri.http(core_url1, unencodedPath, queryParameters);
  }

  Uri get url_core_endpoint => Uri.https(core_url, core_endpoint);

  Uri url_board(String path) => Uri.https(board_url, path);

  Uri url_board_data_feed(Map<String, dynamic> queryParameters) {
    print(Uri.https(sbboard_url, "datafeed/history", queryParameters));
    return Uri.https(sbboard_url, "datafeed/history", queryParameters);
  }

  Uri url_info_sbsi(String path, [Map<String, dynamic>? queryParameters]) {
    print(Uri.https(info_sbsi_url, path, queryParameters).toString());
    return Uri.https(info_sbsi_url, path, queryParameters);
  }

  Uri url_algo(
    String path, [
    Map<String, dynamic>? queryParameters,
  ]) {
    final unencodedPath = "algo/pbapi/api/$path";
    return Uri.http(algo_url, unencodedPath, queryParameters);
  }

  Uri url_algo_apec(
    String path, [
    Map<String, dynamic>? queryParameters,
  ]) {
    final unencodedPath = "algo/pbapi/api/$path";
    return Uri.http("opacc-api.apec.com.vn", unencodedPath, queryParameters);
  }

  final Utf8Codec utf8Codec = const Utf8Codec();

  @override
  late Socket socket;

  dynamic decode(dynamic data) {
    try {
      if (data is Uint8List) {
        return jsonDecode(utf8Codec.decode(data));
      } else {
        return jsonDecode(data);
      }
    } catch (e) {
      // print(data);
      logger.e(e.toString());
      return null;
    }
  }

  @override
  Future<void> init(Environment environment) async {
    this.environment = environment;
    await dotenv.load(fileName: environment.envFileName);
    core_url = dotenv.env['core_domain']!;
    core_url1 = dotenv.env['core_domain1']!;
    core_endpoint = dotenv.env['core_endpoint']!;
    board_url = dotenv.env['board_domain']!;
    sbboard_url = dotenv.env['sbboard_domain']!;
    info_sbsi_url = dotenv.env['info_sbsi_domain']!;
    algo_url = dotenv.env['algo_domain']!;
    algo_url_apec = dotenv.env['algo_domain_apec']!;

    initSocket(sbboard_url);
    return;
  }

  @override
  void initSocket(String url) {
    socket = io(
        'https://$url/ps',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
    return;
  }

  @override
  Future<void> startSocket() async {
    throw UnimplementedError();
  }

  @override
  Future<String?> getHomeBanner() async {
    dynamic response = await client.get(Uri.http(core_url1, "banners"));
    response = decode(response.bodyBytes);
    return response["data"].first["img"];
  }

  @override
  Future<UserEntity?> checkLogin(RequestModel requestModel) async {
    final http.Response response =
        await client.post(url_core_endpoint, body: requestModel.toString());
    logger.v(response.body);
    return UserEntity.fromJson(decode(response.bodyBytes));
  }

  @override
  Future<T?> requestTraditionalApi<T extends CoreResponseModel>(
      RequestModel requestModel,
      {T? Function(Map<String, dynamic>)? onError}) async {
    dynamic response =
        await client.post(url_core_endpoint, body: requestModel.toString());
    response = decode(response.bodyBytes);
    if (response["rc"] != 1) {
      return onError?.call(response);
    }
    response = response["data"];
    return CoreResponseModel.fromJson<T>(response);
  }

  @override
  Future<List<T>?> requestTraditionalApiResList<T extends CoreResponseModel>(
      RequestModel requestModel,
      {List<T>? Function(Map<String, dynamic>)? onError}) async {
    dynamic response =
        await client.post(url_core_endpoint, body: requestModel.toString());
    response = decode(response.bodyBytes);
    if (response["rc"] != 1) {
      return onError?.call(response);
    }
    response = response["data"];
    final List<T> result = [];
    for (var element in response) {
      result.add(CoreResponseModel.fromJson<T>(element));
    }
    return result;
  }

  @override
  Future<List<Stock>> getListAllStock() async {
    const String path = "getlistallstock";
    final http.Response response = await client.get(url_board(path));
    final List<dynamic> responseBody = decode(response.bodyBytes);
    if (responseBody.isEmpty) throw Exception();
    List<Stock> data = [];
    for (var element in responseBody) {
      data.add(Stock.fromJson(element));
    }
    return data;
  }

  @override
  Future<List<String>> getList30Stocks(String code) async {
    const String path = "list30.pt";
    final Map<String, dynamic> param = {"market": code};
    final http.Response response = await client.get(url_info_sbsi(path, param));
    final String responseBody = decode(response.bodyBytes)['list'];

    if (responseBody.isEmpty) throw Exception();
    final List<String> data = responseBody.split(",");

    return data;
  }

  @override
  Future<List<StockDataResponse>> getListStockData(String listStock) async {
    final String path = "getliststockdata/$listStock";
    final http.Response response = await client.get(url_board(path));
    final List<dynamic> responseBody = decode(response.bodyBytes);
    if (responseBody.isEmpty) throw Exception();
    List<StockDataResponse>? data = [];
    for (var element in responseBody) {
      data.add(StockDataResponse.fromJson(element));
    }
    return data;
  }

  /// Should not call, too many datam, call method below
  @override
  Future<List<StockTrade>> getListStockTrade(String stockCode) async {
    final String path = "getliststocktrade/$stockCode";
    final http.Response response = await client.get(url_board(path));
    final List<dynamic> responseBody = decode(response.bodyBytes);
    if (responseBody.isEmpty) throw Exception();
    List<StockTrade>? data = [];
    for (var element in responseBody) {
      data.add(StockTrade.fromJson(element));
    }
    return data;
  }

  @override
  Future<StockTradingHistory?> getStockTradingHistory(
      String symbol, String resolution, int from, int to) async {
    final Map<String, String> queryParameters = {
      "symbol": symbol,
      "resolution": resolution,
      "from": "$from",
      "to": "$to",
    };
    // logger.v(queryParameters);
    final http.Response response =
        await client.get(url_board_data_feed(queryParameters));
    final responseBody = decode(response.bodyBytes);
    if (responseBody == null) {
      return null;
    }
    // logger.v(responseBody);
    if (responseBody == null) throw Exception();
    final StockTradingHistory data = StockTradingHistory.fromJson(responseBody);
    return data;
  }

  @override
  Future<List<IndexDetailResponse>> getListIndexDetail() async {
    const String path = "getlistindexdetail/11,10,02,03";
    final http.Response response = await client.get(url_board(path));
    final List<dynamic> responseBody = decode(response.bodyBytes);
    if (responseBody.isEmpty) throw Exception();
    List<IndexDetailResponse>? data = [];
    for (var element in responseBody) {
      data.add(IndexDetailResponse.fromJson(element));
    }
    return data;
  }

  @override
  Future<IndexDetailResponse> getIndexDetail(Index index) async {
    final String path = "getlistindexdetail/${index.code}";
    final http.Response response = await client.get(url_board(path));
    final List<dynamic> responseBody = decode(response.bodyBytes);
    if (responseBody.isEmpty) throw Exception();
    final IndexDetailResponse data =
        IndexDetailResponse.fromJson(responseBody.first);
    return data;
  }

  @override
  Future<List<IndexChartData>> getListIndexChartData(Index index) async {
    final String path = "getlistindexdetail/${index.code}";
    final http.Response response = await client.get(url_board(path));
    final responseBody = decode(response.bodyBytes);
    final List<dynamic> responseData = responseBody['data'];
    List<IndexChartData> data = [];
    for (var element in responseData) {
      try {
        data.add(IndexChartData.fromJson(element));
      } catch (e) {
        continue;
      }
    }
    return data;
  }

  @override
  Future<List<StockNews>> getStockNews(String stockCode) async {
    final Map<String, dynamic> queryParameters = {
      "symbol": stockCode,
    };
    final http.Response response =
        await client.get(url_info_sbsi("stockNews.pt", queryParameters));
    final List<dynamic> responseBody = decode(response.bodyBytes);
    List<StockNews> data = [];
    for (var element in responseBody) {
      try {
        data.add(StockNews.fromJson(element));
      } catch (e) {
        continue;
      }
    }
    return data;
  }

  @override
  Future<List<NewsModel>> getNews(Map<String, String> body) async {
    final http.Response response =
        await client.get(url_core1("pickNews", body));
    final List<dynamic> responseBody = decode(response.bodyBytes)["data"];
    List<NewsModel> data = [];
    for (var element in responseBody) {
      try {
        data.add(NewsModel.fromJson(element));
      } catch (e) {
        continue;
      }
    }
    return data;
  }

  @override
  Future<String> getNewsContent(int id) async {
    final http.Response response =
        await client.get(url_core1("pickContents/$id"));
    var responseBody = decode(response.bodyBytes);
    if (responseBody['rc'] == -1) {
      return Future.error(responseBody['rs']);
    }
    final data = responseBody["data"];

    return data;
  }

  @override
  Future<NewsDetail?> getNewsDetail(int id) async {
    final Map<String, dynamic> queryParameters = {
      "id": id,
    };
    final http.Response response =
        await client.get(url_info_sbsi("stockNews.pt", queryParameters));
    final responseBody = decode(response.bodyBytes);
    try {
      return NewsDetail.fromJson(responseBody);
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  @override
  Future<List<WorldIndexModel>> getWorldIndex() async {
    final http.Response response =
        await client.get(url_info_sbsi("worldIndex"));
    final List<dynamic> responseBody = decode(response.bodyBytes)["data"];
    List<WorldIndexModel> data = [];
    for (var element in responseBody) {
      try {
        data.add(WorldIndexModel.fromJson(element));
      } catch (e) {
        continue;
      }
    }
    return data;
  }

  @override
  Future<List<WorldIndexData>> getWorldIndexData(
      Map<String, String> body) async {
    final http.Response response =
        await client.get(url_info_sbsi("chartTime", body));
    final List<dynamic> responseBody = decode(response.bodyBytes)["data"];
    List<WorldIndexData> data = [];
    for (var element in responseBody) {
      try {
        data.add(WorldIndexData.fromJson(element));
      } catch (e) {
        continue;
      }
    }
    return data;
  }

  @override
  Future<List<DeepModel>> getMarketDepth() async {
    try {
      final http.Response response =
          await client.get(url_info_sbsi("marketDepth"));
      logger.d(response.request?.url);
      final List<dynamic> responseBody = decode(response.bodyBytes);
      List<DeepModel> data = [];
      for (var element in responseBody) {
        try {
          data.add(DeepModel.fromJson(element));
        } catch (e) {
          continue;
        }
      }
      data.sort((a, b) => a.sortValue.compareTo(b.sortValue));
      return data;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  @override
  Future<SCashBalance> getSCashBalance(RequestModel requestModel) async {
    final http.Response response =
        await client.post(url_core_endpoint, body: requestModel.toString());
    return SCashBalance.fromJson(decode(response.bodyBytes));
  }

  @override
  Future<NewOrderResponse?> createNewOrder(RequestModel requestModel) async {
    final http.Response response =
        await client.post(url_core_endpoint, body: requestModel.toString());
    return NewOrderResponse.fromJson(decode(response.bodyBytes));
  }

  /// Todo: User
  @override
  Future<UserInfo?> getUserInfo(RequestModel requestModel) async {
    final http.Response response =
        await client.post(url_core_endpoint, body: requestModel.toString());
    logger.v(response.body);
    return UserInfo.constant();
  }

  @override
  Future<TotalAsset?> getTotalAsset(RequestModel requestModel) async {
    final http.Response response =
        await client.post(url_core_endpoint, body: requestModel.toString());
    return TotalAsset.fromJson(decode(response.bodyBytes)['data']);
  }

  @override
  Future<List<String>> getSearchHistory(String body) async {
    dynamic response =
        await client.post(url_core1("searchMarket/history"), body: body);
    response = decode(response.bodyBytes);
    final List<String> list = [];
    logger.v(response);
    if (response["rc"] == 200) {
      for (var element in response["data"]) {
        list.add(element);
      }
    }
    return list;
  }

  @override
  Future<void> putSearchHistory(String body) async {
    var res = await client.post(url_core1("searchMarket/event"), body: body);
    logger.d(jsonDecode(res.body));
  }

  @override
  Future<List<String>> getTopSearch() async {
    dynamic response =
        await client.post(url_core1("searchMarket/top"), body: {});
    response = decode(response.bodyBytes);
    final List<String> list = [];
    if (response["rc"] == 200) {
      for (var element in response["data"]) {
        list.add(element);
      }
    }
    return list;
  }

  @override
  Future<List<TopInterested>> getTopForeignTrade(
      Map<String, dynamic> body) async {
    try {
      final http.Response response =
          await client.get(url_info_sbsi("topForeignTrade", body));

      final List<dynamic> responseBody = decode(response.bodyBytes)["data"];
      List<TopInterested> data = [];
      for (var element in responseBody) {
        try {
          data.add(TopInterested.fromJson(element["STOCK_CODE"]));
        } catch (e) {
          continue;
        }
      }
      return data;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  @override
  Future<List<TopInterested>> getTopStockChange(
      Map<String, dynamic> body) async {
    try {
      final http.Response response =
          await client.get(url_info_sbsi("topStockChange", body));

      final List<dynamic> responseBody = decode(response.bodyBytes)["data"];
      List<TopInterested> data = [];
      for (var element in responseBody) {
        try {
          data.add(TopInterested.fromJson(element));
        } catch (e) {
          continue;
        }
      }
      return data;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  @override
  Future<List<TopInterested>> getTopInterested(
      Map<String, dynamic> body) async {
    try {
      final http.Response response =
          await client.get(url_info_sbsi("topStockInterested", body));

      final List<dynamic> responseBody = decode(response.bodyBytes)["data"];
      List<TopInterested> data = [];
      for (var element in responseBody) {
        try {
          data.add(TopInterested.fromJson(element));
        } catch (e) {
          continue;
        }
      }
      return data;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  @override
  Future<List<TopInterested>> getTopStockTrade(
      Map<String, dynamic> body) async {
    try {
      final http.Response response =
          await client.get(url_info_sbsi("topStockTrade", body));

      final List<dynamic> responseBody = decode(response.bodyBytes)["data"];
      List<TopInterested> data = [];
      for (var element in responseBody) {
        try {
          data.add(TopInterested.fromJson(element));
        } catch (e) {
          continue;
        }
      }
      return data;
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  /// Todo: Order
  @override
  Future<List<IndayMatchedOrder>> getIndayMatchedOrders(String symbol) async {
    dynamic response =
        await client.get(url_algo("stockBoard/chart/stock/$symbol"));
    response = decode(response.bodyBytes);
    if (response['status'] != 200) {
      throw response['message'];
    }
    response = response['data'];
    if (response.isEmpty ?? true) {
      throw NullThrownError();
    }
    final List<IndayMatchedOrder> result = <IndayMatchedOrder>[];
    for (var element in response) {
      result.add(IndayMatchedOrder.fromJson(element));
    }
    return result;
  }

  @override
  Future<List<TopInfluenceModel>> getTopInfluence(String index) async {
    dynamic response = await client.get(url_algo("Contrib", {"id": index}));
    if (response.statusCode != 200) {
      throw response;
    }
    response = decode(response.bodyBytes);
    if (response["name"].isEmpty ?? true) {
      throw NullThrownError();
    }
    final List<dynamic> val = response["upVal"];
    val.addAll(response["downVal"]);
    final List<dynamic> point = response["upPoint"];
    point.addAll(response["downPoint"]);
    final List<TopInfluenceModel> result = <TopInfluenceModel>[];
    for (var i = 0; i < response["name"].length; i++) {
      result.add(TopInfluenceModel(
        stockCode: response["name"][i],
        val: val[i],
        point: point[i],
      ));
    }

    return result;
  }

  @override
  Future<LiquidityModel> getLiquidity(String index) async {
    dynamic response = await client.get(url_algo("MarketValue", {"id": index}));
    if (response.statusCode != 200) {
      throw response;
    }
    response = decode(response.bodyBytes);
    final LiquidityModel result = LiquidityModel.fromJson(response);
    return result;
  }

  @override
  Future<List<String>> getListIndustry() async {
    var response = await client.get(url_info_sbsi("listIndustry"));
    var data = jsonDecode(response.body);
    var list = data['data'] as List;
    List<String> listString = [];
    for (var element in list) {
      listString.add(element.toString());
    }
    return listString;
  }

  @override
  Future<List<StockIndustry>> getListStockByIndust(String industry) async {
    var response = await client
        .get(url_info_sbsi("listStockByIndust", {'industry': industry}));
    if (response.statusCode != 200) {
      throw response;
    }
    var res = decode(response.bodyBytes);
    var list = res["data"] as List;
    List<StockIndustry> result = [];
    for (var element in list) {
      if (element['GTGD'] != null) {
        result.add(StockIndustry.fromJson(element));
      }
    }
    return result;
  }

  @override
  Future<List<FieldTreeModel>> getListIndustryHeatMap(
      int top, String type) async {
    final param = {
      "top": top.toString(),
      "type": type,
    };
    dynamic response =
        await client.get(url_info_sbsi("listIndustryHeatMap", param));
    if (response.statusCode != 200) {
      throw response;
    }
    response = decode(response.bodyBytes);
    response = response["data"];
    final List<FieldTreeModel> result = [];
    for (var element in response) {
      result.add(FieldTreeModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<List<StockFinancialIndex>> getStockFinancialIndex(String body) async {
    dynamic response = await client.post(url_algo("secFSRatios"), body: body);
    if (response.statusCode != 200) {
      throw response;
    }
    response = decode(response.bodyBytes);

    if (response["status"] != 200) {
      throw response["message"];
    }
    response = decode(response["data"]);
    final List<StockFinancialIndex> result = [];
    for (final element in response) {
      result.add(StockFinancialIndex.fromJson(element));
    }

    return result;
  }

  @override
  Future<StockRankingFinancialIndex?> getStockRankingFinancialIndex(
      String body) async {
    dynamic response =
        await client.post(url_algo("secRankingFSRatios"), body: body);
    if (response.statusCode != 200) {
      throw response;
    }
    response = decode(response.bodyBytes);
    if (response["status"] != 200) {
      throw response["message"];
    }
    response = decode(response["data"]);
    logger.v(response);
    final StockRankingFinancialIndex result =
        StockRankingFinancialIndex.fromJson(response);
    return result;
  }

  @override
  Future<SecurityBasicInfo?> getSecurityBasicInfo(String body) async {
    dynamic response =
        await client.post(url_algo("securityBasicInfo"), body: body);
    if (response.statusCode != 200) {
      throw response;
    }
    response = decode(response.bodyBytes);
    if (response["status"] != 200) {
      throw response["message"];
    }
    response = response["data"].first;
    final SecurityBasicInfo result = SecurityBasicInfo.fromJson(response);
    return result;
  }

  @override
  Future<BusinnessProfileModel?> getBusinnessProfile(String body) async {
    dynamic response =
        await client.post(url_algo("companies/introduction"), body: body);
    if (response.statusCode != 200) {
      throw response;
    }
    response = decode(response.bodyBytes);
    if (response["status"] != 200) {
      throw response["message"];
    }
    response = response["data"];
    final BusinnessProfileModel result =
        BusinnessProfileModel.fromJson(response);
    return result;
  }

  @override
  Future<BasicCompany> getBasicProfile(String code) async {
    dynamic response = await client.post(url_algo("companies/basic"),
        body: jsonEncode({"secCode": code}));
    if (response.statusCode != 200) {
      throw response;
    }
    response = decode(response.bodyBytes);
    if (response["status"] != 200) {
      throw response["message"];
    }
    response = response["data"];
    final BasicCompany result = BasicCompany.fromJson(response);
    return result;
  }

  @override
  Future<List<BusinnessLeaderModel>?> getBusinnessLeaders(String body) async {
    dynamic response =
        await client.post(url_algo("companies/leaders"), body: body);
    if (response.statusCode != 200) {
      throw response;
    }
    response = decode(response.bodyBytes);
    if (response["status"] != 200) {
      throw response["message"];
    }
    response = response["data"];
    final List<BusinnessLeaderModel> result = [];
    for (var element in response) {
      result.add(BusinnessLeaderModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<List<SubsidiariesModel>?> getSubsidiaries(
      Map<String, dynamic> body) async {
    dynamic response =
        await client.get(url_algo("companies/relatedCompanies", body));
    if (response.statusCode != 200) {
      throw response;
    }
    response = decode(response.bodyBytes);
    logger.v(response);
    if (response["status"] != 200) {
      throw response["message"];
    }
    response = response["data"];
    final List<SubsidiariesModel> result = [];
    for (var element in response) {
      result.add(SubsidiariesModel.fromJson(element));
    }
    return result;
  }

  @override
  Future<List<IndexBoard>> getIndexBoard(String marketCode) async {
    var response =
        await client.get(url_algo("stockBoard/chart/index/$marketCode"));
    if (response.statusCode != 200) {
      throw response;
    }
    var res = decode(response.bodyBytes);
    if (res["status"] != 200) {
      throw res["message"];
    }
    var list = res["data"] as List;
    List<IndexBoard> result = [];
    for (var element in list) {
      /// lọc với giá trị lỗi
      if (element['Advances'] > 0 ||
          element['Declines'] > 0 ||
          element['NoChanges'] > 0) {
        result.add(IndexBoard.fromJson(element));
      }
    }
    return result;
  }

  @override
  Future<List<String>> getSectors(String industryCode) async {
    var response = await client.get(url_algo("sectors/$industryCode"));
    if (response.statusCode != 200) {
      throw response;
    }
    var res = decode(response.bodyBytes);
    if (res["status"] != 200) {
      throw res["message"];
    }
    var list = res["data"] as List;
    final List<String> result = [];
    for (var element in list) {
      result.add(element['securityCode']);
    }
    return result;
  }

  @override
  Future<IndContrib> getIndContrib(String marketCode) async {
    try {
      var response =
          await client.get(url_algo_apec("IndContrib", {"id": marketCode}));
      if (response.statusCode != 200) {
        throw response;
      }
      var res = decode(response.bodyBytes);
      return IndContrib.fromJson(res);
    } catch (e) {
      logger.d(e.toString());
      rethrow;
    }
  }

  @override
  Future<IndContrib> getFIvalue(String marketCode) async {
    try {
      var response =
          await client.get(url_algo_apec("Fvalue", {"id": marketCode}));
      if (response.statusCode != 200) {
        throw response;
      }
      var res = decode(response.bodyBytes);
      return IndContrib.fromJson(res);
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<IndContrib> getPIvalue(String marketCode) async {
    try {
      var response =
          await client.get(url_algo_apec("PIvalue", {"id": marketCode}));
      if (response.statusCode != 200) {
        throw response;
      }
      var res = decode(response.bodyBytes);
      if (res["status"] != 200) {
        throw res["message"];
      }
      return IndContrib.fromJson(res['data']);
    } catch (e) {
      logger.d(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<SecEvent>> getListEvent(String stockCode) async {
    try {
      var response = await client.post(
          Uri.https('opacc-api.apec.com.vn', 'algo/pbapi/api/secEvents'),
          body: jsonEncode({"lang": "vi", "secCode": stockCode}));
      if (response.statusCode != 200) {
        throw response;
      }
      var res = decode(response.bodyBytes);
      var list = jsonDecode(res['data']) as List;
      var listSecc = <SecEvent>[];
      for (var element in list) {
        listSecc.add(SecEvent.fromJson(element));
      }
      return listSecc;
    } catch (e) {
      logger.e(e.toString());
      logger.e((e as http.Response).request?.url);
      rethrow;
    }
  }

  @override
  Future<CompanyIntroductionResponse> getCompanyIntroduction(
      String stockCode) async {
    var response = await client.post(
        Uri.https(
            'opacc-api.apec.com.vn', 'algo/pbapi/api/companies/introduction'),
        body: jsonEncode({"secCode": stockCode}));
    var res = decode(response.bodyBytes);
    return CompanyIntroductionResponse.fromJson(res);
  }

  @override
  Future<CompanyInfo> getCompanyInfo(String stockCode) async {
    var response = await client
        .get(url_info_sbsi('companyInfo.pt', {"symbol": stockCode}));
    var res = decode(response.bodyBytes);
    return CompanyInfo.fromJson(res);
  }

  @override
  Future<StockReportRes> getStockInfo(String stockCOde) async {
    var response = await client.get(url_info_sbsi('stockReport.pt', {
      "symbol": stockCOde,
      "type": "CSTC",
      "termtype": "1",
      "from": "1",
      "to": "4"
    }));
    var res = decode(response.bodyBytes);
    return StockReportRes.fromJson(res);
  }

  @override
  Future<List<StockMatch>> getListStockMatch(String stockCode) async {
    try {
      var response = await client.get(Uri.https('opacc-api.apec.com.vn',
          'algo/pbapi/api/stockBoard/stock/getDetailsActivelyByPrice/$stockCode'));
      if (response.statusCode != 200) {
        throw response;
      }
      var res = decode(response.bodyBytes);
      var list = res['data'] as List;
      var listSecc = <StockMatch>[];
      for (var element in list) {
        listSecc.add(StockMatch.fromJson(element));
      }
      return listSecc;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<StockHis>> getStockHis(
      String stockCode, String from, String to) async {
    try {
      var response = await client.get(url_info_sbsi('stockHis.pt', {
        "symbol": stockCode,
        "from": from,
        "to": to,
        "page": "1",
        "pageSize": "100"
      }));
      if (response.statusCode != 200) {
        throw response;
      }
      var res = decode(response.bodyBytes);
      var list = res as List;
      var listSecc = <StockHis>[];
      for (var element in list) {
        listSecc.add(StockHis.fromJson(element));
      }
      return listSecc;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<StockBoard> getStockBoard(String stockCode) async {
    var response =
        await client.get(url_algo_apec('stockBoard/stock/$stockCode'));
    var res = decode(response.bodyBytes);
    return StockBoard.fromJson(res['data']);
  }

  @override
  Future<List<SecTrading>> getSecTradingHistory(String stockCode) async {
    try {
      var response = await client.post(
          Uri.https(
              'opacc-api.apec.com.vn', 'algo/pbapi/api/secTradingHistory'),
          body: jsonEncode({
            "lang": "vi",
            "secCode": stockCode,
            "startDate": DateFormat('yyyy-MM-dd')
                .format(DateTime.now().add(const Duration(days: -5))),
            "endDate": DateFormat('yyyy-MM-dd').format(DateTime.now())
          }));
      if (response.statusCode != 200) {
        throw response;
      }
      var res = decode(response.bodyBytes);
      var list = jsonDecode(res['data']) as List;
      logger.d(list);
      var listSecc = <SecTrading>[];
      for (var element in list) {
        listSecc.add(SecTrading.fromJson(element));
      }
      return listSecc;
    } catch (e) {
      rethrow;
    }
  }
}


