extends TileMap


func hit_brick_by_rid(body: RID):
	var coords := get_coords_for_body_rid(body)
	var tile_data = get_cell_tile_data(0, coords)
	var next_state_coords = tile_data.get_custom_data("next_state_coords")
	
	set_cell(0, coords, 0, next_state_coords)
	if next_state_coords == Vector2i(-1, -1):
		GameEvents.brick_broken.emit()
	else:
		GameEvents.brick_damaged.emit()
	
	if get_used_cells(0).size() == 0:
		GameEvents.no_bricks_left.emit()
