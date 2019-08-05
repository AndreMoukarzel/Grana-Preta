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
					"\nAo concluir uma Lição (ou Questionário) pela primeira vez você\nreceberá um prêmio de G$ 100!",
					"\nLições e Questionários são parte de Assuntos, sobre os quais vamos\nfalar mais na próxima lição.\n",
					"Images/1.png",
					"\nA imagem acima deve ser parecida com o Assunto que você acabou\nde entrar.\n\nLições VERDES foram concluídas.\nLições CINZAS ainda não foram concluídas.\nLições AZUIS são, na verdade, Questionários.",
					"\nQuestionários são mais complicados de completar que Lições\ncomuns. Ao entrar em um Questionário, responder as questões\ncorretamente para ser aprovado. Errar perguntas ou sair antes de\nterminar fará com que o Questionário fique bloqueado por um\ntempo.",
					"\nEntão se esforce para acertar tudo de primeira!"
				  ]
	},
	{
		NAME : "Assuntos e Temas",
		TYPE : "info",
		CONTENT : ["\n\nAo completar todas as Lições de um Assunto, você terá concluído\no Assunto e receberá um prêmio de G$ 1000.",
					"\nAo completar todos os Assuntos de um Tema, você terá concluído\num Tema e receberá um prêmio de G$ 10000.\n",
					"Images/2.png",
					"\nCompletar um Assunto ou Tema envolve mais trabalho do que\ncompletar uma Lição, e por isso seus prêmios são maiores.",
					"\nAo completar o Questionário a seguir, você terá concluído o Assunto\n'Onde Estou?', e sendo este o único assunto do Tema 'A Escola',\nvocê completará o Tema também!",
					"\nBoa sorte!"]
	},
	{
		NAME : "O Primeiro Teste",
		TYPE : "question",
		CONTENT : [
				["Qual o prêmio por concluir um Assunto?"], [["G$ 1000"], ["G$ 100"], ["G$ 10000"]],
				["Qual o prêmio por concluir um Tema?"], [["G$ 10000"], ["G$ 100"], ["G$ 1000"]], 
				["A seguinte imagem a seguir representa:", "/../school_icon.png"], [["Tema"], ["Assunto"], ["Lição"], ["Questionário"]],
				["Como se conclui um Assunto?"], [["Completar todas as Lições do Assunto"], ["Completar o Questionário do Assunto"], ["Fazer uma dancinha"]]
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