import sys

file_path = 'lib/features/home/presentation/pages/main_page.dart'
with open(file_path, 'r') as f:
    content = f.read()

old_string = """        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,"""

new_string = """        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,"""

if old_string in content:
    content = content.replace(old_string, new_string)
    content = content.replace("              ],\\n            ),\\n          ),\\n        ),\\n      ),\\n    );\\n  }\\n}", "              ],\\n            ),\\n            ),\\n          ),\\n        ),\\n      ),\\n    );\\n  }\\n}")
    with open(file_path, 'w') as f:
        f.write(content)
    print("Successfully replaced in PlaceholderMapPage.")
else:
    print("Old string not found in PlaceholderMapPage.")
