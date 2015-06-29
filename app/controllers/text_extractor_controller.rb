class TextExtractorController < ApplicationController

  def list
  	if File.exist?('public/mail-list.csv') && File.exist?('public/mail-list-uniq.csv') && File.exist?('public/sites-uniq.csv') then
		File.delete('public/mail-list.csv','public/mail-list-uniq.csv','public/sites-uniq.csv') 
	end
	text_extractor = TextExtractor.new
	File.open('public/sites.csv', "r") do |infile|
	    while (line = infile.gets)
	        site_list = line.gsub(/\s+/m, '').split(";")
	        site_list.each do |site|
	        	text_extractor.scan(site)
				text_extractor.search

	        end
	    end
	end

	text_extractor.clean_duplicate_results

	@list = text_extractor.print_list('public/mail-list-uniq.csv')

  end

  def index
  	text_extractor = TextExtractor.new
  	@list = text_extractor.print_list('public/sites.csv')
  end


  def update
  	text_extractor = TextExtractor.new
  	text_extractor.write_new_file('public/sites.csv',params[:sites])

  	redirect_to :back
  end
end
