extends Node

var completed_lessons = []
var completed_subjects = []
var completed_themes = []
var failed_questions = []
var failed_questions_time = []
var money = 0


func save():
	var savedict = {
		completed_lessons = completed_lessons,
		completed_subjects = completed_subjects,
		completed_themes = completed_themes,
		failed_questions = failed_questions,
		failed_questions_time = failed_questions_time,
		money = money
	}
	return savedict


func save_game():
	var savegame = File.new()
	var savedata = save()
	savegame.open("user://savegame.save", File.WRITE)
	savegame.store_line(to_json(savedata))
	savegame.close()


func load_game():
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		return #Error!  We don't have a save to load
	
	savegame.open("user://savegame.save", File.READ)
	var savedata = {}
	savedata = parse_json(savegame.get_as_text())
	savegame.close()
	
	# Converts savadata's float arrays to int arrays
	for element in savedata.completed_lessons:
		completed_lessons.append(int(element))
	for element in savedata.completed_subjects:
		completed_subjects.append(int(element))
	for element in savedata.completed_themes:
		completed_themes.append(int(element))
	for element in savedata.failed_questions:
		failed_questions.append(int(element))
	for element in savedata.failed_questions_time:
		failed_questions_time.append(element)
	money = int(savedata.money)


func clear_save():
	var dir = Directory.new()
	dir.remove("user://savegame.save")
