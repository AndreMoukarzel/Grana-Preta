extends Panel

signal pressed()

const ID_SCN = preload("res://home/IndexDisplay.tscn")

func _ready():
	$Current/Money.text = Save.accumulated_patrimony
	
	if float(Save.accumulated_patrimony) > 0.00:
		$Current/Money.modulate = Color(.2, 1, 0)
	else:
		$Current/Money.modulate = Color(1, 0, 0)
	add_patrimony_graph()

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_pos = get_global_mouse_position()
		
		print(mouse_pos)
		if mouse_pos.x >= rect_position.x and mouse_pos.x <= rect_position.x + rect_size.x and \
		   mouse_pos.y >= rect_position.y and mouse_pos.y <= rect_position.y + rect_size.y:
			emit_signal("pressed")

func calculate_prediction():
	var monthly_values = []
	var monthly_diff = "0.00"
	var initial_value = Save.accumulated_patrimony
	
	for el in Save.elements:
		if el.date != null: # Gets how much patrimony will change each month
			monthly_diff = add_values(monthly_diff, el.value)
		else: # Add today's elements to this month's prediction
			initial_value = add_values(initial_value, el.value)
			
	monthly_values.append(float(initial_value))
	monthly_diff = float(monthly_diff)
	for i in range(11):
		monthly_values.append(monthly_values[i] + monthly_diff)
	
	return monthly_values


func add_patrimony_graph():
	var PatrimonyGraph = ID_SCN.instance()
	var prediction = calculate_prediction()
	var graph_size = Vector2(450, 270)
	
	PatrimonyGraph.name = "graph"
	PatrimonyGraph.get_node("BotLeft").text = "Mês atual"
	PatrimonyGraph.get_node("BotRight").text = "12 meses"
	add_child(PatrimonyGraph)
	PatrimonyGraph.set_current_graph("LineGraph", prediction, Vector2((rect_size.x - graph_size.x)/2, 300),
	                             {"size" : graph_size})
	add_title_to_graph("PATRIMÔNIO PREVISTO", PatrimonyGraph)


func update_patrimony_graph():
	var old = get_node("graph")
	
	old.name = "old_graph"
	old.queue_free()
	add_patrimony_graph()


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
	l.rect_position = Vector2(90, Graph.current_graph.pos.y - 45)
	Graph.add_child(l)


func add_values(v1 : String, v2 : String):
	var v1_int = int(v1.split(".")[0])
	var v2_int = int(v2.split(".")[0])
	var v1_float = 0
	var v2_float = 0
	
	if len(v1.split(".")) > 1:
		v1_float = int(v1.split(".")[1])
	if len(v2.split(".")) > 1:
		v2_float = int(v2.split(".")[1])
	
	var sum_int = v1_int + v2_int
	var sum_float = v1_float + v2_float
	
	if sum_float >= 100:
		sum_float -= 100
		sum_int += 1
	if sum_float < 10:
		sum_float = "0" + str(sum_float)
	
	return str(sum_int) + "." + str(sum_float)
