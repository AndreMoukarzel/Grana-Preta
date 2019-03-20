extends Node

const NAME = 0
const ICON = 1
const INFO = 2 # subjects in themes and lessons in subjects
const DEPEN = 3 # dependencies for themes


var themes = [
	{ # ID = 0
		NAME : "The School",
		ICON : null,
		INFO : ["Test"],
		DEPEN : []
	},
]

var subjects = [
	{ # ID = 0
		NAME : "Test",
		ICON : null,
		INFO : ["Basic Stuff", "Jamaica"],
	},
]


var theme_name_map = { }
var subject_name_map = {}

func _ready():
	for id in range (themes.size()):
		theme_name_map[themes[id][NAME]] = id
	for id in range (subjects.size()):
		subject_name_map[subjects[id][NAME]] = id

func get_theme_id(name):
	return theme_name_map[name]

func get_subject_id(name):
	return subject_name_map[name]

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
