class Tweet < ApplicationRecord
  # asssociations
  belongs_to :user
  has_many :tweet_tags
  has_many :tags, through: :tweet_tags

  # validations
  validates :message, presence: true
  validates :message, length: { maximum: 200, too_long: 'Tweets are only 200 characters max'}, on: :create

  # callbacks
  before_validation :link_check, on: :create
  after_validation :apply_link, on: :create

  private

  def apply_link
    arr = self.message.split
    index = arr.map { |x| x.include? "http"}.index(true)

    if index
      url = arr[index]
      arr[index] = "<a href='#{self.link}' target='_blank'>#{url}</a>"
    end

    self.message = arr.join(' ')
  end
  
  def link_check
    check = false
    if self.message.include?("http://") ||  self.message.include?("https://")
       check = true
    end

    if check == true
      arr = self.message.split
      index = arr.map{ |x| x.include? "http"}.index(true)
      self.link = arr[index]
      if arr[index].length > 23
        arr[index] = "#{arr[index][0..20]}..."
      end

      self.message = arr.join(" ")
    end
  end
end
