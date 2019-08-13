extends Control

const SCHOOL_DB = preload("res://school/SchoolDB.gd")
const HEIGHT_ADD = 100
const WINDOW_SIZE = Vector2(576, 1024)


func setup(theme_name):
	var CP = $CanvasLayer/ConfirmationPanel
	position_subjects(theme_name)
	CP.rect_position.y = (WINDOW_SIZE.y - CP.rect_size.y)/2
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
	var size = WINDOW_SIZE.x/2
	var height = 80
	
	for subject in subjects:
		var Subject = load("res://school/Subjects/Subject.tscn").instance()
		var N = Node2D.new() # Node is used to alter Subjects' z-index
		
		N.set_position(Vector2(size/2, height))
		N.set_name(str(get_child_count() - 2))
		add_child(N)
		N.add_child(Subject)
		Subject.setup(size, subject[0], subject[1], subject[2])
		height += HEIGHT_ADD


func connect_signals():
	for child in get_children():
		if child.get_name() != "CanvasLayer" and child.get_name() != "Tween":
			var Subject = child.get_node("Subject")
			Subject.connect("opened", self, "subject_opened")
			Subject.connect("closed", self, "subject_closed")


func subject_opened(node):
	var will_tween = false
	var opening_height = (node.get_node("Subject").BASE_HEIGHT + node.get_node("Subject").lessons_height + 10) * 1.2
	
	for child in get_children():
		if child != node and child.get_name() != "CanvasLayer" and child.get_name() != "Tween":
			var Subject = child.get_node("Subject")
			if Subject.is_open:
				Subject.close()
			child.z_index = 0
			
			if child.global_position.y > node.global_position.y:
				var pos = int(child.get_name()) * HEIGHT_ADD + 80
				will_tween = true
				$Tween.interpolate_property(child, "position:y", null, pos + opening_height, .2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	if will_tween:
		$Tween.start()
	node.z_index = 1


func subject_closed(node):
	var will_tween = false
	node.z_index = 0
	
	for child in get_children():
		if child != node and child.get_name() != "CanvasLayer" and child.get_name() != "Tween":
			if child.global_position.y > node.global_position.y:
				var pos = int(child.get_name()) * HEIGHT_ADD + 80
				
				will_tween = true
				$Tween.interpolate_property(child, "position:y", null, pos, .2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	if will_tween:
		$Tween.start()
