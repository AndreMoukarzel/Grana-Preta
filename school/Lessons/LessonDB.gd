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
				["A imagem a seguir representa:", "/../Themes/Icons/school_icon.png"], [["Tema"], ["Assunto"], ["Lição"], ["Questionário"]],
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
		CONTENT : ["\nSe você já trabalhou na mina, deve ter percebido que não é um\ntrabalho extremamente lucrativo...",
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
	{
		NAME : "Comprando Ativos",
		TYPE : "info",
		CONTENT : [ "\nNa corretora você pode comprar e vender ativos de RENDA FIXA.\nPara isso, basta tocar no botão 'APLICAR' em um ativo a venda.",
					"\nApertando o botão, você deverá selecionar quantos G$ do ativo\nvocê vai comprar. Você pode adicionar(+) e remover(-) o número\nindicado no MULTIPLICADOR à direita.",
					"Você também pode tocar diretamente no MULTIPLICADOR para\nalterar o seu valor.\n",
					"Images/Multiplicador.png",
					"\nTambém tem mais um detalhe... Para todo ativo, há um valor\nmínimo de compra. Este valor é chamado REQUISITO.\n",
					"Images/Requisito.png",
					"\nO REQUISITO é um elemento de ativos da vida real também, então\nvocê pode dar uma olhada na sua corretora ou banco preferido e\nverificar o valor mínimo de compra dos ativos lá!",
					"Alguns títulos de renda fixa da via real têm requisitos baixos, algo\nem torno de R$ 30, enquanto outros podem ter requisitos de\nmais de R$ 50000."
				  ]
	},
	{
		NAME : "Qual comprar?",
		TYPE : "info",
		CONTENT : [ "\nCom tantas opções, como decidir qual título comprar?",
					"\nBom, vamos por partes:\n",
					"\nPrimeiro, devemos escolher qual tipo de ativo vamos comprar.\nNa corretora, separamos os ativos em SEGUROS, MODERADOS e\nARROJADOS.",
					"Dentro de cada uma dessas categorias temos, respectivamente,\ntítulos Pré-fixados, Pós-fixados e Pós-fixados indexados no\nhistórico de um fundo privado. Se você não sabe o que são cada\numa dessas coisas, é comece com os títulos seguros.",
					"Vamos explicar cada uma dessas classificações em Lições futuras.",
					"\nEm seguida, vamos dar uma olhada na rentabilidade dos ativos.\nA rentabilidade já é um bom indicativo de quão lucrativo\num título será!",
					"Images/Rentabilidade.png",
					"\nNa rentabilidade temos as informações do tipo de título:\n* PRE = Pré-fixado\n* POS = Pós-fixado\n* PROV = Pós-fixado indexado em fundo privado (provisionado)",
					"\nAssim como títulos reais costumam apresentar uma previsão da\nrentabilidade anual, o valor numérico da rentabilidade aqui\nrepresenta a valorização prevista do ativo em 5 DIAS.\n",
					"Para acelerar as coisas, enquanto um título real rende diariamente,\n os seus títulos aqui vão render a cada 4 HORAS!.",
					"\nMas além da rentabilidade, também é importante manter em mente\nos impostos que serão cobrados!\n",
					"Images/Impostos.png",
					"\nIsso deve ser o suficiente para fazer uma boa escolha. Caso tenha\ndúvidas sobre os detalhes de rentabilidade e impostos,\nhá uma explicação aprofundada sobre eles no tema de Renda Fixa"
				  ]
	},
	{
		NAME : "Vendendo Ativos",
		TYPE : "info",
		CONTENT : [ "\nCaso você já tenha sido dono de um título de renda fixa por algum\ntempo, pode ter acontecido dele ter desaparecido!",
					"\nNão se preocupe, isso não é um bug do sistema! O que acontece\né que títulos de renda fixa aqui, assim como na vida real, têm\nVALIDADE!\n",
					"Images/Vencimento.png",
					"\nFora isso, você também deve ter notado que é impossível vender um\ntítulo recém comprado. Isso é porque títulos de renda fixa têm\noutra característica importante. A CARÊNCIA!\n",
					"Images/Carencia.png",
					"Note que até se passar o período de CARÊNCIA, não será possível\nvender este título!",
					"\nBom, agora você já sabe de tudo isso e está pronto para vender\num título. E agora? Bom, basta tocar em VENDER e escolher a\nquantidade, assim como você fez na hora da compra.",
					"\nMas fique alerta! Ao vender um título com lucro, você deve pagar\nseus IMPOSTOS! Não se preocupe, vamos falar melhor disso no\npróximo assunto.\nBons negócios!"
				  ]
	},
	{
		NAME : "Agora é pra Render!",
		TYPE : "question",
		CONTENT : [
				["Comprei um ativo faz alguns dias, e quando\nfui vendê-lo ele tinha sumido!\nO que aconteceu?"], [["O título passou do período de vencimento"], ["Você só se confundiu! Não tinha ativo\nnenhum ali!"], ["Ocorreu um erro de sistema"]],
				["Depois de quanto tempo posso vender\num ativo?"], [["Depois do período de custódia"], ["Assim que tiver comprado um ativo"], ["Após 4 horas"], ["Após 1 dia"]], 
				["O que define se um título será mais lucrativo\nque outro no mesmo período de tempo?"], [["Rentabilidade e Impostos"], ["Requisito e Carência"], ["Apenas o tipo do título"], ["As cores dos botões"]],
				["Como é a forma correta de ordenar os tipos\nde título de renda fixa,\ndo menos arriscado ao mais arriscado?"], [["1)Pré-Fixada\n2)Pós-fixada\n3)Pós-fixada em índice privado"], ["1)Pós-fixada\n2)Pré-Fixada\n3)Pós-fixada em índice privado"], ["1)Pós-fixada em índice privado\n2)Pós-fixada\n3)Pré-Fixada"]],
				],
		LOCKTIME : [0, 0, 1]
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