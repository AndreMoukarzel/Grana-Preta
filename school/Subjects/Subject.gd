extends Button

signal opened(parent)
signal closed(parent)

const FONT_WIDTH = 15
const BASE_HEIGHT = 80
const TWN_TIME = .2
const SUBJECT_LESSON_SCN = preload("res://school/Subjects/SubjectLesson.tscn")

var width : int
var title : String
var is_open = false
var lessons_height = 0


func setup(width : int, name, icon, lessons):
	self.title = name
	self.width = width
	
	rect_size = Vector2(width, BASE_HEIGHT)
	$Lessons.rect_scale = Vector2(1, 0)
	$Lessons.rect_position.y = BASE_HEIGHT
	$Background.rect_size = Vector2(width, BASE_HEIGHT)
	$Title.rect_size = Vector2(0.66 * width, BASE_HEIGHT)
	$Title.text = title
	$Icon.rect_position = Vector2(rect_size.x - BASE_HEIGHT, 5)
	$Icon.rect_size = Vector2(0.34 * width, BASE_HEIGHT - 10)
	
	clip_title()
	add_icon(icon)
	add_lessons(lessons)


func clip_title():
	if $Title.text.length() * FONT_WIDTH > $Title.rect_size.x:
		var dif = ($Title.text.length() * FONT_WIDTH) - $Title.rect_size.x
		var extra_num = dif/FONT_WIDTH # number of extra characters
		var new_text = $Title.text
		
		new_text.erase(new_text.length() - (extra_num + 2), extra_num + 3)
		$Title.text = new_text + "..."


func add_icon(icon_location):
	var texture
	var tex_size
	var scale = 1
	
	if not icon_location:
		texture = load("res://icon.png")
	else:
		texture = load(icon_location)
	
	tex_size = texture.get_size()
	if $Icon.rect_size.x < tex_size.x:
		scale = $Icon.rect_size.x / tex_size.x
	elif $Icon.rect_size.y < tex_size.y:
		scale = $Icon.rect_size.y / tex_size.y
	$Icon.texture = texture
	$Icon.rect_size = tex_size * scale
	$Icon.rect_position.y = (rect_size.y - $Icon.rect_size.y)/2


func add_lessons(lessons):
	var total_height = 0
	
	for lesson in lessons:
		var instance = SUBJECT_LESSON_SCN.instance()
		
		$Lessons.add_child(instance)
		instance.setup(lesson, Vector2(width - 20, 40))
		total_height += instance.rect_size.y + 10
	lessons_height = total_height


func _on_Subject_pressed():
	if is_open:
		close()
	else:
		open()


func close():
	$Tween.interpolate_property($Lessons, "rect_scale:y", null, 0, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Background, "rect_size:y", null, BASE_HEIGHT, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
	is_open = false
	emit_signal("closed", get_parent())


func open():
	$Tween.interpolate_property($Lessons, "rect_scale:y", null, 1, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Background, "rect_size:y", null, BASE_HEIGHT + lessons_height + 10, TWN_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	
	is_open = true
	emit_signal("opened", get_parent())