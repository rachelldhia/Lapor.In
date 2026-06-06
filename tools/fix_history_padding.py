import sys

file_path = 'lib/features/report/presentation/pages/history_page.dart'
with open(file_path, 'r') as f:
    content = f.read()

old_string = """          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: 5,"""

new_string = """          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            itemCount: 5,"""

if old_string in content:
    content = content.replace(old_string, new_string)
    with open(file_path, 'w') as f:
        f.write(content)
    print("Successfully replaced in HistoryPage.")
else:
    print("Old string not found in HistoryPage.")
