if (mouse_check_button_pressed(mb_left)){
	var _start_cell_x = objActor.cell_x;
	var _start_cell_y = objActor.cell_y;
	var _end_cell_x = mouse_x div CELL_SIZE;
	var _end_cell_y = mouse_y div CELL_SIZE;
	
	path = find_path(_start_cell_x, _start_cell_y, _end_cell_x, _end_cell_y);
	
	show_debug_message("path: " + string(path))
}