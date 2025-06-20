import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dasboard_admin/modals/ticket_modal.dart';
import 'package:get/get.dart';

class TicketController extends GetxController {
  late final RxList<TicketSnapshot> ticketList;

  @override
  void onInit() {
    ticketList = <TicketSnapshot>[].obs;
    getAllTicketFromFirebase();
    super.onInit();
  }

  void getAllTicketFromFirebase() {
    ticketList.bindStream(TicketSnapshot.getAllTicketFormFirebase());
  }

  Future<DocumentReference> addTicket(Ticket ticket) {
    return TicketSnapshot.themMoi(ticket);
  }

  Future<void> updateTicket(TicketSnapshot ticketSnapshot, Ticket ticket) {
    return ticketSnapshot.capNhat(ticket);
  }

  Future<void> deleteTicket(TicketSnapshot ticketSnapshot) {
    return ticketSnapshot.xoa();
  }

  int countMyDocuments(RxList<TicketSnapshot> documents) {
    return documents.length;
  }
}

//* Example
// class TicketListPage extends StatelessWidget {
//   final TicketController ticketController = Get.put(TicketController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ticket List'),
//       ),
//       body: Obx(() {
//         if (ticketController.ticketList.isEmpty) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else {
//           return ListView.builder(
//             itemCount: ticketController.ticketList.length,
//             itemBuilder: (BuildContext context, int index) {
//               final ticket = ticketController.ticketList[index].ticket!;
//               return ListTile(
//                 title: Text(ticket.IdTicket!),
//                 subtitle: Text('${ticket.CreateAt} - ${ticket.Value}'),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     ticketController.deleteTicket(ticketController.ticketList[index]);
//                   },
//                 ),
//               );
//             },
//           );
//         }
//       }),
//     );
//   }
// }
