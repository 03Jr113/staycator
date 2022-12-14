class Review < ApplicationRecord

  has_one_attached :image

  belongs_to :user
  belongs_to :hotel
  has_many :bookmarks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  has_many :item_maps, dependent: :destroy
  has_many :items, through: :item_maps
  has_many :label_maps, dependent: :destroy
  has_many :labels, through: :label_maps

  validates :rate, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 }, presence: true
  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 200 }

  enum traveler: { couple: 0, friend: 1, family: 2, single: 3, business: 4, other: 5 }

  def bookmarked_by?(user)
    bookmarks.where(user_id: user).exists?
  end

  def save_tag(sent_tags)
    tag_list = tags.split(/[[:blank:]]+/)

    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.post_tags.delete Tag.find_by(name: old)
    end

    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end

  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no-image.png')
      image.attach(io: File.open(file_path), filename: 'no-image.png', content_type: 'image/png')
    end
    image
  end

  def self.search_for(word, method)
    if method == 'perfect'
      Review.where(title: word)
    elsif method == 'forward'
      Review.where('title LIKE ?', word + '%')
    elsif method == 'backward'
      Review.where('title LIKE ?', '%' + word)
    else
      Review.where('title LIKE ?', '%' + word + '%')
    end
  end

end
