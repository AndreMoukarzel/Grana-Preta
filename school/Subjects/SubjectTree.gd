extends Control

const SCHOOL_DB = preload("res://school/SchoolDB.gd")
const HEIGHT_ADD = 100


func setup(theme_name):
	position_subjects(theme_name)
	connect_signals()


func get_all_subjects(theme_name):
	var db = SCHOOL_DB.new()
	var subjects = db.get_theme_info(db.get_theme_id(theme_name))
	var all_subjects = []
	
	for sub in subjects:
		var id = db.get_subject_id(sub)
		var icon = db.get_subject_icon(id)
		var info = db.get_subject_info(id)
		
		if id == -1:
			print("Subject ", sub, " not found")
		else:
			all_subjects.append([sub, icon, info])
	return all_subjects


func position_subjects(theme_name):
	var subjects = get_all_subjects(theme_name)
	var size = OS.get_window_size().x/3
	var column = 0
	var height = 80
	
	for subject in subjects:
		var Subject = load("res://school/Subjects/Subject.tscn").instance()
		var N = Node2D.new()
		
		N.set_position(Vector2(size/4 + column * size * 1.5, height))
		add_child(N)
		N.add_child(Subject)
		Subject.setup(size, subject[0], subject[1], subject[2])
		column += 1
		if column >= 2:
			height += HEIGHT_ADD
			column = 0


func connect_signals():
	for child in get_children():
		var Subject = child.get_node("Subject")
		
		Subject.connect("opened", self, "subject_opened")
		Subject.connect("closed", self, "subject_closed")


func subject_opened(node):
	for child in get_children():
		if child != node:
			var Subject = child.get_node("Subject")
			if Subject.is_open:
				Subject.close()
			child.z_index = 0
			child.scale = Vector2(1, 1)
	node.z_index = 1
	node.scale = Vector2(1.2, 1.2)


func subject_closed(node):
	node.z_index = 0
	node.scale = Vector2(1, 1)
