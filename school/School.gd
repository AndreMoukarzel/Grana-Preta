extends Control


func _on_TextureButton_pressed():
	var lesson_db = load("res://school/Lessons/LessonDB.gd").new()
	var lesson_scn = load("res://school/Lessons/Lesson.tscn")
	
	var Lesson = lesson_scn.instance()
	add_child(Lesson)
	Lesson.setup(lesson_db.get_lesson_name(0), lesson_db.get_lesson_content(0))
	$ThemeTree.queue_free()
