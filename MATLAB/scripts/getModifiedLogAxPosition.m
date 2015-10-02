function ax_pos_actual_norm = getModifiedLogAxPosition(h_ax)
    origUnits = get(h_ax, 'units');
    
    set(h_ax, 'units', 'normalized')
    ax_pos_nrm = get(h_ax, 'position');
    set(h_ax, 'units', 'pixels')
    ax_pos_pix = get(h_ax, 'position');
    
    set(h_ax, 'units', origUnits);

%     x_axis_log = strcmp(get(h_ax, 'xscale'), 'log');
%     y_axis_log = strcmp(get(h_ax, 'yscale'), 'log');
    
    ax_log_xlim = log10(get(h_ax, 'xlim'));
    ax_log_ylim = log10(get(h_ax, 'ylim'));

    ax_w_actual_pix = diff(ax_log_xlim) / diff(ax_log_ylim) * ax_pos_pix(4);
    ax_w_actual_nrm = ax_w_actual_pix * ax_pos_nrm(3) / ax_pos_pix(3);

    ax_l_actual_nrm = ax_pos_nrm(1) + (ax_pos_nrm(3) - ax_w_actual_nrm)/2;
    ax_pos_actual_norm = [ax_l_actual_nrm, ax_pos_nrm(2), ax_w_actual_nrm, ax_pos_nrm(4)];

end