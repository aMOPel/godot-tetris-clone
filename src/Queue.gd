extends Node2D

class_name Queue


var rng: RandomNumberGenerator
var global_seed: int

var c := Constants

var grid: Grid
var queue := []

var used_tetromino_indices = ['', '', '']

func _init(size: int):
	grid = Grid.new(
		c.QUEUE_GRID_COLUMNS, c.QUEUE_GRID_ROWS, c.TILE, c.CELL_X, c.CELL_Y
	)
	add_child(grid)
	grid.position = c.QUEUE_GRID_POS

	randomize()
	global_seed = randi()
	rng = RandomNumberGenerator.new()
	rng.seed = global_seed

	for i in size:
		var new_tet = get_random_tetromino_name()
		queue.push_back(
			Tetromino.new(
				grid,
				new_tet,
				Vector2.ZERO,
				c.QUEUE[i].index + c.TETROMINOS[new_tet].queue_offset,
				1
			)
		)

func _process(delta):
	grid.x.remove_scenes(grid.x.active, grid.x.HIDDEN)
	for i in queue:
		get_parent().paint_tetromino(i)

func move_queue(current) -> void:
	current.bulk_set(
		{
			name = queue[0].name,
			color = queue[0].color,
			base_index = c.START_POS + c.TETROMINOS[queue[0].name].start_offset,
			rotation = 0,
		}
	)

	for i in queue.size() - 1:
		queue[i].bulk_set(
			{
				name = queue[i + 1].name,
				color = queue[i + 1].color,
				base_index = (
					c.QUEUE[i].index
					+ c.TETROMINOS[queue[i + 1].name].queue_offset
				),
			}
		)

	var new_tet = get_random_tetromino_name()
	queue[queue.size() - 1].bulk_set(
		{
			name = new_tet,
			color = c.COLORS[c.TETROMINOS[new_tet].color],
			base_index = c.QUEUE[queue.size() - 1].index + c.TETROMINOS[new_tet].queue_offset,
		}
	)


func get_random_tetromino_name() -> String:
	var tetromino_name = c.TETROMINOS.keys()[rng.randi_range(
		0, c.TETROMINOS.size() - 1
	)]
	if tetromino_name in used_tetromino_indices:
		return get_random_tetromino_name()
	used_tetromino_indices.pop_front()
	used_tetromino_indices.push_back(tetromino_name)
	return tetromino_name



