class Drop::Company < Liquid::Drop
  def initialize(source, options = {})
    super(source)
    @options = options
  end

  def id
    @source.id
  end

  def tip
    @source.tip
  end

  def inn
    @source.inn
  end

  def kpp
    @source.kpp
  end

  def title
    @source.title
  end

  def short_title
    @source.short_title
  end

  def ur_address
    @source.ur_address
  end

  def fact_address
    @source.fact_address
  end

  def ogrn
    @source.ogrn
  end

  def okpo
    @source.okpo
  end

  def bik
    @source.bik
  end

  def bank_title
    @source.bank_title
  end

  def bank_account
    @source.bank_account
  end

  def info
    @source.info
  end

  def clients
    @clients ||= liquify(*@source.clients.reject(&:new_record?))
  end

  def comments
    @comments ||= liquify(*@source.comments.reject(&:new_record?))
  end
end
