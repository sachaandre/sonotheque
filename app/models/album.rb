class Album < ApplicationRecord
    has_one_attached :cover_image
end
