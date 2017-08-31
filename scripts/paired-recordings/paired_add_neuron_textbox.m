function paired_add_neuron_textbox(neuron)

txt = annotation('textbox', 'String', sprintf(neuron.comment));

setx    (txt, .02,  'normalized')
sety    (txt, .9,   'normalized')
setwidth(txt, .09,  'normalized')

end