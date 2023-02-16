import 'package:coursez/model/chat.dart';
import 'package:coursez/view_model/chat_view_model.dart';
import 'package:get/get.dart';

class InboxController extends GetxController {
  final ChatViewModel chatViewModel = ChatViewModel();
  final _inbox = <Inbox>[].obs;
  List<Inbox> get inbox => _inbox;
  set inbox(List<Inbox> value) => _inbox.value = value;

  fetchInbox() async => inbox = await chatViewModel.getInbox();

  @override
  void onInit() {
    fetchInbox();
    super.onInit();
  }
}
