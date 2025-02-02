// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function generate_level(){
	randomize()

	//Get the tile level map ID
	var wall_map_id = layer_tilemap_get_id(layer_get_id("wall_tiles"))
	var floor_map_id = layer_tilemap_get_id(layer_get_id("floor_tiles"))
	width = room_width div CELL_WIDTH
	height = room_height div CELL_HEIGHT
	grid = ds_grid_create(width, height)
	for (var xx = 0; xx < width; xx += 1) {
		for (var yy = 0; yy < height; yy += 1) {
			grid[xx, yy] = VOID
		}
	}

	//Create the controller
	var controller_x = width div 2
	var controller_y = height div 2
	var controller_direction = irandom(3)
	var steps = 400

	var direction_change_odds = 1

	repeat (steps) {
		grid[controller_x, controller_y] = FLOOR
		//Move the controller
		if irandom(direction_change_odds) == direction_change_odds {
			controller_direction = irandom(3)
		}
		var x_direction = lengthdir_x(1, controller_direction * 90)
		var y_direction = lengthdir_y(1, controller_direction * 90)
		controller_x += x_direction
		controller_y += y_direction
	
		//Check if we're out of bounds
		if controller_x < 2 || controller_x >= width - 2 {
			controller_x += - x_direction * 2
		}
		if controller_y < 2 || controller_y >= height - 2 {
			controller_y += - y_direction * 2
		}
	}

	//Draw the tiles
	for (var xx = 1; xx < width - 1; xx++) {
		for (var yy = 1; yy < height - 1; yy++) {
			if grid[xx, yy] == FLOOR {
				tilemap_set(floor_map_id, 1, xx, yy)
			}
			else {
				var north_tile = (grid[xx, yy-1] == VOID)
				var south_tile = (grid[xx, yy+1] == VOID)
				var east_tile = (grid[xx+1, yy] == VOID)
				var west_tile = (grid[xx-1, yy] == VOID)
			
				var wall_tile_index = 1 + NORTH*north_tile + SOUTH*south_tile + EAST*east_tile + WEST*west_tile
				tilemap_set(wall_map_id, wall_tile_index, xx, yy)
			}
		}
	}
}