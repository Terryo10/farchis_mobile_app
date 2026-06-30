import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../data/models/gallery_item_model.dart';

sealed class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<GalleryItemModel> items;

  const GalleryLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class GalleryLoadFailed extends GalleryState {
  final Failure failure;

  const GalleryLoadFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}
