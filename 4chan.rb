#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'set'

def main
    index = open('http://zip.4chan.org/w/imgboard.html') { |html| Hpricot(html) }
    results = index.search("span[@id *= 'nothread'] a[3]")

    thread_urls = []
    results.each { |elem| thread_urls.push(elem['href']) }

    thread_urls.each do |url|
        thread = open("http://zip.4chan.org/w/#{url}") { |html| Hpricot(html) }
        jpg_images = thread.search("a[@href *= 'jpg']")

        image_urls = Set.new
        jpg_images.each { |elem| image_urls.add(elem['href']) }

        image_urls.each do |url|
            # Store the name of the file to be downloaded into $1.
            url =~ /(\w+\.\w+)$/
            open($1, 'w').write(open(url).read)
        end
    end
end

main if __FILE__ == $0
