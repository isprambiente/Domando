# frozen_string_literal: true

# This helper contain the methods shared for all views
#
# * include Pagy::Frontend
module ApplicationHelper
  include Pagy::Frontend

  # make a div for the font-awesome icons
  # @param [String] fa_style style of icon
  # @param [String] span_style other style for container
  # @param [String] style extra css params
  # @param [String] text inside container
  # @param [String] tooltip on mouseover
  # @param [String] title other mouseover tooltip
  # @return [String]
  def fas_icon(fa_style, span_style: nil, style: false, text: '', tooltip: false, title: '')
    content_tag_i = tag.i('', class: "fas fa-#{fa_style}", aria: { hidden: 'true' })
    span = if tooltip.present?
             tag.span(content_tag_i, class: "icon #{span_style}", style: style, title: title, data: { tooltip: tooltip })
           else
             tag.span(content_tag_i, class: "icon #{span_style}", style: style, title: title)
           end
    return span if text.blank?

    span + tag.span(text)
  end

  # generate a list for a select from an enum
  # @param list [Hash], enum option list, default {}
  # @param scope [String] scope of localization, default ''
  # @return [List]
  def t_enum(list = {}, scope = '')
    list.map { |k, _| [t(k, scope: scope), k] }
  end

  # Localize a DateTime with format :long if #obj is present
  # @param [DateTime] obj
  # @return [String] localized and formatted date
  def l_long(obj = nil)
    l(obj.try(:to_time), format: :long) if obj.present?
  end

  # Localize a DateTime with format :time if #obj is present
  # @param [DateTime] obj
  # @return [String] localized and formatted date
  def l_time(obj = nil)
    l(obj.try(:to_time), format: :time) if obj.present?
  end

  # Localize a DateTime with format :date if #obj is present
  # @param [DateTime,Date] obj
  # @return [String] localized and formatted date
  def l_date(obj = nil)
    obj.present? ? l(obj.try(:to_date), format: :date) : '-'
  end

  # Localize a fieldName if #obj is present
  # @param [Text] field_label
  # @param [Text] obj
  # @return [String] localized
  def t_field(field_label = nil, obj = '')
    return '' if field_label.blank?

    case obj
    when Class
      t(field_label, scope: "activerecord.attributes.#{obj.class}")
    when String
      t(field_label, scope: "activerecord.attributes.#{obj}")
    else
      t(field_label, default: field_label)
    end
  end

  # Convert string into Math formula
  # Require MathJax.js
  # @param [String] text
  # @return [String] localized
  def t_formula(text = '')
    text.present? ? tag.span("$#{ActionView::Base.full_sanitizer.sanitize(text)}$", class: 'is-inline is-formula') : '-'
  end

  # @param [String] text
  # @return [String]
  def t_value(text = '')
    text.presence || '-'
  end

  # Format qta into Integer if unit is equal pz
  # @param [Integer] qta
  # @param [String] unit default 'pz'
  # @param [Bool] with_unit default true
  # @return [String]
  def format_qta(qta: 0, unit: 'pz', with_unit: true)
    new_qta = if unit == 'pz'
                qta.try(:to_i)
              else
                strip_trailing_zero(qta)
              end
    "#{new_qta}#{unit if with_unit}"
  end

  # Remove zeros
  # @param [Integer] number
  # @return [String]
  def strip_trailing_zero(number, precision: 2)
    # number.to_s.sub(/\.?0+$/, '')
    number_with_precision(number, precision: precision, strip_insignificant_zeros: true)
  end

  # Remove HTML tags
  # @param [String] text
  # @return [String]
  def to_plain_text(body)
    Nokogiri::HTML(body).text.strip
  end

  # Render errors form
  # @param [Class] model resource
  # @return [String] with error tags
  def form_errors_for(resource)
    errors_for(resource.errors, scope: resource.class.table_name.singularize) if resource.errors.present?
  rescue
    ''
  end

  # Render errors
  # @param [Class] model resource
  # @return [String] with error tags
  def errors_for(errors, scope: '')
    errors.map { |e| "#{t_field(e.attribute, scope)} #{e.message}" }
  end
end
