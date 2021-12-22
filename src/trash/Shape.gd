extends Node2D

# onready var md_timer := $"/root/Main/Tetris/MoveDownTimer"
#
# onready var tiles = get_children()
#
# func _ready():
# 	md_timer.connect('timeout', self, 'move_down')
#
# func move(v: Vector2):
# 	for tile in tiles:
# 		tile.move_grid_pos(v)
# 		
#
# func move_down():
# 	move(Vector2.DOWN)
#
# func get_grid_pos():
# 	var coords: PoolVector2Array = []
# 	for tile in tiles:
# 		coords.append(tile.grid_pos)
# 	return coords
#
# func _input(event):
# 	if event.is_action_pressed('ui_right'):
# 		move(Vector2.RIGHT)
# 	if event.is_action_pressed('ui_left'):
# 		move(Vector2.LEFT)
# 	if event.is_action_pressed('ui_down'):
# 		move(Vector2.DOWN)
