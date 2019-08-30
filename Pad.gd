extends Control

signal value_changed(value)

var number : String = "0"
var has_dot : bool  = false


func number_pressed(digit : int):
	if not has_dot:
		if number.length() == 1 and number[0] == "0":
			number = str(digit)
		else:
			number += str(digit)
	else:
		var has_two_digits = len(number.split(".")[1]) == 2
		
		if has_two_digits:
			number[-1] = str(digit)
		else:
			number += str(digit)
	print(number)
	print(has_dot)
	emit_signal("value_changed", float(number))


func _on_1_pressed():
	number_pressed(1)

func _on_2_pressed():
	number_pressed(2)

func _on_3_pressed():
	number_pressed(3)

func _on_4_pressed():
	number_pressed(4)

func _on_5_pressed():
	number_pressed(5)

func _on_6_pressed():
	number_pressed(6)

func _on_7_pressed():
	number_pressed(7)

func _on_8_pressed():
	number_pressed(8)

func _on_9_pressed():
	number_pressed(9)

func _on_0_pressed():
	number_pressed(0)


func _on_Minus_pressed():
	if number[0] == "-":
		number.erase(0, 1)
	else:
		number = "-" + number
	emit_signal("value_changed", float(number))

func _on_Dot_pressed():
	if not has_dot:
		has_dot = true
		number += "."
		emit_signal("value_changed", float(number))

func _on_Del_pressed():
	if number[-1] == ".":
		has_dot = false
	number = number.left(number.length() - 1)
	if number.empty():
		number = "0"
	emit_signal("value_changed", float(number))

func _on_Clear_pressed():
	has_dot = false
	number = "0"
	emit_signal("value_changed", float(number))
