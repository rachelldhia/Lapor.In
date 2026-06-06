import sys

file_path = 'lib/features/home/presentation/pages/main_page.dart'
with open(file_path, 'r') as f:
    content = f.read()

old_string = """              ],
            ),
          ),
        ),
      ),
    );
  }
}"""

new_string = """              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}"""

if old_string in content:
    content = content.replace(old_string, new_string)
    with open(file_path, 'w') as f:
        f.write(content)
    print("Successfully replaced syntax.")
else:
    print("Old string not found.")
