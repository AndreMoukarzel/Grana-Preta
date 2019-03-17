extends Control


func _on_TextureButton_pressed():
	print("pressed button")


func _on_School_pressed():
	print("Enter School")
	get_tree().change_scene("res://school/School.tscn")


func _on_House_pressed():
	print("Enter House")
	get_tree().change_scene("res://House.tscn")
