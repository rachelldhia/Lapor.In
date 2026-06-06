import sys

file_path = 'lib/features/auth/presentation/pages/profile_page.dart'
with open(file_path, 'r') as f:
    content = f.read()

old_string = """        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column("""

new_string = """        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            child: Column("""

if old_string in content:
    content = content.replace(old_string, new_string)
    with open(file_path, 'w') as f:
        f.write(content)
    print("Successfully replaced in ProfilePage.")
else:
    print("Old string not found in ProfilePage.")
