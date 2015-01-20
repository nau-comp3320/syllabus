SOURCES = README.asciidoc header-include.latex
OUTPUTS = syllabus.pdf syllabus.html

all: ${OUTPUTS}

.PHONY: clean
clean:
	@rm -rf ${OUTPUTS}

syllabus.pdf: README.asciidoc header-include.latex
	asciidoctor -b docbook -o - $< | pandoc -s -f docbook -t latex -V geometry='margin=1in' -V papersize=letter -V subtitle="Course syllabus, Spring 2015" -H header-include.latex -o $@

syllabus.html: README.asciidoc
	asciidoctor -o $@ $<

.PHONY: watch
watch:
	@inotifywait -mr . -e close_write,create,moved_to,delete --format '%w%f %T' --timefmt '%s' | while read file time; do \
	  file=$${file#./}; \
	  for source in ${SOURCES}; do \
	    if [ $$source = $$file ]; then \
	    if (( $$time - $${last:-0} > 1)); then \
	        last=$$(date +'%s'); \
		make all; \
	      fi; \
	    fi; \
	  done; \
	done
