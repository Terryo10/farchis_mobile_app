import 'package:equatable/equatable.dart';

sealed class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object?> get props => [];
}

class GetGalleryEvent extends GalleryEvent {
  const GetGalleryEvent();
}
