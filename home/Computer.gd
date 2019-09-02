extends Control

const ID_SCN = preload("res://home/IndexDisplay.tscn")

func _ready():
	var SelicGraph     = ID_SCN.instance()
	var InflationGraph = ID_SCN.instance()
	
	add_child(SelicGraph)
	SelicGraph.set_current_graph("LineGraph", Save.selic_last100, Vector2(10, 70),
	                             {"size" : Vector2(556, 500)})
	add_title_to_graph("Selic", SelicGraph)
	
	add_child(InflationGraph)
	InflationGraph.set_current_graph("LineGraph", Save.inflation_last100, Vector2(10, 640), 
	                                 {"size" : Vector2(556, 500), "color" : Color(1, .1, .1, .8)})
	add_title_to_graph("Inflação", InflationGraph)


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
	l.rect_size = Vector2(556, 1)
	l.rect_position = Vector2(10, Graph.current_graph.pos.y - 45)
	Graph.add_child(l)


func _on_HUD_on_Back_pressed():
	var e = get_tree().change_scene("res://City.tscn")
	if e != 0:
		print("City scene couldn't be loaded")
