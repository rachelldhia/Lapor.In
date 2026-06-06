import sys

file_path = 'lib/features/home/presentation/pages/main_page.dart'
with open(file_path, 'r') as f:
    content = f.read()

old_string = """  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }"""

new_string = """  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          _pages[_currentIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNavBar(),
          ),
        ],
      ),
    );
  }"""

if old_string in content:
    content = content.replace(old_string, new_string)
    with open(file_path, 'w') as f:
        f.write(content)
    print("Successfully replaced.")
else:
    print("Old string not found.")
