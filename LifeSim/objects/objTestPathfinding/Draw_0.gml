if (surf == -1 || !surface_exists(surf)){
	surf = surface_create(room_width, room_height);
	surface_set_target(surf);
	draw_set_color(c_lime);
	draw_set_alpha(0.5);

	for (var i = 0; i < array_length(path); i ++){
		var _cell = path[i];

		var _x1 = _cell.x * CELL_SIZE;
		var _y1 = _cell.y * CELL_SIZE;
		draw_rectangle(_x1, _y1,
						_x1 + (CELL_SIZE - 1), 
						_y1 + (CELL_SIZE - 1),
						false);
	}

	draw_set_alpha(1);
	surface_reset_target();
}

draw_surface(surf, 0, 0);