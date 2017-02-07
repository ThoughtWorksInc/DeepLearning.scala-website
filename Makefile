%.html:%.ipynb
	bash do_parse.sh $< $@
