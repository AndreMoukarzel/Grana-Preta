extends Control

signal add_element(ammount)
signal canceled()

var ammount : String = "0"


func _on_Pad_value_changed(value):
	ammount = value
	$Ammount/AmmountLabel.text = str(ammount)

func _on_Cancel_pressed():
	emit_signal("canceled")
	queue_free()


func _on_Confirm_pressed():
	emit_signal("add_element", ammount)
	queue_free()
