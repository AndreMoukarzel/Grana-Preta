extends Node

const NAME = 0
const TYPE = 1 # info or question
const CONTENT = 2 # In questions, CONTENT is organizes as [[Question 1], [[Answer1],[Answer2],...], Question 2, [Answers]....] and the first
                  # answer is always the correct one
const LOCKTIME = 3 # [Days, Hours, Minutes]


var lessons = [
	{
		NAME : "Lições e Questionários",
		TYPE : "info",
		CONTENT : ["\nParabéns, você acabou de completar sua primeira lição!\n\nIsso mesmo, ler uma lição é o suficiente para completá-la.",
					"\nPor concluir uma Lição (ou Questionário) pela primeira vez você\nrecebeu um prêmio de G$ 100!",
					"\nLições e Questionários são parte de Assuntos, sobre os quais vamos\nfalar mais na próxima lição.\n",
					"Licoes e Questionarios/1.png",
					"\nA imagem acima deve ser parecida com o Assunto que você acabou\nde entrar.\n\nLições VERDES foram concluídas.\nLições CINZAS ainda não foram concluídas.\nLições AZUIS são, na verdade, Questionários.",
					"\nQuestionários são mais complicados de completar que Lições\ncomuns. Ao entrar em um Questionário, SAIR ANTES DE CONCLUI-LO\nRESULTARÁ EM REPROVAÇÃO.",
					"\nVocê pode ser reprovado em um Questionário por desistência ou\npor errar as respostas, mas ambos farão com que ele fique\n travado por algum tempo, então se esforce para acertar tudo de\n primeira!"
				  ]
	},
	{
		NAME : "Assuntos e Temas",
		TYPE : "info",
		CONTENT : ["Hihi"]
	},
	{
		NAME : "O Primeiro Teste",
		TYPE : "question",
		CONTENT : [
				["Do you like cheese?"], [["Chesse is spoiled milk.", "And I hate it."], ["Yes"], ["No"]], 
#				["Is Jesus your lord and savior?"], [["I'm a JEW"], ["What?"], ["I'm alergic to mexicans"], ["Yea he actually is."]],
#				["Did this questionnaire work?"], [["FUCK YEA!"], ["acoes_codigos_001.png"]]
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