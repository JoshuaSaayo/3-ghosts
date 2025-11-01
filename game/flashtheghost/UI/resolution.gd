extends MenuButton

func _ready():
	var popup = get_popup()  # Access the internal PopupMenu

	# Background style
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0, 0, 0, 0.8)
	panel_style.border_color = Color(1, 1, 1)
	panel_style.border_width_left = 2
	panel_style.border_width_top = 2
	panel_style.border_width_right = 2
	panel_style.border_width_bottom = 2
	panel_style.corner_radius_top_left = 6
	panel_style.corner_radius_top_right = 6
	panel_style.corner_radius_bottom_left = 6
	panel_style.corner_radius_bottom_right = 6
	popup.add_theme_stylebox_override("panel", panel_style)

	# Hover highlight
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = Color(1, 1, 1, 0.2)
	hover_style.corner_radius_top_left = 6
	hover_style.corner_radius_top_right = 6
	hover_style.corner_radius_bottom_left = 6
	hover_style.corner_radius_bottom_right = 6
	popup.add_theme_stylebox_override("hover", hover_style)

	# Font customization
	var font = load("res://UI/fonts/OldNewspaperTypes.ttf")  # 👈 Replace with your actual font file
	popup.add_theme_font_override("font", font)
	popup.add_theme_font_size_override("font_size", 25)

	# Font color
	popup.add_theme_color_override("font_color", Color.WHITE)
	popup.add_theme_color_override("font_hover_color", Color(0.9, 0.9, 0.9))
