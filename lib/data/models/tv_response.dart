import 'package:ditonton/data/models/tv_model.dart';
import 'package:equatable/equatable.dart';

class TVResponse extends Equatable {
  final List<TvModel> tvList;

  TVResponse({required this.tvList});

  factory TVResponse.fromJson(Map<String, dynamic> json) => TVResponse(
        tvList: List<TvModel>.from((json["results"] as List)
            .map((x) => TvModel.fromJson(x))
            .where((element) =>
                element.backdropPath != null || element.posterPath != null)),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(tvList.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [tvList];
}
