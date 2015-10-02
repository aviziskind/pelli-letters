function ax_pos_actual = getModifiedAxPosition(h_ax)
    ax_pos_nrm = get(h_ax, 'position');
    set(h_ax, 'units', 'pixels')
    ax_pos_pix = get(h_ax, 'position');
    set(h_ax, 'units', 'normalized')

    
    x_axis_log = strcmp(get(h_ax, 'xscale'), 'log');
    y_axis_log = strcmp(get(h_ax, 'yscale'), 'log');
    
    ax_xlim = get(h_ax, 'xlim');
    if x_axis_log
        ax_xlim = log10(ax_xlim);
    end
    
    ax_ylim = get(h_ax, 'ylim');
    if y_axis_log
        ax_ylim = log10(ax_ylim);
    end

    ax_w_actual_pix = diff(ax_xlim) / diff(ax_ylim) * ax_pos_pix(4);
    ax_w_actual_nrm = ax_w_actual_pix * ax_pos_nrm(3) / ax_pos_pix(3);

    ax_l_actual_nrm = ax_pos_nrm(1) + (ax_pos_nrm(3) - ax_w_actual_nrm)/2;
    ax_pos_actual = [ax_l_actual_nrm, ax_pos_nrm(2), ax_w_actual_nrm, ax_pos_nrm(4)];

end