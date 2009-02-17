# Markout

TextMate bundle to build *styled* HTML and PDF output of your Markdown text file for **nice looking deliverables** such as specifications, user stories, articles, ...

Started as a futile attempt to hack on MultiMarkdown's "Convert do PDF" script. Rewritten in Ruby. How _anybody_ can write Textmate commands in bash script...?

## Installation

Install via Git:

    cd ~/"Library/Application Support/TextMate/Bundles/"
    git clone git://github.com/karmi/markout-tmbundle.git "Markout.tmbundle"

You will need `htmldoc` tool for PDF generation (http://htmldoc.darwinports.com)

## Usage

Hit ⌃⌥⌘P while you have a Markdown (`text.html.markdown`) document opened.

A HTML file is generated in the same directory as your file, or in `/tmp` if the file is not saved yet.

Confirm or reject generating of PDF output in dialog.

## Customization

Fork and branch with the HTML/CSS away.

HTMLDOC command-line options here: http://www.easysw.com/htmldoc/docfiles/8-cmdref.html
