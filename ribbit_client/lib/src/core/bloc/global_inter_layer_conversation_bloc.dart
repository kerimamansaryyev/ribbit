import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class GlobalInterLayerConversationBloc
    extends Cubit<GlobalInterLayerConversationState> {
  GlobalInterLayerConversationBloc()
      : super(
          const GlobalInterLayerConversationState(
            lastMessage: null,
          ),
        );

  void publishMessage(GlobalInterLayerConversationMessage message) => emit(
        GlobalInterLayerConversationState(
          lastMessage: message,
        ),
      );
}

final class GlobalInterLayerConversationState {
  const GlobalInterLayerConversationState({
    required this.lastMessage,
  });

  final GlobalInterLayerConversationMessage? lastMessage;
}

abstract interface class GlobalInterLayerConversationMessage {}
