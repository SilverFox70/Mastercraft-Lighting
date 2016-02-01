class Production < ActiveRecord::Base

  has_and_belongs_to_many :venues
  has_many :equipment
  has_many :csv_inputs
  has_many :leads
  has_many :users, through: :leads
  belongs_to :designer, class_name: "User"
  belongs_to :master_electrician, class_name: "User"

end
