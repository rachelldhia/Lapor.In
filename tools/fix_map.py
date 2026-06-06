import sys

file_path = 'lib/features/home/presentation/pages/home_page.dart'
with open(file_path, 'r') as f:
    content = f.read()

old_string = """            // Semi-transparent top red-rose gradient for text legibility over map
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFFE05B5E).withValues(alpha: 0.85),
                      const Color(0xFFF2A3A6).withValues(alpha: 0.15),
                    ],
                  ),
                ),
              ),
            ),
            
            // Clean red bottom highlight border (solid, 100% width)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                color: const Color(0xFFEB6D70).withValues(alpha: 0.9),
              ),
            ),"""

new_string = """            // Semi-transparent top black gradient for text legibility over map
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),"""

if old_string in content:
    content = content.replace(old_string, new_string)
    with open(file_path, 'w') as f:
        f.write(content)
    print("Successfully replaced.")
else:
    print("Old string not found.")
