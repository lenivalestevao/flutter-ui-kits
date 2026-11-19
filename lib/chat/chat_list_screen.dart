import 'package:flutter/material.dart';

import '../widgets/common.dart';
import 'chat_data.dart';
import 'chat_screen.dart';

/// Inbox with a stories-style row of online contacts, search and unread badges.
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<Conversation> _all = buildConversations();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final online = _all.where((c) => c.online).toList();
    final shown = _all.where((c) => c.name.toLowerCase().contains(_query.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: fieldDecoration(context, 'Search chats', Icons.search),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 82,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: online.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                final c = online[i];
                return GestureDetector(
                  onTap: () => _open(c),
                  child: Column(
                    children: [
                      Avatar(name: c.name, hue: c.hue, size: 56, online: true),
                      const SizedBox(height: 6),
                      Text(c.name.split(' ').first, style: text.bodySmall),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text('No chats found', style: TextStyle(color: context.muted))),
            ),
          for (final c in shown)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              onTap: () => _open(c),
              leading: Avatar(name: c.name, hue: c.hue, online: c.online),
              title: Text(
                c.name,
                style: TextStyle(fontWeight: c.unread > 0 ? FontWeight.w800 : FontWeight.w600),
              ),
              subtitle: Text(
                c.lastText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: c.unread > 0 ? null : context.muted),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(c.lastTime, style: text.bodySmall?.copyWith(color: context.muted)),
                  const SizedBox(height: 4),
                  if (c.unread > 0)
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        '${c.unread}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                      ),
                    )
                  else
                    const SizedBox(height: 20),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _open(Conversation c) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ChatScreen(conversation: c)),
    );
    if (!mounted) return;
    setState(() => c.unread = 0);
  }
}
