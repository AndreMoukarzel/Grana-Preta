extends Button

const FONT_WIDTH = 15
const BASE_HEIGHT = 100


func _ready():
	setup(400, "xatubabcdefghij", null, ["Basic Stuff", "Jamaica"])


func setup(width, name, icon, info):
	var title = name
	
	rect_size = Vector2(width, BASE_HEIGHT)
	$Background.rect_size = Vector2(width, BASE_HEIGHT)
	$Title.rect_size = Vector2(0.66 * width, BASE_HEIGHT)
	$Title.text = title
	$Icon.rect_position = Vector2(rect_size.x - BASE_HEIGHT, 15)
	$Icon.rect_size = Vector2(0.34 * width, BASE_HEIGHT - 15)
	
	clip_title()
	add_icon(icon)


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


func _on_Subject_pressed():
	print("pressed")
