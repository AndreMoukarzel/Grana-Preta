extends Control

const SUBJ_TREE_SCN = preload("res://school/Subjects/SubjectTree.tscn")
const LESSON_SCN = preload("res://school/Lessons/Lesson.tscn")


func _on_TextureButton_pressed():
	instance_test_theme()


func _ready():
	$Background/Panel.rect_size = OS.get_screen_size()


func add_subject_tree(theme_name):
	var SubjTree = SUBJ_TREE_SCN.instance()
	
	add_child(SubjTree)
	SubjTree.setup(theme_name)
	$ThemeTree.queue_free()

func add_lesson(lesson_name, lesson_content):
	var Lesson = LESSON_SCN.instance()
	
	add_child(Lesson)
	Lesson.setup(lesson_name, lesson_content)
	$SubjectTree.queue_free()


func instance_test_lesson():
	var db = load("res://school/Lessons/LessonDB.gd").new()
	var id = db.get_lesson_id("Basic Stuff")
	
	add_lesson(db.get_lesson_name(id), db.get_lesson_content(id))


func instance_test_subject():
	var db = load("res://school/SchoolDB.gd").new()
	var Subject = load("res://school/Subjects/Subject.tscn").instance()
	
	add_child(Subject)
	Subject.setup(300, db.get_subject_name(0), db.get_subject_icon(0), db.get_subject_info(0))


func instance_test_theme():
	var db = load("res://school/SchoolDB.gd").new()
	var Theme = load("res://school/Themes/Theme.tscn").instance()
	
	Theme.rect_position = Vector2(100, 100)
	$ThemeTree.add_child(Theme)
	Theme.setup(db.get_theme_name(0), db.get_theme_icon(0))

