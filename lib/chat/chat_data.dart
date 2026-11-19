class Message {
  const Message({required this.text, required this.mine, required this.time});

  final String text;
  final bool mine;
  final String time;
}

class Conversation {
  Conversation({
    required this.name,
    required this.hue,
    required this.online,
    required this.unread,
    required this.messages,
  });

  final String name;
  final double hue;
  final bool online;
  int unread;
  final List<Message> messages;

  String get lastText => messages.isEmpty ? '' : messages.last.text;
  String get lastTime => messages.isEmpty ? '' : messages.last.time;
}

/// Demo conversations. Replace them with data from your backend.
List<Conversation> buildConversations() {
  return [
    Conversation(
      name: 'Maria Santos',
      hue: 330,
      online: true,
      unread: 2,
      messages: [
        Message(text: 'Hey! Are we still on for lunch?', mine: false, time: '10:20'),
        Message(text: 'Yes! 12:30 at the usual place?', mine: true, time: '10:22'),
        Message(text: 'Perfect, see you there 😊', mine: false, time: '10:24'),
        Message(text: 'I booked a table by the window', mine: false, time: '10:25'),
      ],
    ),
    Conversation(
      name: 'Design Team',
      hue: 250,
      online: false,
      unread: 0,
      messages: [
        Message(text: 'New mockups are in the shared folder', mine: false, time: '09:02'),
        Message(text: 'Looks great, thanks!', mine: true, time: '09:15'),
      ],
    ),
    Conversation(
      name: 'Lucas Oliveira',
      hue: 160,
      online: true,
      unread: 1,
      messages: [
        Message(text: 'Did you see the match last night?', mine: false, time: 'Yesterday'),
      ],
    ),
    Conversation(
      name: 'Ana Costa',
      hue: 30,
      online: false,
      unread: 0,
      messages: [
        Message(text: 'Sending the invoice today', mine: true, time: 'Yesterday'),
        Message(text: 'Thanks, got it!', mine: false, time: 'Yesterday'),
      ],
    ),
    Conversation(
      name: 'Pedro Lima',
      hue: 200,
      online: false,
      unread: 0,
      messages: [
        Message(text: 'Happy birthday! 🎂', mine: true, time: 'Mon'),
      ],
    ),
    Conversation(
      name: 'Julia Ramos',
      hue: 290,
      online: true,
      unread: 0,
      messages: [
        Message(text: 'Can you review my pull request?', mine: false, time: 'Mon'),
      ],
    ),
  ];
}

/// Canned replies used by the demo chat screen.
const List<String> demoReplies = [
  'Sounds good!',
  'Haha, nice 😄',
  'Let me check and get back to you.',
  'Got it, thanks!',
  'Can we talk about it tomorrow?',
];
