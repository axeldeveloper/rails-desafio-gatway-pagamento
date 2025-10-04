# app/controllers/concerns/paginatable.rb
module Paginatable
  extend ActiveSupport::Concern

  def current_page
    [ params[:page].to_i, 1 ].max
  end

  def per_page
    per_page = params[:per_page].to_i
    per_page = 25 if per_page <= 0 || per_page > 100
    per_page
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value,
      has_next: collection.current_page < collection.total_pages,
      has_prev: collection.current_page > 1
    }
  end
end
