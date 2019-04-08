extends Node

const NAME = 0
const TYPE = 1 # info or question
const CONTENT = 2 # In questions, CONTENT is organizes as [[Question 1], [[Answer1],[Answer2],...], Question 2, [Answers]....] and the first
                  # answer is always the correct one
const LOCKTIME = 3 # [Days, Hours, Minutes]


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
	},
	{
		NAME : "Important Questions",
		TYPE : "question",
		CONTENT : [
				["Do you like cheese?"], [["Chesse is spoiled milk.", "And I hate it."], ["Yes"], ["No"]], 
				["Is Jesus your lord and savior?"], [["I'm a JEW"], ["What?"], ["I'm alergic to mexicans"], ["Yea he actually is."]],
				["Did this questionnaire work?"], [["FUCK YEA!"], ["ye"]]
				],
		LOCKTIME : [0, 0, 1]
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

func get_questionnaire_locktime(id):
	return lessons[id][LOCKTIME]