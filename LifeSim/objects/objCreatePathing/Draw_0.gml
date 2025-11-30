/*
	cluster widths/heights : 
	[0] = 8 x 16
	[1] = 8 x 16 x 4
	[2] = 8 x 16 x 4 x 4
	[3] = 8 x 16 x 4 x 4
	
*/
/*
var _csize = CELL_SIZE;

for (var _level = 0; _level < array_length(cluster_size); _level++) {
	
	_csize *= cluster_size[_level]; 
	var _h_count = ceil(global.cells_h / _csize);
    var _v_count = ceil(global.cells_v / _csize);

	var _clusters_for_level = global.clusters[_level];
	
	show_debug_message("_c:size: " + string(_csize))
	show_debug_message("_v_count: " + string(_v_count))

    for (var _cy = 0; _cy < _v_count; _cy++) {

        for (var _cx = 0; _cx < _h_count; _cx++) {
			var _w = _csize;
			
			var _h = _csize;
			
			var _x1 = _cx * _w;
			var _y1 = _cy * _h;
			var _x2 = _x1 + _w;
			var _y2 = _y1 + _h;
			
			draw_set_color(cols[_level]);
			draw_rectangle(_x1, _y1, _x2, _y2, true);
		}
		
	}
}
*/
draw_navigation_hierarchy(0);//level_display_index);
//test_neighbours();
//draw_portal_connections_debug();