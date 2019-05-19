extends "res://broker/bond/Bond.gd"

var original_ammount # ammount recorded in the save file. Used to delete obsolete bonds on save
var ammount
var bought_time


func setup_owned(ammount, bought_time):
	self.original_ammount = ammount
	self.ammount = ammount
	self.bought_time = bought_time
	
	$MinInvestment.text = str(ammount)


func _on_Apply_pressed():
	var TradeConfirm = TRADE_CONFIRM_SCN.instance()
	var Canvas = get_tree().get_root().get_node("Broker/HUD")
	var Swipe = get_parent().get_parent().get_parent().get_node("SwipeHandler")
	
	TradeConfirm.setup(0, ammount, Swipe) 
	Canvas.add_child(TradeConfirm)
	TradeConfirm.connect("trade_confirmed", self, "_on_trade_confirmed")


func _on_trade_confirmed(ammount):
	var Portfolio = get_tree().get_root().get_node("Broker/PortfolioMenu/Portfolio")
	
	Save.money += ammount
	ammount -= ammount
	if ammount <= 0:
		print("need deletion")
		Save.delete_bought_bond(self)
	Portfolio.update_bought_bonds()
