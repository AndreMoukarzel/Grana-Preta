extends Control

const SCHOOL_DB = preload("res://school/SchoolDB.gd")
const THEME_SCN = preload("res://school/Themes/Theme.tscn")
const INITIAL_Y = 50
const DIST_Y = 150
const DIST_X = 100

onready var total_size = OS.get_window_size().x - 100

var tree_height = [[]]


func _ready():
	add_themes()
	position_themes()


func add_themes():
	var db = SCHOOL_DB.new()
	
	for id in range(db.themes.size()):
		var Theme = THEME_SCN.instance()
		var theme_name = db.get_theme_name(id)
		var icon = db.get_theme_icon(id)
		var dependencies = db.get_theme_dependencies(id)
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
		var size = total_size/(height.size() + 1)
		var i = 1
		for theme in height:
			get_node(theme).rect_position.x = size * i
			i += 1
