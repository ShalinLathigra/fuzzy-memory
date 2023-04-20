extends Control

signal on_harvest_seeds(seeds: Array[Seed])

@onready var scoreLabel := %ScoreLabel as Label

var player: Player
var score: int

func _ready() -> void:
	scoreLabel.text = ""
	on_harvest_seeds.connect(harvest_seeds)

func harvest_seeds(seeds:Array[Seed]) -> void:
	for seed in seeds:
		score += seed.calculate_value()
	scoreLabel.text = "{0}".format([score])
