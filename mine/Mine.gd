extends Control


func _input(event):
	if event.is_pressed() and (event is InputEventScreenTouch or event is InputEventMouseButton):
		if $Timer.time_left <= 0:
			play_mining_animation()
			$HUD.add_money(10)


func play_mining_animation():
	$Timer.start()
	$AnimationPlayer.play("mine")


func _on_SaveTimer_timeout():
	Save.save_game()


func _on_HUD_on_Back_pressed():
	$SaveTimer.stop()
	Save.save_game()
	var e = get_tree().change_scene("res://City.tscn")
	if e != 0:
		print("City scene couldn't be loaded")
