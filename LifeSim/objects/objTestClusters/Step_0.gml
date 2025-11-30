level_display_index += keyboard_check_pressed(vk_up) - keyboard_check_pressed(vk_down);

if (level_display_index < 0) level_display_index = TOTAL_CLUSTER_LEVELS - 1;
if (level_display_index == TOTAL_CLUSTER_LEVELS) level_display_index = 0;

cluster = get_cluster(level_display_index, mouse_x div CELL_SIZE, mouse_y div CELL_SIZE);