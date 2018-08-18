# Makefile for LaTeX Documents #

*This is a simple and general Makefile for LaTeX documents.*

## Required dependencies ##

The Makefile should work on any Linux and Mac OS machine, but it has
only being tested on Mac OS.

To use the diff utilities you need to install `rcs-latexdiff`, available at

   https://github.com/driquet/rcs-latexdiff


## Usage ##

Place a copy of this Makefile in the root directory of your
project.

Next you must specify the name of the main .tex file. The Makefile
assumes `paper` as the default name. If your main .tex file has a
different name, then replace it at the beginning of the Makefile
accordingly:

    PAPER = your-tex-name

There are five primary targets defined:

- *default*: Compiles the document and converts the result to a PDF
   file with the same name.

- *local-diff.pdf*: Displays the latexdiff'd PDF of the current
  working version of the paper compared to the HEAD of the GIT
  repository. You may want to use this target to highlight the
  differences before pushing your contributions to the repository.

- *my-last-commit-diff.pdf*: Generates and opens a PDF file
  visualizing the changes since you last contributed to the paper. You
  may want to use this target to check the changes of your
  collaborators before editing the paper.

- *clean*: Removes temporary files, but keeps the generated PDF file.

- *cleanAll*: Removes all files, including the generated PDF file.
