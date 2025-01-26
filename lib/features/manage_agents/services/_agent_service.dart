import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditouch_admin/features/manage_agents/models/_agent_model.dart';

class AgentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<AgentModel>> getAgents() {
    return _firestore
        .collection('db_client_agent_userinfo')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AgentModel.fromJson(
              doc.data())) // Map each document to AgentModel
          .toList(); // Convert the iterable to a list
    });
  }
}
