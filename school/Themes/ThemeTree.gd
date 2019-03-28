extends Control

const SCHOOL_DB = preload("res://school/SchoolDB.gd")
const THEME_SCN = preload("res://school/Themes/Theme.tscn")
const INITIAL_Y = 50
const DIST_Y = 150
const DIST_X = 100
const LINE_C = Color(0, 0, 0)
const LINE_W = 2.5

onready var total_size = OS.get_window_size().x - 100

var tree_height = [[]]


func _ready():
	add_themes()
	position_themes()
	lock_themes()
	set_camera_limits()
	update()


func _draw():
	draw_lines()


func add_themes():
	var db = SCHOOL_DB.new()
	
	for id in range(db.themes.size()):
		var Theme = THEME_SCN.instance()
		var theme_name = db.get_theme_name(id)
		var icon = db.get_theme_icon(id)
		var height = db.get_theme_height(id)
		
		Theme.set_name(theme_name)
		Theme.rect_position.y = INITIAL_Y + height * DIST_Y
		add_child(Theme)
		Theme.setup(theme_name, icon)
		
		if tree_height.size() <= height:
			tree_height.append([])
		tree_height[height].append(theme_name)


func position_themes():
	for height in tree_height:
		var size = max(DIST_X, total_size/(height.size() + 1))
		var i = 1
		for theme in height:
			get_node(theme).rect_position.x = size * i
			i += 1


func lock_themes():
	var db = SCHOOL_DB.new()
	
	for height in tree_height:
		for theme in height:
			var id = db.get_theme_id(theme)
			var dependencies = db.get_theme_dependencies(id)
			
			if dependencies.empty():
				get_node(theme).unlock()
				continue
			for depen in dependencies:
				var depen_id = db.get_theme_id(depen)
				if not Save.completed_themes.has(depen_id): # Dependency not completed
					get_node(theme).lock()
					break


func set_camera_limits():
	var Cam = $SwipeHandler/SwipingCamera
	var max_y = tree_height.size() * DIST_Y + 2 * INITIAL_Y
	var max_x = 0
	
	for height in tree_height:
		max_x = max(max_x, height.size())
	max_x = max_x * DIST_X
	
	max_x = max(max_x, OS.get_window_size().x)
	max_y = max(max_y, OS.get_window_size().y)
	Cam.limit_bottom = max_y
	Cam.limit_right = max_x


func draw_lines():
	var db = SCHOOL_DB.new()
	
	for id in range(db.themes.size()):
		var theme_name = db.get_theme_name(id)
		var dependencies = db.get_theme_dependencies(id)
		var theme1 = get_node(theme_name)
		var pos1 = theme1.rect_position + theme1.texture_normal.get_size()/2
		
		for dependency in dependencies:
			var theme2 = get_node(dependency)
			var pos2 = theme2.rect_position + theme2.texture_normal.get_size()/2
			var avg_y = (pos1.y + pos2.y)/2
			
			draw_line(pos1, Vector2(pos1.x, avg_y), LINE_C, LINE_W)
			draw_line(Vector2(pos1.x, avg_y), Vector2(pos2.x, avg_y), LINE_C, LINE_W)
			draw_line(Vector2(pos2.x, avg_y), pos2, LINE_C, LINE_W)
