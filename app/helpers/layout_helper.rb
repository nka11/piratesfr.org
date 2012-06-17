# encoding: utf-8
module LayoutHelper

  def body_attr
    classes = []
    classes << 'logged' if current_account
    classes << current_account.role if current_account
    classes << Rails.env if Rails.env != 'production'
    { :class => classes.join(' '), :id => "#{controller.controller_name}-#{controller.action_name}" }
  end

  def logo
    img = Logo.image
    content_tag(:h1, :title => "Le logo de PiratesFr.org", :style => "background-image: url('#{img}');") do
      link_to "PiratesFr.org", '/'
    end
  end

end
