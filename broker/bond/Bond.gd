extends Button

signal opened(parent)
signal closed(parent)

const FONT_WIDTH = 15
const BASE_HEIGHT = 80
const TWN_TIME = .2
const SUBJECT_LESSON_SCN = preload("res://school/Subjects/SubjectLesson.tscn")

var is_open = false


func setup():
	rect_size = Vector2(get_parent().rect_size.x, 70)


func _on_Bond_pressed():
	if is_open:
		close()
	else:
		open()


func close():
	$Tween.interpolate_property($Name, "rect_position:x", null, 10, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "rect_size:y", null, 70, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
	is_open = false
	emit_signal("closed", get_parent())


func open():
	$Tween.interpolate_property($Name, "rect_position:x", null, (rect_size.x - $Name.rect_size.x)/2, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "rect_size:y", null, 300, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
	is_open = true
	emit_signal("opened", get_parent())
