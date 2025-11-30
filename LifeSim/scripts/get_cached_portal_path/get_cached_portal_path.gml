/// @func get_cached_portal_path(cluster_struct, portal1_id, portal2_id)
/// @return {Array<Array<Int>> or Undefined} 
function get_cached_portal_path(_cluster, _p1_id, _p2_id) {
	show_debug_message("!!! get_cached_portal_path")
	show_debug_message("_cluster: " + " | id: " + string(_cluster.id) + " | level: " + string(_cluster.level) + " | cell_x: " + string(_cluster.cell_x) + " | cell_y: " + string(_cluster.cell_y))
    var _conn_key = _p1_id + "_" + _p2_id;
	
    show_debug_message("_conn_key: " + string(_conn_key))
	
    // Check in the cluster's connections storage
    
	for (var i = 0; i < TOTAL_CLUSTER_LEVELS; i ++){
		var _csize = global.cluster_sizes[i];     // e.g. 4, 8, 16, 32
	    var _h_count = ceil(global.cells_h / _csize);
	    var _v_count = ceil(global.cells_v / _csize);

	    for (var _cell_y = 0; _cell_y < _v_count; _cell_y++) {

	        for (var _cell_x = 0; _cell_x < _h_count; _cell_x++) {	
				var _cluster_to_check = global.clusters[i][_cell_y][_cell_x];
				if (struct_get(_cluster_to_check.portal_connections, _conn_key) != undefined){
					show_debug_message("found " + _conn_key + " in " + _cluster_to_check.id + " at level " + string(i) + " | cell_x: " + string(_cluster_to_check.cell_x) + " | cell_y: " + string(_cluster_to_check.cell_y))
					break;
				}
			}
		}
	}
	
	show_debug_message("_cluster.portal_connections names: " + string(struct_get_names(_cluster.portal_connections)))
    show_debug_message("get_cached_portal_path _conn_key: " + string(_conn_key))
    // Check in the cluster's connections storage
    if (variable_struct_exists(_cluster.portal_connections, _conn_key)) {
        // Instantaneous lookup of the saved coordinates
        return _cluster.portal_connections[$ _conn_key]; 
    }
    
    // This should ideally never happen if preprocessing ran correctly
    show_debug_message("Warning: Path for " + _conn_key + " not found in cache. Recalculating...");
    // Fallback: Recalculate the path if missing from cache (SLOW)
    // You would need coordinates here, not just IDs
    // Example Fallback: return find_path(_p1.x, _p1.y, _p2.x, _p2.y);
    return undefined; 
}
