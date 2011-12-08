require "ohm"

class Widget < Ohm::Model
  attribute :name
  index :name
end

class Gadget < Ohm::Model
  attribute :name
  index :name
end
