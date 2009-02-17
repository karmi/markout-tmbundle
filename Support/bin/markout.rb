#!/usr/bin/env ruby

$KCODE = 'UTF-8'

require 'erb'
require ENV['TM_SUPPORT_PATH'] + '/lib/ui.rb'

class String
  # Adapted from MultiMarkdown bundle's "Convert document do PDF"
  def unicode_escaped
    self.gsub!(/[^\x00-\x7F]/) { |ch| "&##{ch.unpack("U")[0]};" }
  end
end

tm_filename    = ENV['TM_FILENAME']  || 'untitled'

basename = (tm_filename.split('.') - [tm_filename.split('.').last]).join('.')
output_directory  = ENV['TM_DIRECTORY'] || '/tmp/'
output_basename = File.join( output_directory, basename )

template     = File.read File.join( File.dirname(__FILE__), '..', 'template.html.erb')
screen_style = File.read File.join( File.dirname(__FILE__), '..', 'screen.css')
print_style  = File.read File.join( File.dirname(__FILE__), '..', 'print.css')

html_content = $stdin.read

h1      = html_content.match(/<h1\s*.*>(.+)<\/h1>/)[1] rescue nil
author  = ENV['TM_USER'] || ENV['TM_ORGANIZATION_NAME']
title   = h1 || ENV['NAME'] || ''

html_content = ERB.new(template).result

html_content.unicode_escaped


# == Write and display HTML
File.open("#{output_basename}.html", 'w') { |f| f.write html_content }
print html_content
STDOUT.flush

if `which htmldoc` == ''
  TextMate::UI.alert(:warning, 'Markout', "htmldoc for PDF conversion not available, exiting...")
  exit 1
end

exit 0 unless TextMate::UI.request_confirmation( :title => 'Markout', :prompt => 'Generate PDF file as well?' )

# == Write and display PDF
# http://www.easysw.com/htmldoc/docfiles/8-cmdref.html
`/opt/local/bin/htmldoc -f "#{output_basename}.pdf" --bodyfont "Helvetica" --headfootfont "Helvetica" --headfootsize 8 --bottom 20 --no-compression --color --embedfonts --header "" --footer "t.1" --links --no-title --toctitle "#{h1}" --tocheader "..." --tocfooter "td/" "#{output_basename}.html"`

`open -a "Preview.app" --background #{output_basename}.pdf`
