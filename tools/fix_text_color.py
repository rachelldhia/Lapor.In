import sys

file_path = 'lib/features/home/presentation/pages/home_page.dart'
with open(file_path, 'r') as f:
    content = f.read()

old_string = """                  // Greeting text
                  RichText(
                    text: const TextSpan(
                      text: "Hello, ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF680002),
                      ),
                      children: [
                        TextSpan(
                          text: "Eve",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF680002),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Notification Icon with badge '3'
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Color(0xFF680002),
                          size: 26,
                        ),
                      ),"""

new_string = """                  // Greeting text
                  RichText(
                    text: const TextSpan(
                      text: "Hello, ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "Eve",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Notification Icon with badge '3'
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),"""

if old_string in content:
    content = content.replace(old_string, new_string)
    with open(file_path, 'w') as f:
        f.write(content)
    print("Successfully replaced.")
else:
    print("Old string not found.")
