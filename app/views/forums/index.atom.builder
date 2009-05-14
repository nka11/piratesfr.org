atom_feed do |feed|
  feed.title("LinuxFr.org : les forums")
  feed.updated(@posts.first.try :created_at)

  @posts.each do |post|
    feed.entry([post.forum, post]) do |entry|
      entry.title(post.title)
      entry.content(post.body, :type => 'html')
      entry.author do |author|
        author.name(post.user.name)
      end
    end
  end
end
