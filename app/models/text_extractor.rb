class TextExtractor

	def initialize 
		@maillist_file = 'public/mail-list.csv'
		@maillist_uniq_file = 'public/mail-list-uniq.csv'
		@sites_file = 'public/sites.csv'
		@sites_uniq_file = 'public/sites-uniq.csv'

		if File.exist?('public/mail-list.csv') && File.exist?('public/mail-list-uniq.csv') then
			File.delete('public/mail-list.csv','public/mail-list-uniq.csv') 
		end

	end

	def scan(site)
		mechanize = Mechanize.new
		@page = mechanize.get(site)
  	end

  	def search
  		@page.search('div').each do |div|
			content_div = div.text.strip
			content_div = content_div.gsub(/\s+/m, ' ').split(" ")
			mail_list_uniq = content_div.uniq

			content_div.each do |content|
	    		write_file(@maillist_file,content) if is_email(content) != ''
	    		#write_file(@sites_file,content) if is_site_url(content)	    		
  			end
  		end
  		
  	end

	def is_email(email)
		pattern = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  		email = '' unless email.match pattern 

		return email
  	end

  	def is_site_url(url)
		pattern = /https?:\/\/[\S]+/
  		url = '' unless url.match pattern

		return url
  	end

  	def write_file(filename,content)
  		File.open(filename, 'a') { |file| file.write(content + ";") }
  	end

  	def clean_duplicate_results
  		clean_duplicate(@maillist_file,@maillist_uniq_file)
  		#clean_duplicate(@sites_file, @sites_uniq_file)
	end
  	
	def clean_duplicate(file,file_new)
  		File.open(file, "r") do |infile|
			while (line = infile.gets)
				list = line.gsub(/\s+/m, ' ').split(";")
				list_uniq = list.uniq
				list_uniq.each do |content|
					File.open(file_new, 'a') { |file2| file2.write(content + ";") }
				end
			end
		end
	end

	def print_list(file)
		list = File.open(file, "r") 
		return content = list.read
	end
  	

  	def write_new_file(filename,content)
  		File.open(filename, 'w') { |file| file.write(content) }
  	end
end
