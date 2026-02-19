extends Label

func _ready():
	Game.money_changed.connect(_on_money_changed)
	_update_display(Game.money)

func _on_money_changed(new_amount: float):
	_update_display(new_amount)

func _update_display(amount: float):
	text = "Bugbucks: " + ("%.2f" % amount)

func _cannot_afford():
	var tween = create_tween()
	modulate = Color("#a53030")
	tween.tween_property(self, "modulate", Color.WHITE, 1.0)
