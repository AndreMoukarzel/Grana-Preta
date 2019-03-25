extends TextureButton

const SCHOOL_DB = preload("res://school/SchoolDB.gd")

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


func get_all_subjects():
	var db = SCHOOL_DB.new()
	var subjects = db.get_theme_info(db.get_theme_id(title))
	var all_subjects = []
	
	for sub in subjects:
		var id = db.get_subject_id(sub)
		var icon = db.get_subject_icon(id)
		var info = db.get_subject_info(id)
		
		all_subjects.append([sub, icon, info])
	return all_subjects


func _on_Theme_pressed():
	var Subject = load("res://school/Subjects/Subject.tscn").instance()
	var subjects = get_all_subjects()
	
	for subject in subjects:
		add_child(Subject)
		Subject.setup(300, subject[0], subject[1], subject[2])
