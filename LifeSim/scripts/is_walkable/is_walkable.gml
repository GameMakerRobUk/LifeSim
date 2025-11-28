function is_walkable(_x, _y){
    if (_x < 0 || _y < 0) return false;
    if (_x >= global.cells_h || _y >= global.cells_v) return false;

    return global.nav[_y][_x].walkable;
}