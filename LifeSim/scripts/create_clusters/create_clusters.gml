function create_clusters(){
	show_debug_message("!!! create_clusters")
	show_debug_message("room w: " + string(room_width) + " | room_h: " + string(room_height) + " | CELL_SIZE: " + string(CELL_SIZE))
	for (var _level = 0; _level < TOTAL_CLUSTER_LEVELS; _level++) {
    
	    var _csize = global.cluster_sizes[_level];     // e.g. 4, 8, 16, 32
	    var _h_count = ceil(global.cells_h / _csize);
	    var _v_count = ceil(global.cells_v / _csize);
		
		show_debug_message("level: " + string(_level) + " | csize: " + string(_csize) + " | hcount: " + string(_h_count) + " | vcount: " + string(_v_count))

	    global.clusters[_level] = [];

	    for (var _cell_y = 0; _cell_y < _v_count; _cell_y++) {

	        global.clusters[_level][_cell_y] = [];

	        for (var _cell_x = 0; _cell_x < _h_count; _cell_x++) {

	            // Create a cluster object or struct
	            var _cluster = new Cluster(_level, _cell_x div _csize, _cell_y div _csize);

	            // Fill this cluster with its cells
	            var _start_x = _cell_x * _csize;
	            var _start_y = _cell_y * _csize;

	            for (var yy = _start_y; yy < _start_y + _csize; yy++) {
	                if (yy >= global.cells_v) break;

	                for (var xx = _start_x; xx < _start_x + _csize; xx++) {
	                    if (xx >= global.cells_h) break;

	                    array_push(_cluster.cells, global.nav[yy][xx]);
	                }
	            }

	            global.clusters[_level][_cell_y][_cell_x] = _cluster;
				//show_debug_message("global.clusters[" + string(_level) + "][" + string(_cell_y) + "][" + string(_cell_x) + "]: " + "\n"
				//+ "level: " + string(_cluster.level) + " | cell_x: " + string(_cluster.cell_x) + " | cell_y: " + string(_cluster.cell_y))
	        }
	    }
	}
}