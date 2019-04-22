extends Control

var values = []
var v_scale = 20
var h_scale = 10
onready var Index = load("res://Index.gd").new()

func _ready():
	
	Index.create(3.0, 1.0, -0.5, 10.0)
	position_labels()
	values.append(Index.value)
	for i in range(100):
		Index.iterate()
		values.append(Index.value)
	update()

func _draw():
	var zero_pos = $Bot.rect_position.y + Index.bot_value * v_scale
	for i in range(1, values.size()):
		var p1 = Vector2((i - 1) * h_scale + h_scale, zero_pos - values[i-1] * v_scale)
		var p2 = Vector2(i * h_scale + h_scale, zero_pos - values[i] * v_scale)
		draw_line(p1, p2, Color(1, 1, 1), 1.0, true)


func position_labels():
	var avg = (Index.bot_value + Index.top_value)/2
	$Bot.rect_position.y = 600
	$Mid.rect_position.y = 600 - (avg - Index.bot_value) * v_scale
	$Top.rect_position.y = 600 - (Index.top_value - Index.bot_value) * v_scale