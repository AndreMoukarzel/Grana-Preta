extends Control


func _on_Back_pressed():
	var e = get_tree().change_scene("res://City.tscn")
	if e != 0:
		print("City scene couldn't be loaded")
