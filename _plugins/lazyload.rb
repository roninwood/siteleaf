require 'nokogiri'


    def responsive_img_src(html_source, title)
  doc = Nokogiri::HTML::Document.parse('<html></html>', nil, 'UTF-8')
  fragment = Nokogiri::HTML::DocumentFragment.new(doc, html_source)
  fragment.css('img').each do |img| 
    img['data-src'] = img['src']
    img.add_class('lazyload')
    img.attributes['src'].remove
    img['alt'] = title
  end
  return fragment.to_html
    end



Jekyll::Hooks.register :posts, :post_render do |post, payload, document|
  # only process if we deal with a markdown file
    post.content = responsive_img_src(post.content, post['title'])
end