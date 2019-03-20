extends Node

const NAME = 0
const TYPE = 1 # info or question
const CONTENT = 2


var lessons = [
	{ # ID = 0
		NAME : "Basic Stuff",
		TYPE : "info",
		CONTENT : ["Blablabla",
					"Image.png",
					"Kokoko"]
	},
]


var name_map = { }

func _ready():
	for id in range (lessons.size()):
		name_map[lessons[id][NAME]] = id

func get_lesson_id(name):
	return name_map[name]

func get_lesson_name(id):
	return lessons[id][NAME]

func get_lesson_type(id):
	return lessons[id][TYPE]

func get_lesson_content(id):
	return lessons[id][CONTENT]
