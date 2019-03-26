extends Control

const THEME_TREE_SCN = preload("res://school/Themes/ThemeTree.tscn")
const SUBJ_TREE_SCN = preload("res://school/Subjects/SubjectTree.tscn")
const LESSON_SCN = preload("res://school/Lessons/Lesson.tscn")

var last_theme


func _ready():
	$Background/Panel.rect_size = OS.get_screen_size()


func add_theme_tree():
	var ThemeTree = THEME_TREE_SCN.instance()
	
	for child in get_children():
		if child.get_name() != "Background" and child.get_name() != "HUD":
			child.queue_free()
	add_child(ThemeTree)


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


func complete_lesson(id):
	var school_db = load("res://school/SchoolDB.gd").new()
	var lesson_db = load("res://school/Lessons/LessonDB.gd").new()
	var lesson_name = lesson_db.get_lesson_name(id)
	var subject_id = school_db.get_lesson_subject(lesson_name)
	var all_lessons = school_db.get_subject_info(subject_id)
	
	print("lesson ", id, " completed")
	Save.completed_lessons.append(id)
	for lesson in all_lessons:
		var lesson_id = lesson_db.get_lesson_id(lesson)
		
		if not Save.completed_lessons.has(lesson_id): # a lesson from subject was not completed
			return
			
	complete_subject(subject_id)


func complete_subject(subject_id):
	var school_db = load("res://school/SchoolDB.gd").new()
	var subject_name = school_db.get_subject_name(subject_id)
	var theme_id = school_db.get_subject_theme(subject_name)
	var all_subjects = school_db.get_theme_info(theme_id)
	
	print("subject ", subject_id, " completed")
	Save.completed_subjects.append(subject_id)
	for subject in all_subjects:
		var sub_id = school_db.get_subject_id(subject)
		
		if not Save.completed_subjects.has(sub_id): # a subject from theme was not completed
			return
	
	complete_theme(theme_id)


func complete_theme(theme_id):
	print("theme ", theme_id, " completed")
	Save.completed_themes.append(theme_id)


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



func _on_Back_pressed():
	add_theme_tree()
