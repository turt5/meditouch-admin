import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditouch_admin/features/manage_agents/models/_agent_model.dart';
import 'package:meditouch_admin/features/manage_agents/services/_agent_service.dart';
import 'package:meditouch_admin/features/manage_nurses/models/_nurse_model.dart';
import 'package:meditouch_admin/features/manage_nurses/services/_manage_nurse_services.dart';

class ManageAgent extends StatefulWidget {
  @override
  _ManageNurseState createState() => _ManageNurseState();
}

class _ManageNurseState extends State<ManageAgent> {
  final TextEditingController _filterController = TextEditingController();
  List<AgentModel> _filteredAgents = [];
  List<AgentModel> _allAgents = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(theme),
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: StreamBuilder<List<AgentModel>>(
              stream: AgentService().getAgents(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CupertinoActivityIndicator(
                      radius: 12,
                      color: theme.primary,
                    ),
                  );
                }

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final agents = snapshot.data!;
                  _allAgents = agents;

                  // Apply filter
                  _filteredAgents = _filterAgents(_filterController.text);

                  // Check if any nurses match the search criteria
                  if (_filteredAgents.isEmpty) {
                    return Center(child: Text('No search results found.'));
                  }

                  return _buildDoctorInfoCard(theme, _filteredAgents);
                } else {
                  return Center(child: Text('No agents available.'));
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Function to filter nurses based on search query
  List<AgentModel> _filterAgents(String query) {
    if (query.isEmpty) {
      return _allAgents;
    }
    return _allAgents.where((nurse) {
      final searchLower = query.toLowerCase();
      return nurse.name.toLowerCase().contains(searchLower) ||
          nurse.email.toLowerCase().contains(searchLower) ||
          nurse.phone.toLowerCase().contains(searchLower) ||
          nurse.address.toLowerCase().contains(searchLower) ||
          nurse.gender.toLowerCase().contains(searchLower);
    }).toList();
  }

  // Widget to build the search bar and title
  Widget _buildTopBar(ColorScheme theme) {
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Agents',
            style: TextStyle(
              fontSize: 20,
              color: theme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 300,
            child: CupertinoTextField(
              controller: _filterController,
              placeholder: 'Search by name, email, phone, etc.',
              onChanged: (value) {
                setState(() {
                  _filteredAgents = _filterAgents(value);
                });
              },
              placeholderStyle:
              TextStyle(color: theme.onSurface.withOpacity(.5)),
              prefix: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(Icons.search, color: theme.primary),
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Doctor info card builder
  Widget _buildDoctorInfoCard(ColorScheme theme, List<AgentModel> agents) {
    return ListView.builder(
      itemCount: agents.length,
      itemBuilder: (context, index) {
        final agent = agents[index];
        return Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primary.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(
                      color: theme.secondary.withOpacity(0.7), width: 2),
                ),
                padding: const EdgeInsets.all(3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.network(
                    agent.imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, color: Colors.red);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return SizedBox(
                        width: 120,
                        height: 120,
                        child: Center(
                          child: CupertinoActivityIndicator(
                            radius: 12,
                            color: theme.onSurface,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agent.name,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Email:',
                          style: TextStyle(
                              color: theme.onSurface.withOpacity(.5),
                              fontSize: 16)),
                      const SizedBox(width: 5),
                      Text(agent.email),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Gender:',
                          style: TextStyle(
                              color: theme.onSurface.withOpacity(.5),
                              fontSize: 16)),
                      const SizedBox(width: 5),
                      Text(agent.gender),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Phone:',
                          style: TextStyle(
                              color: theme.onSurface.withOpacity(.5),
                              fontSize: 16)),
                      const SizedBox(width: 5),
                      Text(agent.phone),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('District:',
                          style: TextStyle(
                              color: theme.onSurface.withOpacity(.5),
                              fontSize: 16)),
                      const SizedBox(width: 5),
                      Text(agent.address),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
