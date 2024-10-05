import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardSidebarItem extends StatefulWidget {
  const DashboardSidebarItem({
    super.key,
    required this.label,
    required this.iconpath,
    required this.onTap,
    required this.isSelected,
    this.hasDot = false,
  });

  final String label;
  final String iconpath;
  final VoidCallback onTap;
  final bool isSelected;
  final bool hasDot;

  @override
  State<DashboardSidebarItem> createState() => _DashboardSidebarItemState();
}

class _DashboardSidebarItemState extends State<DashboardSidebarItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: theme.secondary,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 15),
          height: isHovered ? 50 : 45, // Smooth height animation
          decoration: BoxDecoration(
            color: widget.isSelected
                ? theme.surface
                : isHovered
                ? theme.surface.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isHovered ? 30 : 25, // Animate icon size
                    height: isHovered ? 30 : 25,
                    child: Image.asset(
                      widget.iconpath,
                      fit: BoxFit.contain,
                      color: widget.isSelected
                          ? theme.onSurface
                          : theme.onPrimary,
                    ),
                  ),
                  if (widget.hasDot)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: theme.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: GoogleFonts.poppins(
                  color: widget.isSelected
                      ? theme.onSurface
                      : theme.onPrimary,
                  fontWeight: isHovered ? FontWeight.w600 : FontWeight.normal, // Animate text weight
                ),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
