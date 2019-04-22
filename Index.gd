extends Node

var value : float
var var_range : float # variation range, max ammount the index can change in one iteration
var bot_value # float
var top_value # float


func create(initial_value : float, variation_range : float,  bot_value = null, top_value = null):
	self.value = initial_value
	self.var_range = variation_range
	self.bot_value = bot_value
	self.top_value = top_value
	randomize()
	iterate()


func iterate():
	var change = (randf() - rand_range(0.0, 0.9)) * var_range # 'normal' distribution with positive tendency
	
	if top_value and value >= top_value:
		change = -rand_range(0.0, 0.8) * var_range
	elif bot_value and value <= bot_value:
		change = randf() * var_range
	
	value += change
