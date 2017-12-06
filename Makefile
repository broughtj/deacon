all:
	python setup.py build_ext -if

clean:
	-rm -r build deacon/*.cpp deacon/*.so deacon/utils/*.cpp deacon/utils/*.so
