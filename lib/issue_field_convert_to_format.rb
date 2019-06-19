class IssueFieldConvertToFormat

  def initialize(issue, field, type)
    @issue = issue
    @type  = type
    @value = @issue.send(field)
  end

  def render
    case @type
    when :link_to_project
      "<a href='/projects/#{@value.id}'>#{@value.name}</a>"
    when :link_to_issue
      "<a href='/issues/#{@value.id}'>#{@value.subject}</a>"
    when :link_to_user
      get_link_to('users')
    when :name_association
      @value&.name.to_s
    when :date
      @value&.strftime('%d.%m.%Y').to_s
    when :boolean
      !!@value ? 'Да' : 'Heт'
    else
      @value.to_s
    end
  end

  private

  def get_link_to(base_path)
    if @value.nil?
      ''
    else
      "<a href='/#{base_path}/#{@value.id}'>#{@value.name}</a>"
    end
  end
end
