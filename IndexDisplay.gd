extends Control

var values = [0, -1, 2, 3, 11,-5, 6, -7, 8, -9, 10]

class LineGraph:
	var values = [0.0] # Values to be plotted in the graph
	var pos = Vector2() # Where the graph will be positioned
	var central_val : float # Value that will be in the midpoint of the graph
	var val_range : float # Distance between top/bottom value and central value
	var total_width : int # total width of the graph
	var total_height : int # total height of the graph
	var color : Color # color of the graph's line
	var line_width : float # width of the graph's line
	var point_dist : Vector2 # distance between points in this graph
	var value_offset = 0 # distance the points will be moved to fit centrally in the graph
	
	func _init(values, pos, central_val = null, val_range = null, total_width = 560,\
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
		
		self.total_width  = total_width
		self.total_height = total_height
		self.color        = color
		self.line_width   = line_width
		self.point_dist   = Vector2(self.total_width/self.values.size(),\
		                           -self.total_height/(self.values.max() - self.values.min() + 1)) # point_dist.y is negative because positive values go down visually
		var max_diff = self.values.max() - self.central_val
		if -self.point_dist.y * max_diff > self.total_height/2:
			self.value_offset = max_diff - self.total_height/(2*-self.point_dist.y)
		else:
			var min_diff = self.central_val - self.values.min()
			if -self.point_dist.y * min_diff > self.total_height/2:
				self.value_offset = -(min_diff - self.total_height/(2*-self.point_dist.y))
		
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
		return Vector2(self.pos.x, self.pos.y + self.total_height/2)
	
	# Returns line vertically positioned at central_val
	func get_central_line_points():
		return [self.get_midpoint(), self.get_midpoint() + Vector2(self.total_width, 0)]
	
	# Returns line that represents the top perimeter of the graph
	func get_top_line_points():
		return [self.pos, self.pos + Vector2(self.total_width, 0)]
	
	# Returns line that represents the bottom perimeter of the graph
	func get_bottom_line_points():
		return [self.pos + Vector2(0, self.total_height), self.pos + Vector2(self.total_width, self.total_height)]
	
	# Returns the line vertically positioned at the maximum value in the graph
	func get_max_line_points():
		var max_val = self.values.max()
		var diff = Vector2(0, (max_val - self.central_val) * self.point_dist.y)
		return[self.get_midpoint() + diff, self.get_midpoint() + diff + Vector2(self.total_width, 0)]
	
	# Returns the line vertically positioned at the minimum value in the graph
	func get_min_line_points():
		var min_val = self.values.min()
		var diff = Vector2(0, (min_val - self.central_val) * self.point_dist.y)
		return[self.get_midpoint() + diff, self.get_midpoint() + diff + Vector2(self.total_width, 0)]

func _ready():
	set_process(false)

func _process(delta):
	update()

func _draw():
	var LG = LineGraph.new(values, Vector2(5, 300), 3.0)
	var points  = LG.graph_points()
	var top     = LG.get_top_line_points()
	var maximum = LG.get_max_line_points()
	var central = LG.get_central_line_points()
	var minimum = LG.get_min_line_points()
	var bot     = LG.get_bottom_line_points()
	
	draw_line(top[0], top[1], Color(1, 1, 1))
	draw_line(maximum[0], maximum[1], Color(0, 1, 0, .6))
	draw_line(central[0], central[1], Color(0, 0, 1, .6))
	draw_line(minimum[0], minimum[1], Color(1, 0, 0, .6))
	draw_line(bot[0], bot[1], Color(1, 1, 1))
	for i in range(1, points.size()):
		draw_line(points[i-1], points[i], Color(1, 1, 1), 2.0, true)
