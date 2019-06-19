class GetCustomValue
  def initialize(issue, custom_field_id)
    @issue = issue
    @custom_field_id = custom_field_id

    @value = @issue.custom_value_for(@custom_field_id)&.value
    @custom_field = CustomField.find custom_field_id
  end

  def render
    case @custom_field.field_format
    when 'enumeration'
      @custom_field.enumerations.where(id: @value).take&.name.to_s
    when 'bool'
      get_boolean
    when 'date'
      @value&.to_date.strftime('%d.%m.%Y').to_s
    else
      @value.to_s
    end
  end

  def get_boolean
    if @value.present?
      @value.to_i == 0 ? 'Нет' : 'Да'
    else
      ''
    end
  end
end
