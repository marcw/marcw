require "net/http"
require "rexml/document"

rss = Net::HTTP.get(URI("https://harmonique.one/posts.rss"))
doc = REXML::Document.new(rss)

posts = doc.get_elements("//item").map do |item|
  title = item.get_text("title").to_s
  link = item.get_text("link").to_s
  "- [#{title}](#{link})"
end

readme = File.read("README.md")
updated = readme.sub(
  /(<!--BLOG:START-->).*(<!--BLOG:END-->)/m,
  "\\1\n#{posts.join("\n")}\n\\2"
)

File.write("README.md", updated)
