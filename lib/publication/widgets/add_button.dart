import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showMenu(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeMenu,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx - 100, // Adjust position as needed
              top: offset.dy - 150, // Position above the button
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(-80, -160), // Adjust offset as needed
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMenuItem(
                          context,
                          icon: Icons.post_add,
                          label: 'New Post',
                          onTap: () {
                            _removeMenu();
                            context.push('/create');
                          },
                        ),
                        const Divider(height: 1),
                        _buildMenuItem(
                          context,
                          icon: Icons.group_add,
                          label: 'Create Group',
                          onTap: () {
                            _removeMenu();
                            context.push('/group/create');
                          },
                        ),
                        const Divider(height: 1),
                        _buildMenuItem(
                          context,
                          icon: Icons.tag,
                          label: 'Create Channel',
                          onTap: () {
                            _removeMenu();
                            context.push('/channel/create');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      minLeadingWidth: 24,
    );
  }

  @override
  void dispose() {
    _removeMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        height: 56,
        width: 56,
        child: FloatingActionButton(
          onPressed: () => _showMenu(context),
          backgroundColor: const Color(0xFF420C18),
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
