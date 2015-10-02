function tf = isFigureDocked(fig_id)
    tf = strcmp(get(fig_id, 'WindowStyle'), 'docked');
end