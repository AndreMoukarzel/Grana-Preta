extends Control


func _on_TextureButton_pressed():
	print("pressed button")


func _on_School_pressed():
	print("Enter School")
	var e = get_tree().change_scene("res://school/School.tscn")
	if e != 0:
		print("School scene couldn't be loaded")


func _on_House_pressed():
	print("Enter House")
	var e = get_tree().change_scene("res://house/House.tscn")
	if e != 0:
		print("House scene couldn't be loaded")


func _on_Broker_pressed():
	print("Enter Broker")
	var e = get_tree().change_scene("res://broker/Broker.tscn")
	if e != 0:
		print("Broker scene couldn't be loaded")
