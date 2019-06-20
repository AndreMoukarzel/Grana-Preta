extends Node

const NAME = 0
const ICON = 1
const INFO = 2 # subjects in themes and lessons in subjects
const DEPEN = 3 # dependencies for themes
const HEIGHT = 4 # height of theme on tree


var themes = [
	{
		NAME : "A Escola",
		ICON : "res://school/school_icon.png",
		INFO : ["Test"],
		DEPEN : [],
		HEIGHT : 0
	},
	{
		NAME : "A cidade",
		ICON : null,
		INFO : [],
		DEPEN : [],
		HEIGHT : 1
	},
	{
		NAME : "Fixa 1",
		ICON : null,
		INFO : [],
		DEPEN : [],
		HEIGHT : 2
	},
	{
		NAME : "Variável 1",
		ICON : null,
		INFO : [],
		DEPEN : [],
		HEIGHT : 2
	}
]

var subjects = [
	{
		NAME : "Test",
		ICON : null,
		INFO : ["Basic Stuff", "Advanced Stuff", "Important Questions"],
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

func get_lesson_subject(lesson_name): # returns id of subject containing lesson_name
	for id in range(subjects.size()):
		for lesson in subjects[id][INFO]:
			if lesson == lesson_name:
				return id
	return -1

func get_theme_dependencies(id):
	return themes[id][DEPEN]

func get_theme_height(id):
	return themes[id][HEIGHT]

func get_subject_theme(subject_name): # returns id of theme containing subject_name
	for id in range(themes.size()):
		for subject in themes[id][INFO]:
			if subject == subject_name:
				return id
	return -1
