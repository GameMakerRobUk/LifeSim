function Portal(_x, _y, _to_cluster, _side) constructor{
	static count = 0;
	x = _x;
	y = _y;
	to_cluster = _to_cluster;
	side = _side;
	id = "portal_" + string(count);
	count ++;
}

function detect_portals_for_level(_lvl){
    var _csize     = global.cluster_sizes[_lvl];
    var _clusters  = global.clusters[_lvl];

    var _rows = array_length(_clusters);
    var _cols = array_length(_clusters[0]);

    for (var _cy = 0; _cy < _rows; _cy++){
        for (var _cx = 0; _cx < _cols; _cx++){
            var _clust = _clusters[_cy][_cx];

            // ------------------------------------------------------
            // 1. Check RIGHT edge (cluster to the right)
            // ------------------------------------------------------
            if (_cx < _cols - 1){
                var _nx = _cx + 1;
                var _nbr = _clusters[_cy][_nx];

                var _start_x = (_cx + 1) * _csize - 1; // last x in this cluster
                var _other_x = _start_x + 1;

                for (var _yy = _cy * _csize; _yy < (_cy + 1) * _csize; _yy++){
                    if (_yy >= global.cells_v) break;

                    if ( is_walkable(_start_x, _yy) 
                     && is_walkable(_other_x, _yy)){
                        var _p = new Portal(_start_x, _yy, _nbr, "right");
                        array_push(_clust.portals, _p);
                    }
                }
            }

            // ------------------------------------------------------
            // 2. Check LEFT edge (cluster to the left)
            // ------------------------------------------------------
            if (_cx > 0){
                var _nx = _cx - 1;
                var _nbr = _clusters[_cy][_nx];

                var _start_x = _cx * _csize;       // first x in this cluster
                var _other_x = _start_x - 1;

                for (var _yy = _cy * _csize; _yy < (_cy + 1) * _csize; _yy++){
                    if (_yy >= global.cells_v) break;

                    if ( is_walkable(_start_x, _yy)
                     && is_walkable(_other_x, _yy)){
                        var _p = new Portal(_start_x, _yy, _nbr, "left")
                        array_push(_clust.portals, _p);
                    }
                }
            }

            // ------------------------------------------------------
            // 3. Check BOTTOM edge (cluster below)
            // ------------------------------------------------------
            if (_cy < _rows - 1){
                var _ny = _cy + 1;
                var _nbr = _clusters[_ny][_cx];

                var _start_y = (_cy + 1) * _csize - 1; // last y in this cluster
                var _other_y = _start_y + 1;

                for (var _xx = _cx * _csize; _xx < (_cx + 1) * _csize; _xx++){
                    if (_xx >= global.cells_h) break;

                    if ( is_walkable(_xx, _start_y)
                     && is_walkable(_xx, _other_y)){
                        var _p = new Portal(_xx, _start_y, _nbr, "bottom");
  
                        array_push(_clust.portals, _p);
                    }
                }
            }

            // ------------------------------------------------------
            // 4. Check TOP edge (cluster above)
            // ------------------------------------------------------
            if (_cy > 0){
                var _ny = _cy - 1;
                var _nbr = _clusters[_ny][_cx];

                var _start_y = _cy * _csize;       // first y in this cluster
                var _other_y = _start_y - 1;

                for (var _xx = _cx * _csize; _xx < (_cx + 1) * _csize; _xx++){
                    if (_xx >= global.cells_h) break;

                    if ( is_walkable(_xx, _start_y)
                     && is_walkable(_xx, _other_y)){
                        var _p = new Portal(_xx, _start_y, _nbr, "top");
                        array_push(_clust.portals, _p);
                    }
                }
            }
        }
    }
}