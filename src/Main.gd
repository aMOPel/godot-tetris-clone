extends Node

onready var x := XScene.new(self, true, {count_start = 0})
onready var score = get_node('UI/Score')
onready var tetris = $Tetris

var gos = preload('res://scenes/GameOverScreen.tscn')


func _ready():
	tetris.connect('game_over', self, 'game_over_screen')
	tetris.connect('score_changed', self, '_on_score_changed')
	score.text = String(tetris.score)


func game_over_screen():
	tetris.tetris_grid.x.remove_scenes(
		tetris.tetris_grid.x.active
	)
	x.remove_scenes(['Tetris', 'Cages'], x.STOPPED)
	x.add_scene(gos)


func _on_score_changed(old_score, new_score) -> void:
	score.text = String(new_score)
