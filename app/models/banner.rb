# == Schema Information
#
# Table name: banners
#
#  id      :integer(4)      not null, primary key
#  title   :string(255)
#  content :text
#

class Banner < ActiveRecord::Base
  validates_presence_of :content

  def self.random
    banner = first(:order => "RAND()")
    banner && banner.content
  end
end