extends Control

const LESSON_DB = preload("res://school/Lessons/LessonDB.gd")

var title : String
var id : int


func setup(name):
	var db = LESSON_DB.new()
	var type
	
	self.id = db.get_lesson_id(name)
	self.title = name
	type = db.get_lesson_type(self.id)
	
	if type == "info":
		pass
	elif type == "question":
		pass
	
	$Title.text = name


func _on_SubjectLesson_pressed():
	var db = LESSON_DB.new()
	var School = get_tree().get_root().get_node("School")
	
	School.add_lesson(title, db.get_lesson_content(id))
