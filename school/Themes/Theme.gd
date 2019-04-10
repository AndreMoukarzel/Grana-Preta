extends TextureButton

var title


func setup(name, icon, locked=false):
	self.title = name
	
	if icon:
		texture_normal = load(icon)
	if locked:
		lock()
		# Probably should make icon being separated from Theme node, so I can darken it's modulate withouth affecting the lock
	
	$Label.text = name
	yield(get_tree(),"idle_frame") # needs to wait for Label's rect_size to update
	$Label.rect_position = Vector2((texture_normal.get_size().x - $Label.rect_size.x)/2, texture_normal.get_size().y)


func lock():
	$Lock.set_position(texture_normal.get_size()/2)
	$Lock.show()
	disabled = true


func unlock():
	$Lock.hide()
	disabled = false


func is_locked():
	return disabled


func _on_Theme_pressed():
	var School = get_tree().get_root().get_node("School")
	
	School.add_subject_tree(title)
