import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/common.dart';
import 'chat_data.dart';

/// A chat screen with message bubbles, a typing indicator and a composer.
/// The "other person" answers with canned replies, so you can try it offline.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.conversation});

  final Conversation conversation;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  Timer? _replyTimer;
  bool _typing = false;
  int _replyIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _toBottom(animate: false));
  }

  @override
  void dispose() {
    _replyTimer?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String _now() {
    final t = TimeOfDay.now();
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _toBottom({bool animate = true}) {
    if (!_scroll.hasClients) return;
    final end = _scroll.position.maxScrollExtent;
    if (animate) {
      _scroll.animateTo(end, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    } else {
      _scroll.jumpTo(end);
    }
  }

  void _send() {
    final value = _input.text.trim();
    if (value.isEmpty) return;
    _input.clear();
    setState(() {
      widget.conversation.messages.add(Message(text: value, mine: true, time: _now()));
      _typing = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _toBottom());
    _replyTimer?.cancel();
    _replyTimer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      final reply = demoReplies[_replyIndex % demoReplies.length];
      _replyIndex++;
      setState(() {
        _typing = false;
        widget.conversation.messages.add(Message(text: reply, mine: false, time: _now()));
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _toBottom());
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.conversation;
    final messages = c.messages;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            Avatar(name: c.name, hue: c.hue, size: 38, online: c.online),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                Text(
                  c.online ? 'Online' : 'Offline',
                  style: TextStyle(fontSize: 12, color: context.muted),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.videocam_outlined)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: messages.length + (_typing ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == messages.length) return const _TypingBubble();
                return _Bubble(message: messages[i]);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              decoration: BoxDecoration(
                color: context.card,
                border: Border(top: BorderSide(color: context.border)),
              ),
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline)),
                  Expanded(
                    child: TextField(
                      controller: _input,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        filled: true,
                        fillColor: context.soft,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(onPressed: _send, icon: const Icon(Icons.send_rounded)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mine = message.mine;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: mine ? scheme.primary : context.soft,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(mine ? 18 : 4),
            bottomRight: Radius.circular(mine ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: TextStyle(color: mine ? scheme.onPrimary : scheme.onSurface, fontSize: 15),
            ),
            const SizedBox(height: 2),
            Text(
              message.time,
              style: TextStyle(
                fontSize: 10,
                color: mine ? scheme.onPrimary.withAlpha(190) : context.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.soft,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text('typing...', style: TextStyle(color: context.muted, fontStyle: FontStyle.italic)),
      ),
    );
  }
}
