# app/controllers/concerns/filterable.rb
module Filterable
  extend ActiveSupport::Concern

  def apply_filters(scope, filter_params = {})
    scope = scope.by_status(filter_params[:status]) if filter_params[:status].present?
    scope = scope.where(country: filter_params[:country]) if filter_params[:country].present?
    scope = scope.where("created_at >= ?", Date.parse(filter_params[:created_after])) if filter_params[:created_after].present?
    scope = scope.where("created_at <= ?", Date.parse(filter_params[:created_before])) if filter_params[:created_before].present?
    scope
  rescue ArgumentError
    scope
  end

  def apply_search(scope, search_param)
    return scope unless search_param.present?
    scope.search(search_param)
  end

  def apply_sorting(scope, sort_by: "created_at", sort_order: "desc", allowed_sorts: %w[name email created_at updated_at status])
    sort_by = "created_at" unless allowed_sorts.include?(sort_by)
    sort_order = "desc" unless %w[asc desc].include?(sort_order)
    scope.order("#{sort_by} #{sort_order}")
  end
end
