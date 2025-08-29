import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/app_flavor.dart';

class SkillFilterInput extends StatefulWidget {
  final AppFlavor? flavor;
  final List<String> availableSkills;
  final String selectedSkill;
  final Function(String) onSkillSelected;

  const SkillFilterInput({
    super.key,
    this.flavor,
    required this.availableSkills,
    required this.selectedSkill,
    required this.onSkillSelected,
  });

  @override
  State<SkillFilterInput> createState() => _SkillFilterInputState();
}

class _SkillFilterInputState extends State<SkillFilterInput> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isDropdownOpen = false;
  List<String> _filteredSkills = [];
  String _currentSelection = '';
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedSkill;
    _searchController.text = widget.selectedSkill == 'All Skills' ? '' : widget.selectedSkill;
    _filteredSkills = widget.availableSkills;
    
    // Escuchar cambios en el teclado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.addListener(_onFocusChange);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _filterSkills(String query) {
    _updateFilteredSkills();
  }

  void _onFocusChange() {
    if (_isDropdownOpen && _overlayEntry != null) {
      // Reposicionar el dropdown cuando cambia el foco (teclado aparece/desaparece)
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _selectSkill(String skill) {
    setState(() {
      _currentSelection = skill;
      _searchController.text = skill == 'All Skills' ? '' : skill;
    });
    _removeOverlay();
    widget.onSkillSelected(skill);
    _focusNode.unfocus();
  }

  void _updateFilteredSkills() {
    final query = _searchController.text;
    if (query.isEmpty) {
      _filteredSkills = widget.availableSkills;
    } else {
      _filteredSkills = widget.availableSkills
          .where((skill) => skill.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    _overlayEntry?.markNeedsBuild();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      setState(() {
        _isDropdownOpen = true;
        _filteredSkills = widget.availableSkills;
      });
      _focusNode.requestFocus();
      _showOverlay();
    }
  }

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Calcular la posición óptima para el dropdown
    double topPosition = position.dy + 44;
    double maxHeight = 200;
    
    // Si el teclado está abierto, ajustar la posición
    if (keyboardHeight > 0) {
      final availableHeight = screenHeight - keyboardHeight - topPosition - 20; // 20px de margen
      if (availableHeight < maxHeight) {
        maxHeight = availableHeight;
      }
      // Si no hay suficiente espacio arriba, mostrar el dropdown arriba del input
      if (topPosition + maxHeight > screenHeight - keyboardHeight) {
        topPosition = position.dy - maxHeight - 10; // 10px de margen
      }
    }
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Fondo transparente para detectar clics fuera
          Positioned.fill(
            child: GestureDetector(
              onTap: () => _removeOverlay(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Dropdown real
          Positioned(
            top: topPosition,
            left: position.dx,
            width: renderBox.size.width,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredSkills.length,
                  itemBuilder: (context, index) {
                    final skill = _filteredSkills[index];
                    final isSelected = skill == _currentSelection;
                    
                    return GestureDetector(
                      onTap: () => _selectSkill(skill),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)).withValues(alpha: 0.1) : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[200]!,
                              width: index == _filteredSkills.length - 1 ? 0 : 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                skill,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: isSelected ? Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)) : Colors.black,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check,
                                size: 16,
                                color: Color(AppFlavorConfig.getPrimaryColor(widget.flavor ?? AppFlavorConfig.currentFlavor)),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: _filterSkills,
                  onTap: () {
                    setState(() {
                      _isDropdownOpen = true;
                      _filteredSkills = widget.availableSkills;
                    });
                    _showOverlay();
                  },
                  decoration: InputDecoration(
                    hintText: 'All Skills',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[400],
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
            ),
            Icon(
              _isDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
