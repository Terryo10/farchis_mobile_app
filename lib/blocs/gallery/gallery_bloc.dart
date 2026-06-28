import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/gallery_repository.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GalleryRepository galleryRepository;

  GalleryBloc({required this.galleryRepository}) : super(GalleryInitial()) {
    on<GetGalleryEvent>(_onGetGallery);
  }

  Future<void> _onGetGallery(
      GetGalleryEvent event, Emitter<GalleryState> emit) async {
    emit(GalleryLoading());
    final result = await galleryRepository.getGallery();
    result.when(
      onSuccess: (items) => emit(GalleryLoaded(items)),
      onFailure: (failure) => emit(GalleryLoadFailed(failure)),
    );
  }
}
