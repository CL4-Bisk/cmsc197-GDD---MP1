extends Control
class_name UIManager

@onready var health_bar: ProgressBar = $HUD/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HealthBar
@onready var health_amount: Label = $HUD/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HealthBar/HealthAmount
@onready var xp_bar: ProgressBar = $HUD/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/XPBar
@onready var title_screen: Control = $TitleScreen
@onready var gold_count: Label = $HUD/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/GoldCount
@onready var level: Label = $HUD/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Level

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

func update_gold(val : int) -> void:
	gold_count.text = "Gold Earned: " + str(val)

func update_level(val: int) -> void:
	level.text = "Level " + str(val)

func update_best_gold(val: int) -> void:
	$GameOver/MarginContainer/VBoxContainer/Label2.text = "Highest Gold Obtained: " + str(val)
