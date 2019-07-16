extends Camera2D

export(bool) var zoomable = false
export(Vector2) var maximum_zoomin = Vector2(0.5,0.5)
export(Vector2) var minimum_zoomout = Vector2(1, 1)
var finger_positions = [0, 0, 0, 0, 0]
var finger_speeds = [0, 0, 0, 0, 0]
var distance = -1
var zooming = false


func _ready():
	if zoomable and self.current:
		set_process_input(true)
	else:
		set_process_input(false)

func _input(event):
	if event is InputEventScreenTouch:
		if event.index > 0:
			zooming = true
		else:
			finger_positions = [0, 0, 0, 0, 0]
			finger_speeds = [0, 0, 0, 0, 0]
			zooming = false
	
	if event is InputEventScreenDrag:
		finger_positions[event.index] = event.position
		finger_speeds[event.index] = event.speed
		
		if finger_positions[0] is Vector2 and finger_positions[1] is Vector2:
			var new_distance = finger_positions[0].distance_squared_to(finger_positions[1])
			
			if distance == -1: # Yet to get 2 values for comparison
				pass
			elif new_distance < distance:
				zoom_out()
			elif new_distance > distance:
				zoom_in()
			
			distance = new_distance

func zoom_out():
	if self.zoom.x >= minimum_zoomout.x:
		return
	
	self.zoom = Vector2(zoom.x + 0.007, zoom.y + 0.007)

func zoom_in():
	if self.zoom.x <= maximum_zoomin.x:
		return
	
	self.zoom = Vector2(zoom.x - 0.007, zoom.y - 0.007)
