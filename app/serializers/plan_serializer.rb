class PlanSerializer
  include JSONAPI::Serializer

  set_type :plan
  attributes :name, :description, :interval, :billing_type
end
