class Product < ActiveRecord::Base
   before_destroy :ensure_not_referenced_by_any_line_item
   has_many :line_items
   has_many :orders, through: :line_items
   has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
   validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
   #validates_attachment_file_name :avatar, :matches => [/png\Z/, /jpe?g\Z/]
   #do_not_validate_attachment_file_type :avatar
   validates :title, :description, :image_url, presence: true
   validates :price, numericality: {greater_than_or_equal_to: 0.01}
   validates :title, uniqueness: true
   validates_attachment_presence :avatar
  
  def self.latest
    Product.order(:updated_at).last
  end
   private
 # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
       if line_items.empty?
         return true
       else
         errors.add(:base, 'Line Items present')
         return false
       end
     end
  end

