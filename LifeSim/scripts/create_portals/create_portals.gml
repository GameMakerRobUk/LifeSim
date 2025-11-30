function Portal(_level, _level_cell_x, _level_cell_y, _cluster_id) constructor{
	level_cell_x = _level_cell_x;	
	level_cell_y = _level_cell_y;
	level = _level;
	cluster_id = _cluster_id;
}

function create_portals(){
	for (var _level = 0; _level < TOTAL_CLUSTER_LEVELS; _level++){
		var _cells_per_cluster = global.cluster_sizes[_level];
		
		var _total_x_cells_this_level = ceil(global.cells_h / _cells_per_cluster);
		var _total_y_cells_this_level = ceil(global.cells_v / _cells_per_cluster);
		
		for (var _cell_y = 0; _cell_y < _total_y_cells_this_level; _cell_y++){
			for (var _cell_x = 0; _cell_x < _total_x_cells_this_level; _cell_x++){
				var _cluster = global.clusters[_level][_cell_y][_cell_x];
				_cluster.portals = [];
				
				// Iterate actual room cell coordinates covered by this cluster
				for (var _yy = _cluster.room_cell_y; _yy < _cluster.room_cell_y + _cells_per_cluster; _yy++){
					for (var _xx = _cluster.room_cell_x; _xx < _cluster.room_cell_x + _cells_per_cluster; _xx++){
						
						// Local offset inside the cluster (0 .. _cells_per_cluster-1)
						var _local_x = _xx - _cluster.room_cell_x;
						var _local_y = _yy - _cluster.room_cell_y;
						
						var _is_left_edge   = (_local_x == 0);
						var _is_right_edge  = (_local_x == _cells_per_cluster - 1);
						var _is_top_edge    = (_local_y == 0);
						var _is_bottom_edge = (_local_y == _cells_per_cluster - 1);
						
						if (_is_left_edge || _is_right_edge || _is_top_edge || _is_bottom_edge){
							var _portal = new Portal(_level, _xx, _yy, _cluster.id);
							
							// store room-cell coords on the portal and compute pixel pos
							_portal.room_cell_x = _xx;
							_portal.room_cell_y = _yy;
							_portal.x = _portal.room_cell_x * CELL_SIZE;
							_portal.y = _portal.room_cell_y * CELL_SIZE;
							
							array_push(_cluster.portals, _portal);
						}
					}
				}
			}
		}
	}
}
