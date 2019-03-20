extends Control


const OFFSET = Vector2(10, 5)
const TEXT_OFFSET = 10


func _ready():
	rect_size = OS.get_window_size() - OFFSET
	rect_position = OFFSET/2
	add_content(["blabla", "Image.png", "Mingau"])

func add_content(content):
	var hpos = 10
	
	for c in content:
		if c.find(".png") != -1: # is an image
			var texture = load(str("res://school/Lessons/", c))
			var tr = TextureRect.new()
			var tex_size = texture.get_size()
			tr.texture = texture
			tr.rect_position = Vector2((OS.get_window_size().x - tex_size.x)/2, hpos)
			add_child(tr)
			
			hpos += tex_size.y + 5
		else:
			var l = Label.new()
			l.add_color_override("font_color", Color(0, 0, 0))
			l.rect_position = Vector2(TEXT_OFFSET, hpos)
			l.text = c
			add_child(l)
			
			hpos += l.rect_size.y + 5