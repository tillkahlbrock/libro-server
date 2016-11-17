class Medium
    attr_accessor :id, :date, :renewal, :title

    def initialize id:, date:, renewal:, title:
        @id = id
        @date = date
        @renewal = renewal
        @title = title
    end

    def to_json *a
        {
            :id => @id,
            :date => @date,
            :renewal => @renewal,
            :title => @title,
        }.to_json *a
    end
end
