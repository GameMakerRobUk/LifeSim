function test_neighbours(){
	var _cell_x = clamp(mouse_x div CELL_SIZE, 0, global.cells_h - 1);
	var _cell_y = clamp(mouse_y div CELL_SIZE, 0, global.cells_v - 1);
	
	var _cell = global.nav[_cell_y][_cell_x];
	
	var _names = struct_get_names(_cell.neighbours);
	
	for (var i = 0; i < array_length(_names); i ++){
		var _name = _names[i];
		
		if (_cell.neighbours[$ _name] != noone){
			draw_set_color(c_lime);
			draw_set_alpha(0.5);
			var _x1 = _cell.neighbours[$ _name].cell_x * CELL_SIZE;
			var _y1 = _cell.neighbours[$ _name].cell_y * CELL_SIZE;
			draw_rectangle(_x1, _y1,
						   _x1 + (CELL_SIZE - 1), 
						   _y1 + (CELL_SIZE - 1),
						   false);
			draw_set_alpha(1);
		}
	}
}