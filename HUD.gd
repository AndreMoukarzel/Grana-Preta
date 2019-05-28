extends CanvasLayer

signal on_Back_pressed


func _ready():
	update_money_display()

func set_arrow_texture():
	$Back.texture_normal = load("res://back_arrow.png")

func set_city_texture():
	$Back.texture_normal = load("res://city_icon.png")

func add_money(value : int):
	Save.money += value
	Save.save_game()
	update_money_display()

func subtract_money(value : int):
	Save.money -= value
	Save.save_game()
	update_money_display()

func update_money_display():
	var dict = ['M', 'Mi', 'B', 'T', 'Q', 'Qi']
	var index = -1
	var money = Save.money
	
	print(money)
	if money < 10000:
		$Money/Label.text = str(money)
	else:
		while money > 1000:
			money = float(money)/1000.0
			index += 1
		if index >= dict.size():
			index = index % dict.size()
			$Money/Label.text = str(stepify(money, 0.1), 'M', dict[index])
		else:
			$Money/Label.text = str(stepify(money, 0.1), dict[index])


func _on_Back_pressed():
	emit_signal("on_Back_pressed")
