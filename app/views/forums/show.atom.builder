atom_feed(:root_url => forum_url(@forum), "xmlns:wfw" => "http://wellformedweb.org/CommentAPI/") do |feed|
  feed.title("piratesfr.org : le forum #{@forum.title}")
  feed.updated(@posts.first.try :created_at)
  feed.icon("/favicon.png")

  @posts.each do |post|
    url = url_for([@forum, post])
    feed.entry([@forum, post], :id => "tag:piratesfr.org,2005:ForumPost/#{post.id}") do |entry|
      entry.title(post.title)
      entry.content(post.body + atom_comments_link(url), :type => 'html')
      entry.author do |author|
        author.name(post.user.name)
      end
      entry.wfw :commentRss, "http://#{MY_DOMAIN}/nodes/#{post.node.id}/comments.atom"
    end
  end
end
