extends Control

var values = []
var v_scale = 20
var h_scale = 10

func _ready():
	var Index = load("res://Index.gd").new()
	
	Index.create(10.0, 2.0, 6.0, 15.0)
	position_labels()
	values.append(10.0)
	for i in range(100):
		Index.iterate()
		values.append(Index.value)
	update()

func _draw():
	var zero_pos = $Bot.rect_position.y + 6.0 * v_scale
	for i in range(1, values.size()):
		var p1 = Vector2((i - 1) * h_scale + h_scale, zero_pos - values[i-1] * v_scale)
		var p2 = Vector2(i * h_scale + h_scale, zero_pos - values[i] * v_scale)
		draw_line(p1, p2, Color(1, 1, 1), 1.0, true)


func position_labels():
	$Bot.rect_position.y = 600
	$Mid.rect_position.y = 600 - (10.0 - 6.0) * v_scale
	$Top.rect_position.y = 600 - (15.0 - 6.0) * v_scale