#!/usr/bin/env ruby
$KCODE = 'UTF-8'

require 'erb'

tm_filename    = ENV['TM_FILENAME']  || 'untitled'
tm_author      = ENV['TM_AUTHOR']

basename = (tm_filename.split('.') - [tm_filename.split('.').last]).join('.')

output_directory  = ENV['TM_DIRECTORY'] || '/tmp/'
output_basename = File.join( output_directory, basename )

template     = File.read File.join( File.dirname(__FILE__), '..', 'template.html.erb')
screen_style = File.read File.join( File.dirname(__FILE__), '..', 'screen.css')
print_style  = File.read File.join( File.dirname(__FILE__), '..', 'print.css')

html_content = $stdin.read

h1      = html_content.match(/<h1\s*.*>(.+)<\/h1>/)[1] rescue nil
author  = ENV['TM_ORGANIZATION_NAME']
title   = h1 || ENV['NAME'] || ''

html_content = ERB.new(template).result

html_content.gsub!(/[^\x00-\x7F]/) { |ch| "&##{ch.unpack("U")[0]};" }

File.open("#{output_basename}.html", 'w') { |f| f.write html_content }

print html_content

`/opt/local/bin/htmldoc -f "#{output_basename}.pdf" --bodyfont "Helvetica" --headfootfont "Helvetica" --no-compression --color --embedfonts --header "" --footer .1. --links --no-title --toctitle "" --tocheader "..." --tocfooter "..." "#{output_basename}.html"`

`open #{output_basename}.pdf`
