extends "res://broker/bond/Bond.gd"

var id
var ammount = 1
var bought_time # Moment this Bond was bought
var last_updated_time # Used to define iteration number
var profit = 1.0 # Accumulated rented so far, in percentage
var initial_ammount = 0 # Starting ammount of money

func setup_owned(ammount, bought_time, last_updated_time, profit, initial_ammount, id):
	self.id = id
	self.ammount = ammount
	self.bought_time = bought_time
	self.last_updated_time = last_updated_time
	self.profit = profit
	self.initial_ammount = initial_ammount
	$MinInvestment.text = str(int(ammount))
	if min_time[0] > 0 or min_time[1] > 0:
		$Apply.disabled = true
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
	for i in range(times_iterated): 
		last_updated_time = OS.get_datetime()
		if rentability_type == "Pre-fixada": # Prefixated interest rentability
			ammount = ammount * rentability
			profit *= rentability
		elif rentability_type == "Pos-fixada": # Posfixated interest rentability
			var name_split = bond_name.split("-")[0]
		
			if name_split == "S":
				ammount = (ammount * rentability * Selic.value)
				profit *= rentability * Selic.value
			elif name_split == "I":
				ammount = (ammount * rentability * Inflation.value)
				profit *= rentability * Inflation.value
		elif rentability_type == "Prov":
			rentability += (randf() - randf()) * 20
			ammount = ammount * rentability
			profit *= rentability
		
		# Decrease time left to be able to sell
		min_time[1] -= 4
		if min_time[1] < 0 and min_time[0] > 0:
			min_time[1] = 24 - min_time[1]
			min_time[0] -= 1
	if min_time[0] <= 0 and min_time[1] <= 0:
		$Apply.disabled = false
		$MinTime.hide()
	Save.delete_bought_bond(id)
	Save.save_bought_bond(self, self.ammount)


func get_iterated_times():
	var time_diff = Save.get_time_difference(bought_time, last_updated_time)
	
	time_diff = 24 * time_diff[0] + time_diff[1]
	
	return int(time_diff/4)


func get_proportional_profit(ammount_sold):
	var total_ammount = profit * initial_ammount
	
	if int(total_ammount) <= initial_ammount:
		return 0
	
	var proportion_sold = float(ammount_sold)/total_ammount
	
	return int((profit - 1.0) * proportion_sold * ammount_sold)


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
		var pp = get_proportional_profit(ammount)
		if pp > 0: # Only create debt in profit
			Save.save_debt(self, int(ammount), pp)
		self.ammount -= ammount
		Save.delete_bought_bond(id)
		if self.ammount > 0:
			Save.save_bought_bond(self, self.ammount, false)
		Portfolio.call_deferred("update_bought_bonds")
