class Plan

  attr_accessor :id
  attr_accessor :name
  attr_accessor :duration
  attr_accessor :price


  def initialize(id: nil, name: nil, price: 0, duration: 0)
    @id = id
    @name = name
    @price = price
    @duration = duration
  end

  class << self

    def all
      RATES.each_with_index.map do |plan, i|
        self.new(id: i+1, name: plan[:name], price: plan[:price], duration: plan[:duration])
      end
    end

    def find id
      all.select{|plan| plan.id == id}.first
    end

    def where opts
      fields = opts.keys
      all.select { |plan| fields.any? {|field| plan[field] == opts[field]} }
    end

    def first
      all.first
    end

    def pluck attribute
      all.map { |plan| plan.public_send(attribute) }
    end
  end

  def payments
    Payment.where(plan_id: id)
  end


end
