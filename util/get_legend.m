function val = get_legend(fig)

ch = get(fig, 'Children');

val = ch(arrayfun(@islegend, ch));

end