extends Control


func _input(event):
	if event.is_pressed() and (event is InputEventScreenTouch or event is InputEventMouseButton):
		if $Timer.time_left <= 0:
			play_mining_animation()
			Save.money += 50


func play_mining_animation():
	$Timer.start()
	$AnimationPlayer.play("mine")


func _on_SaveTimer_timeout():
	Save.save_game()
