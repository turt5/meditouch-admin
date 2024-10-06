import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditouch_admin/features/manage_agents/models/_agent_model.dart';

class AgentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<AgentModel>> getAgents() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc['role'] == 'ag') // Filter for agents
          .map((doc) => AgentModel.fromJson(doc.data(), doc.id)) // Map each document to AgentModel
          .toList(); // Convert the iterable to a list
    });
  }
}
