.PHONY: diagram clean

diagram: out/hierarchy.svg out/hierarchy.png out/hierarchy.pdf

out:
	mkdir -p out

out/hierarchy.svg: hierarchy.dot | out
	dot -Tsvg $< -o $@

out/hierarchy.png: hierarchy.dot | out
	dot -Tpng $< -o $@

out/hierarchy.pdf: hierarchy.dot | out
	dot -Tpdf $< -o $@

clean:
	rm -rf out
