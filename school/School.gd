extends Control

const LESSON_SCN = preload("res://school/Lessons/Lesson.tscn")


func _on_TextureButton_pressed():
	instance_test_subject()


func add_lesson(lesson_name, lesson_content):
	var Lesson = LESSON_SCN.instance()
	
	add_child(Lesson)
	Lesson.setup(lesson_name, lesson_content)
	$ThemeTree.queue_free()


func instance_test_lesson():
	var db = load("res://school/Lessons/LessonDB.gd").new()
	var id = db.get_lesson_id("Basic Stuff")
	
	add_lesson(db.get_lesson_name(id), db.get_lesson_content(id))


func instance_test_subject():
	var db = load("res://school/SchoolDB.gd").new()
	var Subject = load("res://school/Subjects/Subject.tscn").instance()
	
	add_child(Subject)
	Subject.setup(300, db.get_subject_name(0), db.get_subject_icon(0), db.get_subject_info(0))

