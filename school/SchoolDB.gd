extends Node

const NAME = 0
const ICON = 1
const INFO = 2 # subjects in themes and lessons in subjects
const DEPEN = 3 # dependencies for themes


var themes = [
	{ # ID = 0
		NAME : "The School",
		ICON : null,
		INFO : ["Test", "Test1", "Test2", "Test3"],
		DEPEN : []
	},
]

var subjects = [
	{ # ID = 0
		NAME : "Test",
		ICON : null,
		INFO : ["Basic Stuff", "Test1", "Test2", "Test3"],
	},
]


func get_theme_id(name):
	for id in range(themes.size()):
		if themes[id][NAME] == name:
			return id
	return -1

func get_subject_id(name):
	for id in range(subjects.size()):
		if subjects[id][NAME] == name:
			return id
	return -1

func get_theme_name(id):
	return themes[id][NAME]

func get_subject_name(id):
	return subjects[id][NAME]

func get_theme_icon(id):
	return themes[id][ICON]

func get_subject_icon(id):
	return subjects[id][ICON]

func get_theme_info(id):
	return themes[id][INFO]

func get_subject_info(id):
	return subjects[id][INFO]

func get_theme_dependencies(id):
	return themes[id][DEPEN]
