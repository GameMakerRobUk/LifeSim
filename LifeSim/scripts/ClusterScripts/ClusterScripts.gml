global.cluster_sizes = [4, 8, 16, 32];
#macro TOTAL_CLUSTER_LEVELS array_length(global.cluster_sizes)
global.clusters = [];
global.cluster_surface = -1;

/*
	cluster widths/heights : 
	[0] = 8 x 16
	[1] = 8 x 16 x 4
	[2] = 8 x 16 x 4 x 4
	[3] = 8 x 16 x 4 x 4
	
*/

function Cluster(_cell_x, _cell_y, _level, _index) constructor{
	csize = global.cluster_sizes[_level];
	id = "cluster_level_" + string(_level) + "_" + string(_index);
	level_cell_x = _cell_x;
	level_cell_y = _cell_y;
	level = _level;
	room_cell_x = level_cell_x * csize;
	room_cell_y = level_cell_y * csize;
	x = room_cell_x * CELL_SIZE;
	y = room_cell_y * CELL_SIZE;
}

function create_clusters(){
	for (var _level = 0; _level < TOTAL_CLUSTER_LEVELS; _level ++){
		var _cells_per_cluster = global.cluster_sizes[_level];
		var _index = 0;
		
		var _total_x_cells_this_level = ceil(global.cells_h / _cells_per_cluster);
		var _total_y_cells_this_level = ceil(global.cells_v / _cells_per_cluster);
		
		for (var _cell_y = 0; _cell_y < _total_y_cells_this_level; _cell_y ++){
			for (var _cell_x = 0; _cell_x < _total_x_cells_this_level; _cell_x ++){
				var _cluster = new Cluster(_cell_x, _cell_y, _level, _index);
				global.clusters[_level][_cell_y][_cell_x] = _cluster;
				_index ++;
			}
		}
	}
	
	show_debug_message("global.clusters: " + string(global.clusters))
}

function draw_cluster_surface(_level) {

    if (!surface_exists(global.cluster_surface)) {
        global.cluster_surface = surface_create(global.cells_h * CELL_SIZE, global.cells_v * CELL_SIZE)
    }

    surface_set_target(global.cluster_surface);
    draw_clear_alpha(c_black, 0); // fully transparent
    draw_set_color(c_lime);

    // for (var _level = 0; _level < TOTAL_CLUSTER_LEVELS; _level++) {

        var _cells_per_cluster = global.cluster_sizes[_level];
        var _cell_size = CELL_SIZE;

        var _total_x_clusters = array_length(global.clusters[_level][0]);
        var _total_y_clusters = array_length(global.clusters[_level]);

        for (var _cy = 0; _cy < _total_y_clusters; _cy++) {
            for (var _cx = 0; _cx < _total_x_clusters; _cx++) {

                var _cluster = global.clusters[_level][_cy][_cx];

                var _base_x = _cluster.x;
                var _base_y = _cluster.y;

                var _w = _cells_per_cluster * _cell_size;
                var _h = _cells_per_cluster * _cell_size;

                // Outline only
                draw_rectangle(
                    _base_x,
                    _base_y,
                    _base_x + _w - 1,
                    _base_y + _h - 1,
                    true
                );
            }
        }
   // }

    surface_reset_target();
	
	draw_surface(global.cluster_surface, 0, 0);
}

function get_cluster(_level, _room_cell_x, _room_cell_y) {
    var _cells_per_cluster = global.cluster_sizes[_level];

    var _level_cell_x = _room_cell_x div _cells_per_cluster;
    var _level_cell_y = _room_cell_y div _cells_per_cluster;

    // Bounds checks
    if (_level < 0 || _level >= array_length(global.clusters)) return noone;
    if (_level_cell_y < 0 || _level_cell_y >= array_length(global.clusters[_level])) return noone;
    if (_level_cell_x < 0 || _level_cell_x >= array_length(global.clusters[_level][_level_cell_y])) return noone;

    return global.clusters[_level][_level_cell_y][_level_cell_x];
}