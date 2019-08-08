extends Control

var values = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
var v_scale = 20
var h_scale = 10

class LineGraph:
	var values = [0.0] # Values to be plotted in the graph
	var pos = Vector2() # Where the graph will be positioned
	var central_val : float # Value that will be in the midpoint of the graph
	var val_range : float # Distance between top/bottom value and central value
	var total_widht : int # total widht of the graph
	var total_height : int # total height of the graph
	var color : Color # color of the graph's line
	var line_width : float # widht of the graph's line
	
	func _init(values, pos, central_val = null, val_range = null, total_widht = 560,\
	           total_height = 512, color = Color(1, 1, 1), line_width = 1.0):
		self.values = values
		self.pos    = pos
		
		if central_val:
			self.central_val = central_val
		else:
			var avrg = 0.0
			for val in values:
				avrg += val
			avrg /= values.size()
			self.central_val = avrg
		
		if val_range:
			self.val_range = val_range
		else:
			self.val_range = max(abs(values.max() - self.central_val),\
			                     abs(values.min() - self.central_val))
		
		self.total_widht  = total_widht
		self.total_height = total_height
		self.color        = color
		self.line_width   = line_width
	
	func graph_points():
		var current_point = Vector2(self.pos.x, self.pos.y + self.total_height/2)
		var point_dist    = Vector2(self.total_widht/self.values.size(),\
		                         -self.total_height/(self.values.max() - self.values.min())) # point_dist.y is negative because positive values go down visually
		var points = []
		points.append(current_point)
		for i in range(1, self.values.size()):
			current_point += Vector2(point_dist.x, point_dist.y * (self.values[i] - self.values[i-1]))
			points.append(current_point)
		
		return points

func _ready():
	set_process(false)

func _process(delta):
	update()

func _draw():
	var LG = LineGraph.new(values, Vector2(5, 300))
	var points = LG.graph_points()
	
	for i in range(1, points.size()):
		draw_line(points[i-1], points[i], Color(1, 1, 1), 2.0, true)
