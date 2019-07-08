extends CanvasLayer

signal on_Back_pressed


func _ready():
	update_money_display()

func set_arrow_texture():
	$Back.texture_normal = load("res://back_arrow.png")

func set_city_texture():
	$Back.texture_normal = load("res://city_icon.png")

func add_money(value : int, pos = Vector2(256, 512)):
	Save.money += value
	Save.save_game()
	
	var coins = []
	for i in range(5 + (randi() % 10)):
		var sprite = Sprite.new()
		var final_pos = pos - Vector2(randi() % 70, randi() % 70) + Vector2(randi() % 70, randi() % 70)
		coins.append(sprite)
		sprite.texture = load("res://small_coin.png")
		sprite.position = pos
		sprite.modulate = Color(1, 1, 1, .8)
		add_child(sprite)
		$Tween.interpolate_property(sprite, "position", null, final_pos, .5, Tween.TRANS_QUAD, Tween.EASE_IN)
		$Tween.interpolate_property(sprite, "position", final_pos, $Money.rect_position + Vector2(80, 50), 1.0, Tween.TRANS_ELASTIC, Tween.EASE_IN, .7)
	$Tween.start()
	var timer = Timer.new()
	timer.wait_time = 1.7
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	for coin in coins:
		coin.queue_free()
	timer.queue_free()
	
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
