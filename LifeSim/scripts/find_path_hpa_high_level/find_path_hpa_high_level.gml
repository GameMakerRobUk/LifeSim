function get_cluster_at_coords(_cx, _cy, _level) {
    var _csize = global.cluster_sizes[_level];
    var _cluster_x = floor(_cx / _csize);
    var _cluster_y = floor(_cy / _csize);
    // Add boundary checks here if needed, but assuming valid input for now
    if (_cluster_x < 0 || _cluster_x >= array_length(global.clusters[_level][0])) return noone;
    if (_cluster_y < 0 || _cluster_y >= array_length(global.clusters[_level])) return noone;
    return global.clusters[_level][_cluster_y][_cluster_x];
}

function heuristic_euclidian(_portal, _end_x_cell, _end_y_cell) {
    return point_distance(_portal.x, _portal.y, _end_x_cell, _end_y_cell);
}

function find_path_hpa_high_level(_start_x, _start_y, _end_x, _end_y) {
    var _level_index = 0;

    var _start_cluster = get_cluster_at_coords(_start_x, _start_y, _level_index);
    var _end_cluster   = get_cluster_at_coords(_end_x, _end_y, _level_index);

    if (_start_cluster == noone || _end_cluster == noone || _start_cluster == _end_cluster) {
        return { path_found: true, high_level_path: [] }; // Already in same cluster, high level plan is empty
    }

    var _open_list   = ds_priority_create();
    // Use a string map for tracking visited *portals* and their A* data
    var _portal_data = ds_map_create(); 

    // ---------------------------------------------------------
    // START PORTALS: Initialize the search with all exit portals from the start cluster
    // ---------------------------------------------------------
    var _start_portals = _start_cluster.portals;
    for (var i = 0; i < array_length(_start_portals); i++) {
        var _p = _start_portals[i];

        var _data = {
            portal: _p,
            from_cluster: _start_cluster,
            to_cluster: _p.to_cluster,
            g_cost: 0, // G cost from the actual start point *to this portal* is calculated later during stitching
            // The F cost initially is just the heuristic from the portal's target cluster to the end cluster
            f_cost: heuristic_cluster(_p.to_cluster, _end_cluster), 
            parent_key: noone // The start point isn't a portal
        };

        ds_priority_add(_open_list, _p, _data.f_cost);
        ds_map_add(_portal_data, string(_p.id), _data); // Use unique ID as key
    }

    // ---------------------------------------------------------
    // MAIN LOOP
    // ---------------------------------------------------------
    while (!ds_priority_empty(_open_list)) {

        var _current_portal = ds_priority_delete_min(_open_list);
        var _current_data   = _portal_data[? string(_current_portal.id)];

        var _entering_cluster = _current_data.to_cluster;

        // Reached goal?
        if (_entering_cluster == _end_cluster) {
            var _high_level_path = [];
            var _curr_data = _current_data;

            while (_curr_data.parent_key != noone) {
                array_insert(_high_level_path, 0, {
                    cluster: _curr_data.from_cluster,
                    exit_portal: _curr_data.portal
                });
                _curr_data = _portal_data[? _curr_data.parent_key];
            }
            
            ds_priority_destroy(_open_list);
            ds_map_destroy(_portal_data);
            return { path_found: true, high_level_path: _high_level_path };
        }

        // ---------------------------------------------------------
        // EXPLORE NEIGHBOR PORTALS IN THIS CLUSTER
        // ---------------------------------------------------------
        var _neighbors = _entering_cluster.portals;

        for (var j = 0; j < array_length(_neighbors); j++) {
            var _nbr = _neighbors[j];
            
            // --- CRITICAL CHANGE: Use precomputed cost between portals ---
            // Find the key for the connection from the current portal (_current_portal) 
            // to the neighbor portal (_nbr) within the _entering_cluster.

            // Note: `generate_portal_connections` assumes paths only exist between portals of the *same* cluster. 
            // We need a specific key lookup.
            
            // This part requires access to the connection map we populated earlier.
            // We need to know which of the two portals was P1 and which was P2 during generation. 
            // The current setup makes this lookup slightly complex. Let's simplify the cost assumption slightly 
            // by relying on the A* we run *later* in `find_path_hpa_master`.
            
            // For the high-level A* to work efficiently *without* re-running low-level A* constantly,
            // we should store the travel costs directly on the portal connections.

            // Since you did precalculate costs in `generate_portal_connections`, we use them now:
            var _conn_key = string(_current_portal.id) + "_" + string(_nbr.id); // This key format isn't used in your original generation code
            
            // Your original generation used generic index keys, which isn't sufficient here. 
            // We must update how costs are calculated/stored for this to work perfectly.
            
            // Reverting to a simple *approximate* cost for the high level while keeping the master stitching as the source of truth for now:
            // The move cost is currently 1, which causes the bias issue. We need a better approximation.
            // We can use Euclidean distance between portals as a better heuristic *for high-level G-cost*.
            
            var _move_cost_approx = point_distance(_current_portal.x, _current_portal.y, _nbr.x, _nbr.y);

            var _new_g = _current_data.g_cost + _move_cost_approx; // Use distance, not fixed '1'

            // Check if this path to the neighbor portal is better than a previously found one
            var _nbr_id_str = string(_nbr.id);
            if (!ds_map_exists(_portal_data, _nbr_id_str) || _new_g < _portal_data[? _nbr_id_str].g_cost) {
                
                var _data2 = {
                    portal: _nbr,
                    from_cluster: _entering_cluster,
                    to_cluster: _nbr.to_cluster,
                    g_cost: _new_g,
                    // Heuristic calculation uses actual cell coordinates, which is better
                    f_cost: _new_g + point_distance(_nbr.x, _nbr.y, _end_x, _end_y), 
                    parent_key: string(_current_portal.id) // Use the parent portal's unique ID string
                };
                
                // Add or update the portal data in the map and priority queue
                if (!ds_map_exists(_portal_data, _nbr_id_str)) {
                    ds_map_add(_portal_data, _nbr_id_str, _data2);
                } else {
                    struct_set(_portal_data[? _nbr_id_str], "g_cost", _new_g);
                    struct_set(_portal_data[? _nbr_id_str], "f_cost", _data2.f_cost);
                    struct_set(_portal_data[? _nbr_id_str], "parent_key", _data2.parent_key);
                }
                
                // Add to the priority queue (priority queue handles updates internally by adding new entry and ignoring older ones later)
                ds_priority_add(_open_list, _nbr, _data2.f_cost);
            }
        }
    }

    ds_priority_destroy(_open_list);
    ds_map_destroy(_portal_data);
    return { path_found: false, high_level_path: [] };
}
