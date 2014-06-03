class Image < ActiveRecord::Base
  attr_accessible :copyright, :license, :name, :original, :path, :thumb, :uploaded_by
end
