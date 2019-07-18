extends "res://broker/bond/Bond.gd"

var id
var ammount
var bought_time
var last_updated_time # Used to define iteration number
var profit # How much was profited so far

func setup_owned(ammount, bought_time, last_updated_time, profit, id):
	self.id = id
	self.ammount = ammount
	self.bought_time = bought_time
	self.last_updated_time = last_updated_time
	self.profit = profit
	$MinInvestment.text = str(int(ammount))
	if min_time[0] > 0 or min_time[1] > 0:
		$Apply.disabled = true
	# TESTING #
	#self.last_updated_time.hour += 4
	#$Apply.disabled = false
	#iterate(4)
	print('rentability = ', rentability)
	# TESTING #
	var time_diff = Save.get_time_difference(creation_time, OS.get_datetime())
	if time_diff[0] > 0 and bond_name != "LCI" and bond_name != "LCA": # Regressive taxes
		taxes[0] = taxes[0] - (min(3, time_diff[0]) * 2.5)
		$Taxes.text = str("Taxas:\nIR(", taxes[0], "%), Adm(", stepify(taxes[1], 0.1), "%),\nPerf(", stepify(taxes[2], 0.1), "%)")


func resume_min_investment():
	if ammount:
		$MinInvestment.text = str(floor(ammount))


func expand_min_investment():
	if ammount:
		$MinInvestment.text = str("Valor:\nG$ ", floor(ammount))


func iterate(times_iterated):
	var init_value = ammount
	for i in range(times_iterated): 
		last_updated_time = OS.get_datetime()
		if rentability_type == "Pre-fixada": # Prefixated interest rentability
			ammount = (ammount * rentability)
		elif rentability_type == "Pos-fixada": # Posfixated interest rentability
			var name_split = bond_name.split("-")[0]
		
			if name_split == "S":
				ammount = (ammount * rentability * Selic.value)
			elif name_split == "I":
				ammount = (ammount * rentability * Inflation.value)
		elif rentability_type == "Prov":
			rentability += (randf() - randf()) * 20
			ammount = ammount * rentability
		
		# Decrease time left to be able to sell
		min_time[1] -= 4
		if min_time[1] < 0 and min_time[0] > 0:
			min_time[1] = 24 - min_time[1]
			min_time[0] -= 1
	if min_time[0] <= 0 and min_time[1] <= 0:
		$Apply.disabled = false
		$MinTime.hide()
	Save.delete_bought_bond(id)
	var final_value = ammount
	profit += final_value - init_value
	Save.save_bought_bond(self, self.ammount)


func get_iterated_times():
	var time_diff = Save.get_time_difference(bought_time, last_updated_time)
	
	time_diff = 24 * time_diff[0] + time_diff[1]
	
	return int(time_diff/4)


func get_profit(ammount_sold):
	var prft = min(self.profit, ammount_sold) # if ammount_sold is smaller than profit, that that is the current profit
	self.profit -= prft # takes away acumulated profit from sold ammount
	
	return int(prft)


func _on_Apply_pressed():
	var TradeConfirm = TRADE_CONFIRM_SCN.instance()
	var Canvas = get_tree().get_root().get_node("Broker/HUD")
	var Swipe = get_parent().get_parent().get_parent().get_node("SwipeHandler")
	
	TradeConfirm.setup(Swipe, 0, ammount) 
	Canvas.add_child(TradeConfirm)
	TradeConfirm.connect("trade_confirmed", self, "_on_trade_confirmed")


func _on_trade_confirmed(ammount):
	var Portfolio = get_tree().get_root().get_node("Broker/PortfolioMenu/Portfolio")
	var HUD = get_tree().get_root().get_node("Broker/HUD")
	
	if ammount > 0:
		HUD.add_money(int(ammount))
		var profit = get_profit(ammount)
		if profit > 0: # Only create debt in profit
			print('create debt ', profit)
			Save.save_debt(self, int(ammount), profit)
		self.ammount -= ammount
		Save.delete_bought_bond(id)
		if self.ammount > 0:
			Save.save_bought_bond(self, self.ammount, false)
		Portfolio.call_deferred("update_bought_bonds")
