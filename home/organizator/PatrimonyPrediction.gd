extends Control

const ID_SCN = preload("res://home/IndexDisplay.tscn")

func _ready():
	var PatrimonyGraph = ID_SCN.instance()
	var prediction = calculate_prediction()
	
	add_child(PatrimonyGraph)
	PatrimonyGraph.set_current_graph("LineGraph", prediction, Vector2(10, 200),
	                             {"size" : Vector2(400, 500)})
	add_title_to_graph("Patrimônio previsto", PatrimonyGraph)


func calculate_prediction():
	return [0, 1, 2]

func add_title_to_graph(title : String, Graph):
	var Bg = Graph.get_node("Background")
	var l = Label.new()
	var text_font
	
	Bg.rect_size     += Vector2(0, 40)
	Bg.rect_position -= Vector2(0, 40)
	text_font            = DynamicFont.new()
	text_font.size       = 40
	text_font.font_data  = load("res://school/Lessons/LessonFont.otf")
	text_font.use_filter = true
	l.set("custom_fonts/font", text_font)
	l.add_color_override("font_color", Color(0, 0, 0))
	l.align = Label.ALIGN_CENTER
	l.text = title
	l.rect_size = Vector2(400, 1)
	l.rect_position = Vector2(10, Graph.current_graph.pos.y - 45)
	Graph.add_child(l)
