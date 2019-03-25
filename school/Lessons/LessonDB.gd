extends Node

const NAME = 0
const TYPE = 1 # info or question
const CONTENT = 2


var lessons = [
	{
		NAME : "Basic Stuff",
		TYPE : "info",
		CONTENT : ["Blablabla",
					"acoes_codigos_001.png",
					"acoes_codigos_002.png",
					"Kokoko\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nsdçfaljksdflçaskj"]
	},
	{
		NAME : "Advanced Stuff",
		TYPE : "info",
		CONTENT : ["Hihi"]
	}
]


func get_lesson_id(name):
	for id in range(lessons.size()):
		if lessons[id][NAME] == name:
			return id
	return -1

func get_lesson_name(id):
	return lessons[id][NAME]

func get_lesson_type(id):
	return lessons[id][TYPE]

func get_lesson_content(id):
	return lessons[id][CONTENT]
