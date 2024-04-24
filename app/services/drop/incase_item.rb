class Drop::IncaseItem < Liquid::Drop
    def initialize(incase_item)
      @incase_item = incase_item
    end
  
    def do_work # this is for check condition true/false
      "do_work"
    end

    def status_nil?
      @incase_item.incase_item_status.nil?
    end

end