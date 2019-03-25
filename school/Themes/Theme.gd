extends TextureButton

var title


func setup(name, icon, locked=false):
#	var icon_path = str("res://school/Themes/", name, ".png")
#	var icon2check = File.new()
#	var has_icon = icon2check.file_exists(icon_path)
	
	self.title = name
#	if has_icon:
#		texture_normal = load(icon_path)
	if icon:
		texture_normal = load(icon)
	if locked:
		$Lock.set_position(texture_normal.get_size()/2)
		$Lock.show()
		# Probably should make icon being separated from Theme node, so I can darken it's modulate withouth affecting the lock
	
	$Label.text = name
	yield(get_tree(),"idle_frame") # needs to wait for Label's rect_size to update
	$Label.rect_position = Vector2((texture_normal.get_size().x - $Label.rect_size.x)/2, texture_normal.get_size().y)


func _on_Theme_pressed():
	var School = get_tree().get_root().get_node("School")
	
	School.add_subject_tree(title)
