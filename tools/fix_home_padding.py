import sys

file_path = 'lib/features/home/presentation/pages/home_page.dart'
with open(file_path, 'r') as f:
    content = f.read()

old_string = """                    _buildReportsHistoryHeader(),
                    const SizedBox(height: 12),
                    _buildReportsHistoryList(),
                    
                    const SizedBox(height: 100), // Spacing for bottom navigation bar"""

new_string = """                    _buildReportsHistoryHeader(),
                    const SizedBox(height: 12),
                    _buildReportsHistoryList(),
                    
                    const SizedBox(height: 120), // Spacing for bottom navigation bar"""

if old_string in content:
    content = content.replace(old_string, new_string)
    with open(file_path, 'w') as f:
        f.write(content)
    print("Successfully replaced.")
else:
    print("Old string not found.")
