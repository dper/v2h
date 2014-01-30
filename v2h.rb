#!/usr/bin/ruby
# coding: utf-8
#
# == NAME
# v2h.rb
#
# == USAGE
# ./v2h.rb
#
# == DESCRIPTION
# Takes a VCF file containing one or more Vcards and makes an HTML file of it.
# The HTML is hCard 1.0 formatted.


require "vcard"
include Vcard

# The input contact file.
$input = 'contacts.vcf'
$output = 'contacts.html'

# Returns a string of HTML with the contact's name.
def write_name name
	html = '<div class="n">' + "\n"
	html += '<span class="fn">' + name.fullname + '</span>' + "\n"
	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML with the contact's phone numbers.
def write_telephone telephones
	if telephones.empty?
		return ''
	end
	
	html = '<div class="tel">' + "\n"

	telephones.each do |tel|
		location = tel.location.first
		if location
			html += '<span class="' + location + '">' + tel + '</span>' + "\n"
		else
			html += '<span>' + tel + '</span>' + "\n"
		end
	end

	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML with the contact's email addresses.
def write_email emails
	if emails.empty?
		return ''
	end

	html = '<div class="email">' + "\n"

	emails.each do |email|
		location = email.location.first
		if location
			html += '<span class="' + location + '">' + email + '</span>' + "\n"
		else
			html += '<span>' + email + '</span>' + "\n"
		end
	end

	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML with the contact's URLs.
def write_url urls
	if urls.empty?
		return ''
	end

	html = '<div class="url">' + "\n"

	urls.each do |url|
		link = url.uri
		html += '<span><a href="' + link + '">' + link + '</a></span>' + "\n"
	end

	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML with the contact's birthday.
def write_birthday birthday
	unless birthday
		return ''
	end

	html = '<div class="bday">'
	html += birthday.strftime("%B %-d, %Y")
	html += '</div>' + "\n"
	return html
end

# Returns true iff the address is formatted as lat/long coordinates.
# Proper coordinates are decimal numbers separated by a comma.
def is_gps_address? address
	# Blank spaces are ignored.
	address = address.gsub(' ', '')
	address = address.gsub('　', '')

	float_pattern = '(-)?[[:digit:]]+(\.)?+[[:digit:]]+'
	gps_pattern = float_pattern + ',' + float_pattern
	return (address.match gps_pattern) != nil
end

# Returns true iff the address is a U.S.-style street address.
# The country need not be a U.S. country if the formatting is the same.
def is_usa_address? address
	if address.country.empty? then return false end
	if address.postalcode.empty? then return false end
	if address.region.empty? then return false end
	if address.locality.empty? then return false end
	if address.street.empty? then return false end
	return true
end

# Returns a string of HTML for a U.S.-style street address.
# If fields are missing, they will be skipped.
# This can lead to ugly output in certain rare cases.
def write_usa_address address
	html = ""
	
	if address.street
		html += '<span class="street-address">' + address.street + '</span><br />'
	end

	if address.locality
		html += '<span class="locality">' + address.locality + '</span>, '
	end

	if address.region
		html += '<span class="region">' + address.region + '</span> '
	end

	if address.postalcode
		html += '<span class="postal-code">' + address.postalcode + '</span><br />'
	end


	if address.country
		html += '<span class="country-name">' + address.country + '</span>'
	end

	# Remove unnecessary formatting characters.
	# This only happens when some fields are missing.
	html = html.gsub(' ,<br />', '<br />')
	html = html.gsub('/<br />$/', '')

	return html
end

# Returns a string of HTML with the contact's addresses.
def write_address addresses
	if addresses.empty?
		return ''
	end

	html = '<div class="addresses">' + "\n"

	addresses.each do |address|
		html += '<div class="adr">'

		if is_gps_address? address.street
			html += '<span class="geo">' + address.street + '</span>'
		elsif address.street.start_with? '日本'
			# The address is Japanese and entirely in the street field.
			html += address.street

		elsif address.country == '日本'
			# The address is Japanese and uses multiple fields.
			html += address.country + '　'
			html += address.postalcode + ' '
			html += address.region
			html += address.locality
			html += address.street
		elsif is_usa_address? address
			# Assume the address is standard U.S. format.
		else
			# Assume the contents are entirely in the street field.
			html += '<span>' + address.street + '</span>'
		end

		html += '</div>' + "\n"
	end

	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML with the contact's categories.
def write_category categories
	if categories.empty?
		return ''
	end

	html = '<div class="categories">'

	categories.each do |category|
		html += '<span class="category">' + category + '</span>'
	end

	html += '</div>' + "\n"
	return html
end

# Converts a single Vcard to HTML.
def vcard_to_html card
	html = '<div class="vcard">' + "\n"
	html += write_name card.name
	html += write_telephone card.telephones
	html += write_email card.emails
	html += write_url card.urls
	html += write_birthday card.birthday
	html += write_address card.addresses
	html += write_category card.categories
	html += '</div>' + "\n"
	return html
end

# Takes a list of Vcards and makes HTML for them.
def write_html cards
	html = '<html>' + "\n"
	html += '<head>' + "\n"
	html += '<link rel="stylesheet" href="./contacts.css" type="text/css" />' + "\n"
	html += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' + "\n"
	html += '</head>' + "\n"
	html += '<body>' + "\n"
	html += '<h1>Contacts</h1>' + "\n"

	cards.each do |card|
		html += vcard_to_html card
	end

	html += '</body>' + "\n"
	html += '</html>' + "\n"
	return html
end

# Converts a VCF file to HTML.
# The file must consist of one or more Vcards.
def vcf_to_html
	s = File.read($input)
	cards = Vcard::Vcard.decode(s)
	html = write_html cards

	open($output, 'w') do |file|
		file.puts html
	end
end

vcf_to_html
