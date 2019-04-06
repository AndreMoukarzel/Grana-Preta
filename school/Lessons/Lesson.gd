extends Control


const OFFSET = Vector2(10, 5)
const TEXT_OFFSET = 10

var text_font

func _ready():
	rect_size = OS.get_window_size() - OFFSET
	rect_position = OFFSET/2
	$Title.rect_size.x = OS.get_window_size().x - OFFSET.x
	text_font = DynamicFont.new()
	text_font.size = 20
	text_font.font_data = load("res://school/Lessons/LessonFont.otf")
	text_font.use_filter = true


# Must be setup after being added to tree, or label height will be gotten incorrectly
func setup(name, content):
	var title_height = add_title(name)
	var total_height = add_content(title_height + 30, content)
	var LocalCamera = $SwipeHandler/SwipingCamera
	
	rect_size.y = total_height + 25
	LocalCamera.limit_right = OS.get_window_size().x
	LocalCamera.limit_bottom = total_height + 10
	set_height(total_height)


func set_height(height):
	var h = max(OS.get_window_size().y, height)
	rect_size.y = h


func add_title(title):
	$Title.text = title
	
	return $Title.rect_size.y


func add_text(content, pos_y):
	var l = Label.new()
	
	l.add_color_override("font_color", Color(0, 0, 0))
	l.rect_position = Vector2(TEXT_OFFSET, pos_y)
	l.text = content
	l.set("custom_fonts/font", text_font)
	add_child(l)
	
	return l.rect_size.y


func add_image(texture_name, pos_y):
	var texture = load(str("res://school/Lessons/", texture_name))
	var tr = TextureRect.new()
	var tex_size = texture.get_size()
	
	tr.texture = texture
	if tex_size.x > OS.get_window_size().x:
		var scale = OS.get_window_size().x/tex_size.x
		tex_size *= scale
		tr.expand = true
		tr.rect_size = tex_size
	tr.rect_position = Vector2((OS.get_window_size().x - tex_size.x)/2, pos_y)
	add_child(tr)
	
	return tex_size.y


func add_content(initial_height, content):
	var hpos = initial_height
	
	for c in content:
		if c.find(".png") != -1: # is an image
			hpos += add_image(c, hpos) + 5
		else:
			hpos += add_text(c, hpos) + 5
	
	return hpos