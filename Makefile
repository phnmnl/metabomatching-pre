all:

test:
	PATH=$(PATH):. ./metabomatching-test.sh

clean:
	$(RM) test/scores.tsv test/image.svg
	$(RM) -r working_dir

.PHONY: all test clean
