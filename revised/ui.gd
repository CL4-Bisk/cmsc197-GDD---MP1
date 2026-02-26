extends Control
class_name UIManager

@onready var health_bar: ProgressBar = $HUD/MarginContainer/HBoxContainer/VBoxContainer/HealthBar
@onready var health_amount: Label = $HUD/MarginContainer/HBoxContainer/VBoxContainer/HealthBar/HealthAmount
@onready var xp_bar: ProgressBar = $HUD/MarginContainer/HBoxContainer/VBoxContainer/XPBar
@onready var amount: Label = $HUD/MarginContainer/HBoxContainer/VBoxContainer/XPBar/Amount
@onready var title_screen: Control = $TitleScreen
@onready var gold_count: Label = $HUD/MarginContainer/HBoxContainer/VBoxContainer/GoldCount

func game_start() -> void:
	$TitleScreen.hide()
	$HUD.show()

func game_over() -> void:
	$GameOver.show()

func show_title() -> void:
	$GameOver.hide()
	$HUD.hide()
	$TitleScreen.show()

func update_health(curr : float, maxim : float) -> void:
	health_bar.value = curr
	health_bar.max_value = maxim
	health_amount.text = "%s/%s" % [str(int(curr)), str(int(maxim))]

func update_exp(curr: float, maxim : float) -> void:
	xp_bar.value = curr
	xp_bar.max_value = maxim
	amount.text = "%s/%s" % [str(int(curr)), str(int(maxim))]

func update_gold(val : int) -> void:
	amount.text = str(val)
