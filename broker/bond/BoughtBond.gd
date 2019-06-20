extends "res://broker/bond/Bond.gd"

var id
var ammount
var bought_time # more like last_updated_time, but whatever, it is used in Portfolio.gd
var last_updated_time

func setup_owned(ammount, bought_time, last_updated_time, id):
	self.id = id
	self.ammount = ammount
	self.bought_time = bought_time
	self.last_updated_time = last_updated_time
	$MinInvestment.text = str(int(ammount))
	if min_time[0] > 0 or min_time[1] > 0:
		$Apply.disabled = true
		
	var time_diff = Save.get_time_difference(creation_time, OS.get_datetime())
	if time_diff[0] > 0 and bond_name != "LCI" and bond_name != "LCA": # Regressive taxes
		taxes[0] = taxes[0] - (min(3, time_diff[0]) * 2.5)
		$Taxes.text = str("Taxas:\nIR(", taxes[0], "%), Adm(", stepify(taxes[1], 0.1), "%),\nPerf(", stepify(taxes[2], 0.1), "%)")


func resume_min_investment():
	$MinInvestment.text = str(ammount)


func expand_min_investment():
	$MinInvestment.text = str("Valor:\nG$ ", ammount)


func iterate(times_iterated):
	for i in range(times_iterated): 
		bought_time = OS.get_datetime()
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
	Save.save_bought_bond(self, self.ammount)


func had_profit(ammount_sold):
	var total_cost = self.ammount + ammount_sold * (taxes[0] + taxes[1] + taxes[2])
	
	return total_cost < ammount_sold


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
	
	HUD.add_money(int(ammount))
	if had_profit(ammount): # Only create debt in profit
		Save.save_debt(self, int(ammount))
	self.ammount -= ammount
	Save.delete_bought_bond(id)
	if self.ammount > 0:
		Save.save_bought_bond(self, self.ammount, false)
	Portfolio.call_deferred("update_bought_bonds")
