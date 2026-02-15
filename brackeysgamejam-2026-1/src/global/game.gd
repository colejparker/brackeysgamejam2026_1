extends Node

signal money_changed(new_amount: int)

var money: int = 5:
	set(value):
		money = value
		money_changed.emit(money)

func add_money(amount: int):
	money += amount
	
func die_lose_money():
	money -= floor(money/2)
