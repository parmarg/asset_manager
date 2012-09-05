class Filter
  include MongoMapper::Document

  key :name, String
  key :available, Boolean
  key :user_id, ObjectId

  many :filter_detail
  has_many :filter_detail

end
