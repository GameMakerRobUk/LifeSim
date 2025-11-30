//if (mouse_check_button_pressed(mb_left)){
//	path = find_path(objActor.x div CELL_SIZE,
//						  objActor.y div CELL_SIZE,
//						  mouse_x div CELL_SIZE,
//						  mouse_y div CELL_SIZE)
//	show_debug_message("path: " + string(path))
//}

if (mouse_check_button_pressed(mb_left)) {
    // Convert click coordinates to grid/cell coordinates
    var _target_x_cell = floor(mouse_x / CELL_SIZE);
    var _target_y_cell = floor(mouse_y / CELL_SIZE);
    
    // Calculate the complete path using the master HPA* function
    path = find_path_hpa_master(
        objActor.x div CELL_SIZE, 
        objActor.y div CELL_SIZE, 
        _target_x_cell, 
        _target_y_cell
    );
    
    if (array_length(path) > 0) {
        // Path found! Start following the path...
    }
	
	show_debug_message("path: " + string(path))
}

//for (var i = 0; i < 10; i ++){
//	var _target_x_cell = irandom(global.cells_h - 1);
//	var _target_y_cell = irandom(global.cells_v - 1);
    
//	// Calculate the complete path using the master HPA* function
//	path = find_path_hpa_master(
//	    objActor.x div CELL_SIZE, 
//	    objActor.y div CELL_SIZE, 
//	    _target_x_cell, 
//	    _target_y_cell
//	);
    
//	if (array_length(path) > 0) {
//	    // Path found! Start following the path...
//	}
//}