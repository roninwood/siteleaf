require 'nokogiri'

## number of posts to skip lazy load on per view
NUM_SKIP_LAZY = 5


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

    # ALTERNATIVE to restricting marked posts 
    ## TO TRY:
    ## 1. comment out lines 55 - 89 below
    ## 2. comment out lines 95 and 97 (leave 96) below
    #  3. copy the <script> below to the top of the scripts section in defaul.html file (line 59)
    ## in this scenario we'd set ALL posts with data-src and set "src" on all images above the fold per page view
    ## PROS
    ## works universally, but is a bit slower and there's a noticable shift as top images load
    #  <script>
    #   function init() {
    #     const gridGroup = document.getElementsByClassName("post-body");
    #     for (var i = 0; i < 6; i++) {
    #       const image = gridGroup[i].getElementsByTagName("img");
    #       if (image.length === 0) return;
    #       if (image.getAttribute("data-src")) {
    #         image.setAttribute("src", image.getAttribute("data-src"));
    #         image.setAttribute("data-src", null);
    #       }
    #     }
    #   }
    #   window.onload = init;
    # </script> 





## START markking of posts to lazy load
     ### iterate through categories, tags, all posts
    ### if a cateogry or tags list has more than 6 posts associated with it, mark it for lazy load, this is so each of the individual tag/categories urls have their own lazy loading scope
    ### unmark first 6 posts regardless of associated tag or category so root view above the fold *never* lazy loads 
    ### NOTE: It's possible that the above the fold images will lazy load on a specific catergory OR tags url path in a case where an individual post is included in both views and
    ## that post is below the fold in one of the groupings

 ### TODO: extract shared hierchy of collection mappings => (cateogry/tags) => post into shared function pending approval from ronin / jessica
Jekyll::Hooks.register :site, :pre_render do |site|
  site.categories.each do |category|
    name = category[0]
    curr_category = site.categories[name]
    posts_per_category = curr_category.length 
    if posts_per_category > NUM_SKIP_LAZY
       sorted = curr_category.each.sort { |a,b| b.date <=> a.date}
      sorted.each_with_index do |post, index|
        if index > NUM_SKIP_LAZY
          post.data['category-index'] = true
        end
      end 
    end
  end
  site.tags.each do |tag|
    name = tag[0]
    curr_tag = site.tags[name]
    posts_per_tag= curr_tag.length 
    if posts_per_tag > NUM_SKIP_LAZY
        sorted = curr_tag.each.sort { |a,b| b.date <=> a.date}
      sorted.each_with_index do |post, index|
        if index > NUM_SKIP_LAZY
          post.data['tag-index'] = true
        end
      end 
    end
  end
  sorted = site.posts.sort { |a,b| b.date <=> a.date}
  sorted.each_with_index do |post, index|
    if index <  NUM_SKIP_LAZY 
      post.data['tag-index'] = false 
      post.data['category-index'] = false 
    end
  end
end 

## // END marking of posts to lazy load

## set data-src properties for marked posts
Jekyll::Hooks.register :posts, :post_render do |post, payload, document|
  if post.data['tag-index'] || post.data['category-index'] 
    post.content = responsive_img_src(post.content, post['title'])
  end
end


