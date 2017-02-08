%.html:%.ipynb
	bash ${MAKE_DIR}/parse.sh $< $@ ${GIT_DIR} ${EXECUTE_PATH}
