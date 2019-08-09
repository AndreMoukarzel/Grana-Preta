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
				["A imagem a seguir representa:", "/../school_icon.png"], [["Tema"], ["Assunto"], ["Lição"], ["Questionário"]],
				["Como se conclui um Assunto?"], [["Completar todas as Lições do Assunto"], ["Completar o Questionário do Assunto"], ["Fazer uma dancinha"]]
				],
		LOCKTIME : [0, 0, 1]
	},
	{
		NAME : "O Emprego",
		TYPE : "info",
		CONTENT : ["\nVocê conseguiu arrumar um emprego estável nas minas!",
					"\nPode não ser a coisa mais glamurosa ou com maior expectativa de\nvida do mundo, mas você tem a minha garantia de que não será\ndemitido daqui!",
					"\nA mina é o local mais simples da cidade. Tudo que você pode\nfazer aqui é tocar na tela para trabalhar, ganhando G$10 por toque.",
					"\nMas não adianta tocar na tela na velocidade da luz! Querendo\nou não, há um limite de quão rápido você pode trabalhar...",
					"As minas são uma analogia para empregos da vida real. Empregos\nsão relativamente seguros, mas você não deve ser dependente deles!",
					"\nEnfim, chega de papo, de volta ao trabalho!",
					"/../../mine/Mine.png"
				  ]
	},
	{
		NAME : "Por que minerar?",
		TYPE : "info",
		CONTENT : ["\nSe você já trabalhou na minha, deve ter percebido que não é um\ntrabalho extremamente lucrativo...",
					"Isso é porque seu objetivo aqui não é se matar de trabalhar até\nficar rico, e sim aprender a viver de sua renda passiva!",
					"\nEntão quando devo minerar? Bom, você sempre pode minerar se\nachar divertido, mas na prática só vale a pena passar um tempo",
					"nas minas quando você precisar de uma graninha extra, seja para\nter dinheiro o suficiente para comprar um ativo legal, ou para\najudar a pagar suas dívidas mais rápido!",
					"\nSe você está perdido com essa conversa de ativos e dívidas, não\nse preocupe! Em Lições futuras, tudo isso será explicado."
				  ]
	},
	{
		NAME : "Leite de Pedra",
		TYPE : "question",
		CONTENT : [
				["Quanto você recebe por toque da tela nas\nminas?"], [["G$ 10"], ["G$ 100"], ["G$ 50"]],
				["Em qual situação faz mais sentido trabalhar\nna mina?"], [["Conseguir o dinheiro restante para pagar\nminhas dívidas"], ["Nunca"], ["Sempre que tiver tempo, para ficar rico\nmais rápido"]], 
				["As minas são uma analogia para qual aspecto\nda vida real?"], [["Empregos"], ["Ações"], ["Poupança"], ["Higiene Bucal"]],
				],
		LOCKTIME : [0, 0, 5]
	},
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