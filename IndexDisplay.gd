extends Control

var current_graph = null

class LineGraph:
	var values = [0.0] # Values to be plotted in the graph
	var pos = Vector2() # Where the graph will be positioned
	var central_val : float # Value that will be in the midpoint of the graph
	var val_range : float # Distance between top/bottom value and central value
	var size : Vector2 # total size of the graph
	var color : Color # color of the graph's line
	var line_width : float # width of the graph's line
	var point_dist : Vector2 # distance between points in this graph
	var value_offset = 0 # distance the points will be moved to fit centrally in the graph
	
	func _init(values, pos, central_val = null, val_range = null, size = Vector2(500, 500), \
	           color = Color(0, 0, 1), line_width = 1.0):
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
		
		self.size       = size
		self.color      = color
		self.line_width = line_width
		self.point_dist = Vector2(self.size.x/self.values.size(),\
		                           -self.size.y/(self.values.max() - self.values.min() + 1)) # point_dist.y is negative because positive values go down visually
		var max_diff = self.values.max() - self.central_val
		if -self.point_dist.y * max_diff > self.size.y/2:
			self.value_offset = max_diff - self.size.y/(2*-self.point_dist.y)
		else:
			var min_diff = self.central_val - self.values.min()
			if -self.point_dist.y * min_diff > self.size.y/2:
				self.value_offset = -(min_diff - self.size.y/(2*-self.point_dist.y))
		
		for i in range(self.values.size()):
			self.values[i] -= self.value_offset
	
	
	func graph_points():
		var first_diff = self.values[0] - self.central_val
		var current_point = self.get_midpoint() + Vector2(0, self.point_dist.y * first_diff)
		var points = []
		
		points.append(current_point)
		for i in range(1, self.values.size()):
			current_point += Vector2(self.point_dist.x, self.point_dist.y * (self.values[i] - self.values[i-1]))
			points.append(current_point)
		
		return points
	
	func get_midpoint():
		return Vector2(self.pos.x, self.pos.y + self.size.y/2)
	
	# Returns line vertically positioned at central_val
	func get_central_line_points():
		return [self.get_midpoint(), self.get_midpoint() + Vector2(self.size.x, 0)]
	
	# Returns line that represents the top perimeter of the graph
	func get_top_line_points():
		return [self.pos, self.pos + Vector2(self.size.x, 0)]
	
	# Returns line that represents the bottom perimeter of the graph
	func get_bottom_line_points():
		return [self.pos + Vector2(0, self.size.y), self.pos + Vector2(self.size.x, self.size.y)]
	
	# Returns the line vertically positioned at the maximum value in the graph
	func get_max_line_points():
		var max_val = self.values.max()
		var diff = Vector2(0, (max_val - self.central_val) * self.point_dist.y)
		return[self.get_midpoint() + diff, self.get_midpoint() + diff + Vector2(self.size.x, 0)]
	
	# Returns the line vertically positioned at the minimum value in the graph
	func get_min_line_points():
		var min_val = self.values.min()
		var diff = Vector2(0, (min_val - self.central_val) * self.point_dist.y)
		return[self.get_midpoint() + diff, self.get_midpoint() + diff + Vector2(self.size.x, 0)]

func _ready():
	set_process(false)
	set_current_graph("LineGraph", [0, -1, 2, 3, 11,-5, 6, -7, 8, -9, 10],\
	                  [Vector2(0, 300), 3.0])

func _process(delta):
	update()

func _draw():
	if current_graph:
		var points  = current_graph.graph_points()
		var top     = current_graph.get_top_line_points()
		var maximum = current_graph.get_max_line_points()
		var central = current_graph.get_central_line_points()
		var minimum = current_graph.get_min_line_points()
		var bot     = current_graph.get_bottom_line_points()
		
		draw_line(top[0], top[1], Color(0, 0, 0))
		draw_line(maximum[0], maximum[1], Color(0, 1, 0, .6))
		draw_line(central[0], central[1], Color(0, 0, 1, .6))
		draw_line(minimum[0], minimum[1], Color(1, 0, 0, .6))
		draw_line(bot[0], bot[1], Color(0, 0, 0))
		for i in range(1, points.size()):
			draw_line(points[i-1], points[i], current_graph.color, 2.0, true)

func set_current_graph(graph_type, values, args):
	var vals = values
	var pos = args[0]
	var central_val = args[1]
	
	if graph_type == "LineGraph":
		current_graph = LineGraph.new(values, Vector2(pos.x + 70, pos.y + 15), central_val)
	
	$Background.rect_position = pos
	$Background.rect_size = Vector2(current_graph.size.x + 140, current_graph.size.y + 30)
	$Central.rect_position = current_graph.get_central_line_points()[0] - $Central.rect_size/2 - Vector2(30, 0)
	$Central.text = str(current_graph.central_val)