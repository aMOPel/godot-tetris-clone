extends Node2D

var c = Constants

var go_grid: Grid

# func _init():
# 	go_grid = Grid.new(c.GAME_OVER_COLUMNS, c.GAME_OVER_ROWS, c.TILE, c.CELL_X, c.CELL_Y)
# 	position = c.GAME_OVER_POSITION
# 	add_child(go_grid)

# func _ready():
# 	for i in tetrominos.values():
# 		for j in i:
# 			paint_tetromino(Tetromino.new(go_grid, j.name, j.position, 0, j.rotation))

func paint_tetromino(tetromino: Tetromino) -> void:
	for i in tetromino.indices:
		paint(tetromino.grid, i, tetromino.color)

func paint(grid: Grid, index: int, color: Color) -> void:
	if grid.x.scenes.has(index):
		grid.x.x(index).modulate = color
		grid.x.show_scene(index)



var tetrominos:= {
	G = [
		{
			name = 'J',
			position = Vector2(7,6),
			rotation = 0,
		},
		{
			name = 'L',
			position = Vector2(7,8),
			rotation = 3,
		},
	]
}
