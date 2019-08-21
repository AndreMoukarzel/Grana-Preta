extends Control

const ID_SCN = preload("res://home/IndexDisplay.tscn")

func _ready():
	var SelicGraph     = ID_SCN.instance()
	var InflationGraph = ID_SCN.instance()
	
	add_child(SelicGraph)
	SelicGraph.set_current_graph("LineGraph", Save.selic_last100, Vector2(0, 10))
	
	add_child(InflationGraph)
	InflationGraph.set_current_graph("LineGraph", Save.inflation_last100, Vector2(0, 600), 
	                                 {"color" : Color(1, .1, .1, .8)})