function create_clusters(){
	for (var _level = 0; _level < TOTAL_CLUSTER_LEVELS; _level++) {
    
	    var _csize = global.cluster_sizes[_level];     // e.g. 8, 4, 4, 4
	    var _h_count = ceil(global.cells_h / _csize);
	    var _v_count = ceil(global.cells_v / _csize);

	    global.clusters[_level] = [];

	    for (var _cy = 0; _cy < _v_count; _cy++) {

	        global.clusters[_level][_cy] = [];

	        for (var _cx = 0; _cx < _h_count; _cx++) {

	            // Create a cluster object or struct
	            var _cluster = new Cluster(_level, _cx, _cy);

	            // Fill this cluster with its cells
	            var _start_x = _cx * _csize;
	            var _start_y = _cy * _csize;

	            for (var yy = _start_y; yy < _start_y + _csize; yy++) {
	                if (yy >= global.cells_v) break;

	                for (var xx = _start_x; xx < _start_x + _csize; xx++) {
	                    if (xx >= global.cells_h) break;

	                    array_push(_cluster.cells, global.nav[yy][xx]);
	                }
	            }

	            global.clusters[_level][_cy][_cx] = _cluster;
	        }
	    }
	}
}