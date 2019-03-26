extends Control

const LESSON_DB = preload("res://school/Lessons/LessonDB.gd")

var title : String
var id : int
var type
var completed = false


func setup(name, size):
	var db = LESSON_DB.new()
	
	self.id = db.get_lesson_id(name)
	self.title = name
	
	rect_min_size = size
	$Background.rect_size = size
	$Title.rect_size = Vector2(size.x - 15, size.y - 10)
	
	type = db.get_lesson_type(self.id)
	if type == "info":
		pass
	elif type == "question":
		pass
	
	if Save.completed_lessons.has(id): # lesson previously completed
		set_completed()
	
	$Title.text = name


func complete():
	var School = get_tree().get_root().get_node("School")
	
	School.complete_lesson(id)
	set_completed()
	# add other possible effects of completion


func set_completed():
	modulate = Color(0, 1, 0)
	completed = true


func _on_SubjectLesson_pressed():
	var db = LESSON_DB.new()
	var School = get_tree().get_root().get_node("School")
	
	if type == "info" and not completed:
		complete()
	School.add_lesson(title, db.get_lesson_content(id))
