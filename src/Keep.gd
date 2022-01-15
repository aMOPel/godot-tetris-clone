extends Node2D

class_name Keep

var c := Constants

var keep_grid: Grid
var kept: Tetromino

signal kept


func _init():
	keep_grid = Grid.new(
		c.KEEP_GRID_COLUMNS, c.KEEP_GRID_ROWS, c.TILE, c.CELL_X, c.CELL_Y
	)
	add_child(keep_grid)
	keep_grid.position = c.KEEP_GRID_POS
	kept = Tetromino.new(keep_grid, '', 0, 1)


func _process(delta):
	keep_grid.x.remove_scenes(keep_grid.x.active, keep_grid.x.HIDDEN)
	if kept:
		get_parent().paint_tetromino(kept)


func keep(current: Tetromino, extra_collision = null) -> bool:
	var new_kept_name = current.name
	var new_kept_color = current.color


	if kept.name:
		if current.collision(Vector2.ZERO, current.rotation, kept.name):
			return false
		if extra_collision is FuncRef:
			if extra_collision.call_func(Vector2.ZERO, current.rotation, kept.name):
				return false
		current.bulk_set(
			{
				name = kept.name,
				color = kept.color,
			}
		)
	else:
		get_parent().spawn()

	kept.bulk_set(
		{
			name = new_kept_name,
			position = c.TETROMINOS[new_kept_name].queue_offset,
			color = new_kept_color,
		}
	)
	emit_signal('kept')
	return true
